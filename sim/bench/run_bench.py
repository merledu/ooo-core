#!/usr/bin/env python3
"""Benchmarks of the core: CoreMark and Dhrystone.

  ./run_bench.py                 both benchmarks
  ./run_bench.py coremark -n 4   CoreMark with 4 iterations
  ./run_bench.py --check         also compare every committed instruction with Spike

The sources are downloaded to ../build/bench/src (CoreMark from github.com/eembc/coremark, Dhrystone 2.1
from riscv-tests). The benchmark writes a marker word when its timed part starts and ends; the testbench
logs the clock cycle of every commit and memory write, so cycles and instructions of the timed part are exact.
"""
import argparse
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "..", "core"))
import run as R   # noqa: E402

BUILD = os.path.join(HERE, "..", "build", "bench")
SRC = os.path.join(BUILD, "src")
CC = ["riscv32-unknown-elf-gcc", "-march=rv32im", "-mabi=ilp32", "-O2", "-static", "-nostdlib", "-nostartfiles",
      "-T", os.path.join(HERE, "..", "core", "link.ld")]
# CoreMark keeps the freestanding build. Dhrystone is built with GCC builtins enabled, as in riscv-tests:
# strcpy of a constant string becomes word copies instead of a call to the byte loop of dhrystone_port/port.c.
CC_COREMARK = CC + ["-ffreestanding", "-fno-builtin"]
CRT0 = os.path.join(HERE, "..", "core", "crt0.S")


def sh(cmd, **kw):
    r = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, **kw)
    if r.returncode:
        sys.exit("command failed: %s\n%s" % (" ".join(cmd), r.stdout))
    return r.stdout


def fetch():
    os.makedirs(SRC, exist_ok=True)
    if not os.path.exists(os.path.join(SRC, "coremark", "core_main.c")):
        sh(["git", "clone", "-q", "--depth", "1", "https://github.com/eembc/coremark.git", os.path.join(SRC, "coremark")])
    d = os.path.join(SRC, "dhrystone")
    os.makedirs(d, exist_ok=True)
    for f in ("dhrystone.c", "dhrystone.h", "dhrystone_main.c"):
        if not os.path.exists(os.path.join(d, f)):
            sh(["curl", "-sfL", "-o", os.path.join(d, f),
                "https://raw.githubusercontent.com/riscv-software-src/riscv-tests/master/benchmarks/dhrystone/" + f])


def build(name, iterations):
    d = os.path.join(BUILD, name)
    os.makedirs(d, exist_ok=True)
    elf = os.path.join(d, name + ".elf")
    if name == "coremark":
        cm = os.path.join(SRC, "coremark")
        port = os.path.join(HERE, "coremark_port")
        srcs = [os.path.join(cm, f) for f in ("core_list_join.c", "core_main.c", "core_matrix.c", "core_state.c", "core_util.c")]
        cmd = CC_COREMARK + ["-I", port, "-I", cm, "-DITERATIONS=%d" % iterations, "-DPERFORMANCE_RUN=1", '-DFLAGS_STR="-O2"',
                    CRT0, os.path.join(port, "core_portme.c")] + srcs
    else:
        port = os.path.join(HERE, "dhrystone_port")
        # the number of runs is a #define in the header: a patched copy of the sources is compiled
        for f in ("dhrystone.c", "dhrystone.h", "dhrystone_main.c"):
            text = open(os.path.join(SRC, "dhrystone", f)).read()
            if f == "dhrystone.h":
                lines = [("#define NUMBER_OF_RUNS %d" % iterations) if l.startswith("#define NUMBER_OF_RUNS") else l
                         for l in text.split("\n")]
                text = "\n".join(lines)
            open(os.path.join(d, f), "w").write(text)
        cmd = CC + ["-I", port, "-I", d, "-w", "-std=gnu89",
                    CRT0, os.path.join(port, "port.c"), os.path.join(d, "dhrystone.c"), os.path.join(d, "dhrystone_main.c")]
    sh(cmd + ["-lgcc", "-o", elf])
    binf = os.path.join(d, name + ".bin")
    sh(["riscv32-unknown-elf-objcopy", "-O", "binary", elf, binf])
    data = open(binf, "rb").read()
    data += b"\0" * (-len(data) % 4)
    hexf = os.path.join(d, name + ".hex")
    with open(hexf, "w") as f:
        for i in range(0, len(data), 4):
            f.write("%08x\n" % int.from_bytes(data[i:i + 4], "little"))
    syms = {}
    for line in sh(["riscv32-unknown-elf-nm", elf]).splitlines():
        p = line.split()
        if len(p) == 3:
            syms[p[2]] = int(p[0], 16)
    return d, elf, hexf, syms


