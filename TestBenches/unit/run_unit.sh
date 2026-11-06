#!/bin/bash
# Runs the unit testbenches (tb_*.sv in this directory) with Verilator.
# usage: ./run_unit.sh [tb_name ...]
cd "$(dirname "$0")"
DESIGN=${DESIGN:-../../Design}
BUILD=${BUILD:-../build/unit}
mkdir -p $BUILD
tbs="$@"
[ -z "$tbs" ] && tbs=$(ls tb_*.sv | sed 's/\.sv$//')
fail=0
for tb in $tbs; do
    if ! verilator --binary --timing --timescale 1ns/1ps -Wno-fatal -Wno-lint -Wno-style --x-assign unique --x-initial unique \
         --top-module $tb --Mdir $BUILD/$tb -y $DESIGN $tb.sv > $BUILD/$tb.build.log 2>&1; then
        echo "FAIL $tb (build, see $BUILD/$tb.build.log)"; fail=1; continue
    fi
    out=$($BUILD/$tb/V$tb +verilator+rand+reset+2 2>&1 | grep -E "^(PASS|FAIL)" | head -25)
    echo "$out"
    # a test passes only if it says so (a crash or a silent exit is a failure)
    if ! echo "$out" | grep -q "^PASS" || echo "$out" | grep -q "^FAIL"; then
        echo "$out" | grep -q "^FAIL" || echo "FAIL $tb (no result)"
        fail=1
    fi
done
exit $fail
