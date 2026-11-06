# Scorecard

Measured results only. Every number says where it came from. Numbers from an older build of the core are marked
with their date and replaced when the measurement is redone.

Configuration: the defaults of `rtl/top/main_datapath.sv` (ROB 64, IQ 32, LQ 16, SQ 32, 64 physical registers,
8 branch tags, gshare 12 bits, BTB 256 × 2 ways, `USE_DSP_MUL = 1`, `DMEM_DUAL_PORT = 0`), ideal one-cycle
instruction and data memories, programs compiled with `-O2 -march=rv32im`.

## Performance

| Benchmark | Score | IPC | Mispredictions / 1000 instr | Memory order flushes | Source |
|---|---|---|---|---|---|
| CoreMark (4 iterations) | **3.534 CoreMark/MHz** | 1.015 | 19.8 | 269 | `sim/bench/run_bench.py --check`, 2026-11-06 |
| Dhrystone 2.1 (500 iterations) | **1.302 DMIPS/MHz** | 1.220 | 11.5 | 1000 | same |

Reference point: NaxRiscv, 5.02 CoreMark/MHz, 2.93 DMIPS/MHz.

## Correctness

| Suite | Result | Source |
|---|---|---|
| Directed asm / C programs (-O0 and -O2) + 100 random programs, default configuration | 111 / 111 identical to Spike | `sim/core/run.py all`, 2026-11-06 |
| Same, `--config small` (ROB 16, IQ 8, LQ 8, SQ 4, 2 branch tags) | 111 / 111 | `run.py all --config small` |
| Same, `--config booth` (radix-4 Booth multiplier) | 110 / 111 (`rand_mix_36` fails: reset-write bug, see below) | `run.py all --config booth` |
| RISCOF RV32I + RV32M architectural tests | 47 / 47 | `sim/riscof`, report in `sim/riscof/riscof_work/report.html` |
| CoreMark, Dhrystone: every commit and memory write | identical to Spike | `run_bench.py --check` |
| Module tests | 8 / 8 | `sim/unit/run_unit.sh` |

**Known bug:** the LSQ writes the data memory once during reset (`lsq_mem_write` is not gated by `reset`, and the SQ
pointers are random until the first clock edge). Which word gets corrupted depends on the random initial values, which
`run.py` seeds from the program's path, so moving the repository changed which test shows it. See `CHANGELOG.md`.

## Resources and frequency (Artix-7 xc7a100tcsg324-1, out of context)

| Build | Slice LUTs (of 63 400) | Registers | BRAM tiles | DSP | Fmax | Source |
|---|---|---|---|---|---|---|
| Post-synthesis, 2026-10-16 | 63 016 (99.4 %) | 38 485 | 1 | 4 | 31.8 MHz | `fpga/synth.tcl -tclargs synth` |
| Post-route, 2026-10-12 (older configuration, Booth multiplier) | 52 081 (82.2 %) | 30 326 | 1 | 0 | 29.6 MHz | `fpga/synth.tcl` / `impl.tcl` at 32 ns |
| Target (`v0.3.0`) | | | | | 150 MHz | |

The paths that limit the clock (timing map at 6.67 ns, 2026-10-16): the EX forwarding + ALU + branch resolution
feeding the flush of every module, the LSQ load select + store queue search + forwarding in one cycle, the
issue-queue select with the multiplier busy / stall signals, redirect → next PC → BTB lookup, and
issue-queue full → front-end stall → instruction memory.
