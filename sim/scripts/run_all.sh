#!/bin/bash
# Runs the regression of the core with Verilator.
# Usage: sim/scripts/run_all.sh            (from any directory)
#        sim/scripts/run_all.sh --full     (also the small / booth configurations and the benchmarks)
#
#   1. unit tests          sim/unit/run_unit.sh
#   2. core against Spike  sim/core/run.py all   (directed asm / C programs and 100 random programs)
#   3. --full only         run.py all --config small, run.py all --config booth, bench/run_bench.py --check
#
# Needs Verilator 5, riscv32-unknown-elf-gcc and Spike on the PATH (see sim/README.md).
# Build output goes to sim/build/ (ignored by git).
# Exit code: 0 if every step passes, else 1.
cd "$(dirname "$0")/../.."          # -> repository root

FULL=0
[ "$1" = "--full" ] && FULL=1

FAILED=0
step() {   # step <name> <command ...>
    echo "=== $1 ==="
    shift
    if "$@"; then echo "  -> PASS"; else echo "  -> FAILED"; FAILED=$((FAILED + 1)); fi
    echo
}

step "unit tests"                 sim/unit/run_unit.sh
step "core vs Spike (default)"    sim/core/run.py all
if [ "$FULL" -eq 1 ]; then
    step "core vs Spike (small)"  sim/core/run.py all --config small
    step "core vs Spike (booth)"  sim/core/run.py all --config booth
    step "benchmarks vs Spike"    sim/bench/run_bench.py --check
fi

if [ "$FAILED" -eq 0 ]; then
    echo "RESULT: all steps PASS"
else
    echo "RESULT: $FAILED step(s) FAILED"
    exit 1
fi
