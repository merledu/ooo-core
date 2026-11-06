#!/usr/bin/env python3
"""Co-simulation runner: the core (Verilator) against the Spike ISA simulator.

  ./run.py build                         compile the testbench
  ./run.py random [-n N] [--seed S] [--profile P] [--blocks B]
                                         N random programs (profiles: mix alu mem branch muldiv all)
  ./run.py test prog.S|prog.c ...        directed assembly / C tests
  ./run.py all                           asm/*.S, c/*.c and a random regression
  options: --config small (tiny ROB/LSQ/BIQ, 2 branch tags) | booth (radix-4 Booth multiplier instead of DSP)   --cov (coverage summary)   -v   --vcd

For every program the list of committed instructions (pc, destination register, value)
and the list of data memory writes (address, data) of the core must be identical to Spike.
"""
import argparse
import concurrent.futures as cf
import os
import re
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
DESIGN = os.path.join(HERE, "..", "..", "Design")
BUILD = os.path.join(HERE, "..", "build", "core")
SIM = os.path.join(BUILD, "obj_dir", "Vtb_core")
CONFIG = "default"   # "small": tiny ROB/LSQ/BIQ and 2 branch tags (tb_core.sv, +define+SMALL), "booth": +define+BOOTH
GCC = "riscv32-unknown-elf-gcc"
OBJCOPY = "riscv32-unknown-elf-objcopy"
NM = "riscv32-unknown-elf-nm"
BASE = 0x80000000
CFLAGS = ["-march=rv32im", "-mabi=ilp32", "-nostdlib", "-nostartfiles", "-static", "-T", os.path.join(HERE, "link.ld")]


def sh(cmd, **kw):
    return subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, **kw)


def set_config(config):
    global BUILD, SIM, CONFIG
    CONFIG = config
    BUILD = os.path.join(HERE, "..", "build", "core" if config == "default" else "core_" + config)
    SIM = os.path.join(BUILD, "obj_dir", "Vtb_core")


def build():
    os.makedirs(BUILD, exist_ok=True)
    srcs = sorted(f for f in os.listdir(DESIGN) if f.endswith(".sv") and not f.startswith("tb_"))
    cmd = ["verilator", "--binary", "--timing", "-O3", "--x-assign", "unique", "--x-initial", "unique",
           "-Wno-fatal", "-Wno-lint", "-Wno-style", "--top-module", "tb_core", "-j", "8",
           "--Mdir", os.path.join(BUILD, "obj_dir"), os.path.join(HERE, "tb_core.sv")]
    if CONFIG != "default":
        cmd.append("+define+" + CONFIG.upper())
    cmd += [os.path.join(DESIGN, f) for f in srcs]
    r = sh(cmd)
    if r.returncode:
        print(r.stdout)
        sys.exit("verilator build failed")


def compile_prog(src, name, opt="-O2"):
    """returns (elf, hex, tohost address)"""
    d = os.path.join(BUILD, "tests", name)
    os.makedirs(d, exist_ok=True)
    elf = os.path.join(d, name + ".elf")
    cmd = [GCC] + CFLAGS
    if src.endswith(".c"):
        cmd += [opt, "-fno-builtin", "-ffreestanding", os.path.join(HERE, "crt0.S"), src, "-lgcc"]
    else:
        cmd += [src]
    r = sh(cmd + ["-o", elf])
    if r.returncode:
        raise RuntimeError("compile failed:\n" + r.stdout)
    binf = os.path.join(d, name + ".bin")
    sh([OBJCOPY, "-O", "binary", elf, binf], check=True)
    data = open(binf, "rb").read()
    data += b"\0" * (-len(data) % 4)
    hexf = os.path.join(d, name + ".hex")
    with open(hexf, "w") as f:
        for i in range(0, len(data), 4):
            f.write("%08x\n" % int.from_bytes(data[i:i + 4], "little"))
    tohost = None
    for line in sh([NM, elf]).stdout.splitlines():
        p = line.split()
        if len(p) == 3 and p[2] == "tohost":
            tohost = int(p[0], 16)
    return elf, hexf, tohost, d