def run(name, iterations, check):
    d, elf, hexf, syms = build(name, iterations)
    trace = os.path.join(d, "dut.trace")
    sh([R.SIM, "+HEX=" + hexf, "+TRACE=" + trace, "+TOHOST=%x" % syms["tohost"], "+MAXCYCLES=400000000"])
    marker = "%08x" % syms["bench_marker"]
    tohost = "%08x" % syms["tohost"]
    start = stop = None
    instr = 0
    exit_code = None
    cov = {}
    total = ""
    for line in open(trace):
        p = line.split()
        if p[0] == "C":
            if start is not None and stop is None:
                instr += 1
        elif p[0] == "M":
            if p[1] == marker and int(p[2], 16) == 1 and start is None:
                start = int(p[4])
            elif p[1] == marker and int(p[2], 16) == 2:
                stop = int(p[4])
            elif p[1] == tohost:
                exit_code = int(p[2], 16) >> 1
        elif p[0] == "COV":
            cov[p[1]] = int(p[2])
        elif p[0] == "END":
            total = line.strip()
    if start is None or stop is None or exit_code != 0:
        sys.exit("%s did not finish correctly (start=%s stop=%s exit code=%s) %s" % (name, start, stop, exit_code, total))
    cycles = stop - start
    print("\n%s (%d iterations, -O2, rv32im%s)" % (name, iterations,
                                                  ", -ffreestanding -fno-builtin" if name == "coremark" else ", builtins on"))
    print("    timed part            : %d cycles, %d instructions" % (cycles, instr))
    print("    IPC                   : %.3f" % (instr / cycles))
    print("    cycles per iteration  : %.0f   (instructions per iteration: %.0f)" % (cycles / iterations, instr / iterations))
    if name == "coremark":
        print("    CoreMark/MHz          : %.3f" % (iterations * 1e6 / cycles))
    else:
        print("    DMIPS/MHz             : %.3f   (Dhrystones per second per MHz / 1757)" % (iterations * 1e6 / cycles / 1757))
    print("    branch mispredictions : %d (%.1f per 1000 instructions)   memory order flushes: %d" %
          (cov.get("branch_mispredict", 0), 1000.0 * cov.get("branch_mispredict", 0) / max(instr, 1), cov.get("memory_violation_flush", 0)))
    if check:
        sc, sw = R.spike_trace(elf, d, syms["tohost"])
        dc, dw, end, _ = R.dut_trace(hexf, d, syms["tohost"], 400000000)
        ok = (dc[:len(sc)] == sc) and (dw == sw)
        print("    compared with Spike   : %s (%d instructions, %d memory writes)" % ("identical" if ok else "DIFFERENT", len(sc), len(sw)))
        if not ok:
            sys.exit(1)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("bench", nargs="?", default="all", choices=["all", "coremark", "dhrystone"])
    ap.add_argument("-n", type=int, default=0, help="iterations (default: 4 for CoreMark, 500 for Dhrystone)")
    ap.add_argument("--check", action="store_true", help="compare the whole run with Spike")
    ap.add_argument("--no-build", action="store_true", help="do not rebuild the simulator")
    a = ap.parse_args()
    if not a.no_build:
        R.build()
    fetch()
    if a.bench in ("all", "coremark"):
        run("coremark", a.n or 4, a.check)
    if a.bench in ("all", "dhrystone"):
        run("dhrystone", a.n or 500, a.check)


if __name__ == "__main__":
    main()
