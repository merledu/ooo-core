import os
import shutil
import logging

import riscof.utils as utils
from riscof.pluginTemplate import pluginTemplate

logger = logging.getLogger()

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, "..", "..", ".."))
MEM_WORDS = 1 << 21   # 8 MB image (jal-01 alone is about 2 MB)


class ooo_core(pluginTemplate):
    """DUT plugin: the out-of-order core simulated with Verilator (TestBenches/core/tb_core.sv)."""
    __model__ = "ooo_core"
    __version__ = "1.0"

    def __init__(self, *args, **kwargs):
        sclass = super().__init__(*args, **kwargs)
        config = kwargs.get('config')
        if config is None:
            print("Please enter input file paths in configuration.")
            raise SystemExit(1)
        self.num_jobs = str(config['jobs'] if 'jobs' in config else 1)
        self.pluginpath = os.path.abspath(config['pluginpath'])
        self.isa_spec = os.path.abspath(config['ispec'])
        self.platform_spec = os.path.abspath(config['pspec'])
        self.target_run = not ('target_run' in config and config['target_run'] == '0')
        self.build_dir = os.path.join(REPO, "TestBenches", "build", "core_riscof")
        self.sim = os.path.join(self.build_dir, "obj_dir", "Vtb_core")
        return sclass

    def initialise(self, suite, work_dir, archtest_env):
        self.work_dir = work_dir
        self.suite_dir = suite
        # -mno-relax: linker relaxation would shrink the aligned code of the tests with 16 bit (compressed) nops
        self.compile_cmd = ('riscv{1}-unknown-elf-gcc -march={0} -static -mcmodel=medany -fvisibility=hidden '
                            '-nostdlib -nostartfiles -mno-relax -g -T ' + self.pluginpath + '/env/link.ld -I ' + self.pluginpath +
                            '/env/ -I ' + archtest_env + ' {2} -o {3} {4}')

    def build(self, isa_yaml, platform_yaml):
        ispec = utils.load_yaml(isa_yaml)['hart0']
        self.xlen = ('64' if 64 in ispec['supported_xlen'] else '32')
        self.compile_cmd = self.compile_cmd + ' -mabi=' + ('lp64 ' if 64 in ispec['supported_xlen'] else 'ilp32 ')
        # build the simulator of the core
        design = os.path.join(REPO, "Design")
        srcs = sorted(os.path.join(design, f) for f in os.listdir(design) if f.endswith(".sv") and not f.startswith("tb_"))
        os.makedirs(self.build_dir, exist_ok=True)
        cmd = ("verilator --binary --timing -O3 --x-assign unique --x-initial unique -Wno-fatal -Wno-lint -Wno-style "
               "--top-module tb_core -j 8 +define+TB_MEM_WORDS=%d --Mdir %s %s %s > %s 2>&1" %
               (MEM_WORDS, os.path.join(self.build_dir, "obj_dir"), os.path.join(REPO, "TestBenches", "core", "tb_core.sv"),
                " ".join(srcs), os.path.join(self.build_dir, "build.log")))
        logger.info("Building the simulator of the core")
        if os.system(cmd) != 0 or shutil.which(self.sim) is None:
            logger.error("verilator build failed, see " + os.path.join(self.build_dir, "build.log"))
            raise SystemExit(1)

    def runTests(self, testList):
        if os.path.exists(self.work_dir + "/Makefile." + self.name[:-1]):
            os.remove(self.work_dir + "/Makefile." + self.name[:-1])
        make = utils.makeUtil(makefilePath=os.path.join(self.work_dir, "Makefile." + self.name[:-1]))
        make.makeCommand = 'make -k -j' + self.num_jobs
        for testname in testList:
            testentry = testList[testname]
            test = testentry['test_path']
            test_dir = testentry['work_dir']
            elf = 'dut.elf'
            sig_file = os.path.join(test_dir, self.name[:-1] + ".signature")
            compile_macros = ' -D' + " -D".join(testentry['macros'])
            cmd = self.compile_cmd.format(testentry['isa'].lower(), self.xlen, test, elf, compile_macros)
            if self.target_run:
                # elf -> hex image, symbols -> plusargs, run the core, write the signature
                sim = ('riscv32-unknown-elf-objcopy -O binary {0} dut.bin; '
                       'riscv32-unknown-elf-objdump -d {0} > dut.disass; '
                       'python3 {1}/bin2hex.py dut.bin dut.hex; '
                       'sym() {{ riscv32-unknown-elf-nm {0} | awk -v s=$$1 \'$$3==s{{print $$1}}\'; }}; '
                       '{2} +HEX=dut.hex +TRACE=dut.trace +TOHOST=$$(sym tohost) +SIG={3} +SIG_BEGIN=$$(sym begin_signature) '
                       '+SIG_END=$$(sym end_signature) +MAXCYCLES=100000000 +verilator+rand+reset+2 > dut.log 2>&1').format(
                           elf, self.pluginpath, self.sim, sig_file)
            else:
                sim = 'echo "NO RUN"'
            make.add_target('@cd {0}; {1}; {2};'.format(test_dir, cmd, sim))
        make.execute_all(self.work_dir)
        if not self.target_run:
            raise SystemExit(0)