SPIKE_RE = re.compile(r"core\s+0: 3 0x([0-9a-f]+) \(0x[0-9a-f]+\)(.*)")


def spike_trace(elf, d, tohost):
    log = os.path.join(d, "spike.log")
    r = sh(["spike", "--isa=rv32im", "--log-commits", "--log=" + log, elf], timeout=60)
    commits, writes = [], []
    for line in open(log):
        m = SPIKE_RE.match(line)
        if not m:
            continue
        pc = int(m.group(1), 16)
        if pc < BASE:
            continue   # boot rom
        tok = m.group(2).split()
        rd, val, i = 0, 0, 0
        store = None
        while i < len(tok):
            if tok[i].startswith("x") and tok[i][1:].isdigit():
                rd, val = int(tok[i][1:]), int(tok[i + 1], 16)
                i += 2
            elif tok[i] == "mem":
                if i + 2 < len(tok) and tok[i + 2].startswith("0x"):
                    store = (int(tok[i + 1], 16), tok[i + 2])
                    i += 3
                else:
                    i += 2
            else:
                i += 1
        if rd == 0:
            val = 0
        commits.append((pc, rd, val))
        if store:
            nbytes = (len(store[1]) - 2) // 2
            writes.append((store[0], int(store[1], 16), nbytes))
            if store[0] == tohost:
                break
    return commits, writes


def dut_trace(hexf, d, tohost, max_cycles, vcd=False):
    trace = os.path.join(d, "dut.trace")
    cmd = [SIM, "+HEX=" + hexf, "+TRACE=" + trace, "+TOHOST=%x" % tohost, "+MAXCYCLES=%d" % max_cycles,
           "+verilator+rand+reset+2", "+verilator+seed+%d" % (1 + sum(map(ord, hexf)) % 100000)]
    if vcd:
        cmd.append("+VCD=" + os.path.join(d, "wave.vcd"))
    r = sh(cmd, timeout=3600)
    commits, writes, end, cov = [], [], "NO END", {}
    for line in open(trace):
        p = line.split()
        if p[0] == "COV":
            cov[p[1]] = int(p[2])
        elif p[0] == "C":
            rd = int(p[2])
            commits.append((int(p[1], 16), rd, int(p[3], 16) if rd else 0))
        elif p[0] == "M":
            nbytes = 1 << int(p[3])
            writes.append((int(p[1], 16), int(p[2], 16) & ((1 << (8 * nbytes)) - 1), nbytes))
        elif p[0] == "END":
            end = line.strip()
    return commits, writes, end, cov


def run_one(src, name, max_cycles=2000000, opt="-O2", vcd=False, config="default"):
    """returns (ok, message, coverage)"""
    set_config(config)
    ok, msg, cov = False, "", {}
    try:
        ok, msg, cov = run_one_inner(src, name, max_cycles, opt, vcd)
    except Exception as e:   # noqa
        msg = "exception: %s" % e
    return ok, msg, cov


def run_one_inner(src, name, max_cycles, opt, vcd):
    elf, hexf, tohost, d = compile_prog(src, name, opt)
    if tohost is None:
        return False, "no tohost symbol", {}
    sc, sw = spike_trace(elf, d, tohost)
    dc, dw, end, cov = dut_trace(hexf, d, tohost, max_cycles, vcd)
    if not sw or sw[-1][0] != tohost:
        return False, "spike did not reach tohost (%d commits)" % len(sc), cov
    for i, s in enumerate(sc):
        if i >= len(dc):
            return False, "core stopped after %d of %d commits (next pc %08x) [%s]" % (len(dc), len(sc), s[0], end), cov
        if dc[i] != s:
            return False, ("commit %d differs:\n      core : pc=%08x x%d=%08x\n      spike: pc=%08x x%d=%08x [%s]"
                           % (i, dc[i][0], dc[i][1], dc[i][2], s[0], s[1], s[2], end)), cov
    for i, s in enumerate(sw):
        if i >= len(dw):
            return False, "core did only %d of %d memory writes [%s]" % (len(dw), len(sw), end), cov
        if dw[i] != s:
            return False, ("memory write %d differs:\n      core : [%08x]=%x (%d bytes)\n      spike: [%08x]=%x (%d bytes)"
                           % (i, dw[i][0], dw[i][1], dw[i][2], s[0], s[1], s[2])), cov
    if len(dw) != len(sw):
        return False, "core did %d memory writes, spike %d" % (len(dw), len(sw)), cov
    if not end.startswith("END DONE"):
        return False, end, cov
    m = re.search(r"cycles=(\d+) commits=(\d+) mispredicts=(\d+) violations=(\d+)", end)
    cyc, com, mis, vio = map(int, m.groups())
    return True, "%6d instr %7d cycles IPC %.2f  %4d mispredicts %3d violations" % (len(sc), cyc, com / max(cyc, 1), mis, vio), cov


