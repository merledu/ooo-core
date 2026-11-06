import os
import shutil
import logging

import riscof.utils as utils
from riscof.pluginTemplate import pluginTemplate

logger = logging.getLogger()


class spike_ref(pluginTemplate):
    """Reference plugin: Spike ISA simulator."""
    __model__ = "spike"
    __version__ = "1.1.1-dev"

    def __init__(self, *args, **kwargs):
        sclass = super().__init__(*args, **kwargs)
        config = kwargs.get('config')
        self.ref_exe = os.path.join(config['PATH'] if 'PATH' in config else "", "spike")
        self.num_jobs = str(config['jobs'] if 'jobs' in config else 1)
        self.pluginpath = os.path.abspath(config['pluginpath'])
        return sclass

    def initialise(self, suite, work_dir, archtest_env):
        self.work_dir = work_dir
        if shutil.which(self.ref_exe) is None:
            logger.error('spike not found')
            raise SystemExit(1)
        # -mno-relax: linker relaxation would shrink the aligned code of the tests with 16 bit (compressed) nops
        self.compile_cmd = ('riscv{1}-unknown-elf-gcc -march={0} -static -mcmodel=medany -fvisibility=hidden '
                            '-nostdlib -nostartfiles -mno-relax -T ' + self.pluginpath + '/env/link.ld -I ' + self.pluginpath +
                            '/env/ -I ' + archtest_env + ' {2} -o {3} {4}')

    def build(self, isa_yaml, platform_yaml):
        ispec = utils.load_yaml(isa_yaml)['hart0']
        self.xlen = ('64' if 64 in ispec['supported_xlen'] else '32')
        self.isa = 'rv' + self.xlen
        for ext in "imacfd":
            if ext.upper() in ispec["ISA"][4:]:
                self.isa += ext
        self.compile_cmd = self.compile_cmd + ' -mabi=' + ('lp64 ' if 64 in ispec['supported_xlen'] else 'ilp32 ')

    def runTests(self, testList, cgf_file=None):
        if os.path.exists(self.work_dir + "/Makefile." + self.name[:-1]):
            os.remove(self.work_dir + "/Makefile." + self.name[:-1])
        make = utils.makeUtil(makefilePath=os.path.join(self.work_dir, "Makefile." + self.name[:-1]))
        make.makeCommand = 'make -k -j' + self.num_jobs
        for testname in testList:
            testentry = testList[testname]
            test = testentry['test_path']
            test_dir = testentry['work_dir']
            elf = 'ref.elf'
            sig_file = os.path.join(test_dir, self.name[:-1] + ".signature")
            compile_macros = ' -D' + " -D".join(testentry['macros'])
            cmd = self.compile_cmd.format(testentry['isa'].lower(), self.xlen, test, elf, compile_macros)
            sim = self.ref_exe + ' --isa={0} +signature={1} +signature-granularity=4 {2} > ref.log 2>&1'.format(self.isa, sig_file, elf)
            make.add_target('@cd {0}; {1}; {2};'.format(test_dir, cmd, sim))
        make.execute_all(self.work_dir)
