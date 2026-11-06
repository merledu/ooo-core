# Verification

Tools: Verilator (5.x), `riscv32-unknown-elf-gcc`, Spike, Python 3.

## Whole core against Spike (`core/`)

`tb_core.sv` runs a program on `main_datapath` and logs every committed instruction
(pc, destination register, value) and every data memory write. `run.py` runs the same
program on the Spike ISA simulator and requires both lists to be identical.

```
cd TestBenches/core
./run.py all                        # asm/*.S, c/*.c (-O0 and -O2) and 100 random programs
./run.py random -n 500 --seed 1     # random programs (profiles: mix alu mem branch muldiv)
./run.py test c/sort.c asm/smoke.S  # chosen programs
./run.py all --config small --cov   # tiny ROB/IQ/LSQ/BIQ, 2 branch tags + coverage summary
./run.py all --config booth         # radix-4 Booth multiplier (ASIC version) instead of the DSP one
```

Useful options: `-v` (one line per test), `--vcd` (waveform in `build/core/tests/<name>/`),
`--no-build`. A failing test prints the first commit or memory write that differs.
Running the simulator by hand with `+DEBUG` prints one line per pipeline event.

* `gen_random.py` – random program generator (always terminating, small data area so loads and stores alias)
* `link.ld`, `crt0.S` – memory map and start up code (image at `0x80000000`, data from `+64 KB`)
* a program ends by writing to the `tohost` word

## Module tests (`unit/`)

```
cd TestBenches/unit
./run_unit.sh               # all tb_*.sv
./run_unit.sh tb_lsq        # one of them
```

| test | modules | what is checked |
|------|---------|-----------------|
| `tb_decode_alu` | CU, ALUCU, IG21, IG, ALU | every RV32I operation, branch condition, immediates, control signals |
| `tb_muldiv` | MUL_Unit, MUL_DSP, DIV_Unit | all RV32M operations, corner cases, flush, busy CDB (both multipliers) |
| `tb_rename` | RN_Stage, RMT, FL, BS | mapping, old mapping, no double allocation, busy bits, stalls, misprediction recovery |
| `tb_rob` | ROB | in-order commit, full, branch flush, memory violation flush |
| `tb_lsq` | LSQ, MEM_Stage | forwarding, partial overlap, store order, speculation and violation, flushes |
| `tb_data_memory` | DataMemoryWrapper, DataMemory | byte/half/word stores and loads |
| `tb_cdb_arbiter` | CDB_Arbiter | all request combinations |
| `tb_predictors` | BTB, PHT, GHR, RAS, BIQ | prediction structures |

`RAT_TestBench.sv` is the old testbench of a module which no longer exists.

## RISC-V architectural tests (`riscof/`)

The official RV32I and RV32M tests of [riscv-arch-test](https://github.com/riscv-non-isa/riscv-arch-test)
run with RISCOF: the core (`ooo_core` plugin, simulated with `core/tb_core.sv`) against Spike (`spike_ref` plugin).

```
cd TestBenches/riscof
riscof run --config=config.ini --suite <riscv-arch-test>/riscv-test-suite --env <riscv-arch-test>/riscv-test-suite/env
```

The report is written to `riscof_work/report.html`. The ISA of the core is declared as `RV32IM`
(no `Zicsr`), so the privileged tests (`ecall`, `ebreak`, misaligned access traps) are not selected.

## Benchmarks (`bench/`)

```
cd TestBenches/bench
./run_bench.py              # CoreMark and Dhrystone: cycles, IPC, CoreMark/MHz, DMIPS/MHz
./run_bench.py --check      # also compare the whole run with Spike
```

The benchmark sources are downloaded to `build/bench/src`; `coremark_port/` and `dhrystone_port/` hold the
bare metal ports. Time is not measured by the program (the core has no timer): the benchmark writes a marker
word at the start and end of its timed part and the testbench provides the clock cycle of every memory write.

## FPGA synthesis (`../Synthesis`)

```
cd Synthesis
vivado -mode batch -source synth.tcl                    # synthesis + place and route, Artix-7 xc7a100tcsg324-1
vivado -mode batch -source synth.tcl -tclargs synth     # synthesis only
```

Reports (utilization, timing) are written to `Synthesis/build/`.