def random_job(args):
    seed, profile, blocks, config = args
    set_config(config)
    name = "rand_%s_%d" % (profile, seed)
    d = os.path.join(BUILD, "tests", name)
    os.makedirs(d, exist_ok=True)
    src = os.path.join(d, name + ".S")
    sh([sys.executable, os.path.join(HERE, "gen_random.py"), str(seed), src, str(blocks), profile], check=True)
    return name, run_one(src, name, config=config)


TOTAL_COV = {}


def report(results, verbose):
    fails = 0
    for name, (ok, msg, cov) in results:
        if not ok:
            fails += 1
        for k, v in cov.items():
            TOTAL_COV[k] = TOTAL_COV.get(k, 0) + v
        if verbose or not ok:
            print("%s %-28s %s" % ("PASS" if ok else "FAIL", name, msg))
    print("%d/%d passed" % (len(results) - fails, len(results)))
    return fails


def directed_jobs(paths):
    jobs = []
    for p in paths:
        base = os.path.splitext(os.path.basename(p))[0]
        if p.endswith(".c"):
            for opt in ("-O0", "-O2"):
                jobs.append((p, base + opt.replace("-", "_"), 20000000, opt))
        else:
            jobs.append((p, base, 20000000, "-O2"))
    return jobs


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("cmd", choices=["build", "random", "test", "all"])
    ap.add_argument("files", nargs="*")
    ap.add_argument("-n", type=int, default=100)
    ap.add_argument("--seed", type=int, default=1)
    ap.add_argument("--profile", default="all")
    ap.add_argument("--blocks", type=int, default=120)
    ap.add_argument("-j", type=int, default=os.cpu_count())
    ap.add_argument("-v", action="store_true")
    ap.add_argument("--vcd", action="store_true")
    ap.add_argument("--no-build", action="store_true")
    ap.add_argument("--config", default="default", choices=["default", "small", "booth"])
    ap.add_argument("--cov", action="store_true", help="print the functional coverage summary")
    a = ap.parse_args()
    set_config(a.config)

    if not a.no_build:
        build()
    if a.cmd == "build":
        return 0
    fails = 0
    with cf.ProcessPoolExecutor(a.j) as ex:
        if a.cmd in ("test", "all"):
            files = a.files
            if a.cmd == "all":
                files = sorted(os.path.join(HERE, s, f) for s in ("asm", "c") for f in os.listdir(os.path.join(HERE, s))
                               if f.endswith((".S", ".c")))
            jobs = directed_jobs(files)
            futs = [(j[1], ex.submit(run_one, j[0], j[1], j[2], j[3], a.vcd, a.config)) for j in jobs]
            fails += report([(n, f.result()) for n, f in futs], True)
        if a.cmd in ("random", "all"):
            profiles = ["mix", "alu", "mem", "branch", "muldiv"] if a.profile == "all" else [a.profile]
            jobs = [(a.seed + i, profiles[i % len(profiles)], a.blocks, a.config) for i in range(a.n)]
            fails += report(list(ex.map(random_job, jobs)), a.v)
    if a.cov:
        print("coverage (number of cycles each situation occurred, all tests together):")
        for k, v in TOTAL_COV.items():
            print("    %-30s %10d%s" % (k, v, "" if v else "   <-- never"))
    return 1 if fails else 0


if __name__ == "__main__":
    sys.exit(main())
