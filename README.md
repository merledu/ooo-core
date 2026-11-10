# ooo-core

A **2-wide, 12-stage out-of-order RISC-V processor** (RV32IM), written in SystemVerilog.

It runs two instructions per clock, executes them out of order, and finishes them in program order.
Every instruction it commits is checked against Spike, the official RISC-V simulator.

![ooo-core datapath](docs/images/ooo_core_datapath.png)

<sub>Editable diagram: [`docs/diagrams/ooo_core_datapath.drawio`](docs/diagrams/ooo_core_datapath.drawio) (open in draw.io)</sub>

## Features

- **12-stage pipeline**: each instruction uses only the stages it needs; an ALU instruction
  takes 8 cycles from fetch to commit, a load 11 ([pipeline depth](#pipeline-depth)).
- **2-wide superscalar**: fetches, renames and commits two instructions per clock.
- **Fast branch recovery**: up to 8 branches in flight, each with a saved copy of the rename table.
  A wrong prediction removes only the instructions after that branch.
- **Speculative loads**: loads can run before older stores. Data is forwarded from the store queue
  byte by byte, and the core recovers if a load ran too early.
- **Many execution units**: two ALUs, two address units, a pipelined multiplier and a divider.
- **Branch prediction**: gshare, 2-way BTB and return address stack, repaired after every wrong prediction.
- **Configurable**: queue sizes, branch count and predictor sizes are parameters;
  FPGA (DSP) or ASIC (Booth) multiplier.
- **Verified against Spike**: every instruction and memory write, in three configurations;
  RISCOF RV32I + RV32M 47/47.

## How it works

1. **Predict and fetch**: the predictor picks the next two instructions to fetch.
2. **Decode**: instructions are decoded; branches are recorded so the predictor learns from them later.
3. **Rename**: 32 registers are mapped onto 64 physical registers, so independent instructions don't wait.
4. **Dispatch and issue**: instructions wait in an issue queue and start as soon as their inputs are ready.
5. **Execute and memory**: results go out on a shared result bus; loads and stores go through a load/store queue.
6. **Commit**: the reorder buffer finishes up to two instructions per clock, in program order.

### Pipeline depth

The pipeline has 12 stages:

```
predict → fetch → decode → rename → dispatch → issue → register read → execute → LSQ → memory → writeback → commit
```

Not every instruction goes through all of them, and some stages share a clock cycle
(rename and dispatch always; execute and writeback for ALU results). So the number of cycles
depends on the instruction:

| Instruction | Stages it goes through | Cycles from fetch to commit |
|---|---|---|
| ALU, branch, jump | all except LSQ and memory | **8** |
| Store | all 12; the memory is written 1 cycle after commit | **8** |
| Load | all 12 | **11** |
| `mul` (FPGA, DSP multiplier) | all except LSQ and memory; execute takes 3 more cycles | **11** |
| `mul` (ASIC, Booth multiplier) | all except LSQ and memory; execute takes 18 more cycles | **26** |
| `div`, `rem` | all except LSQ and memory; execute takes 18 more cycles | **26** |

A mispredicted branch is found in execute (cycle 7) and fetch restarts at the right address in the
next cycle, so a misprediction costs 6 cycles.

These are the shortest times, with no waiting. An instruction can also wait in the issue queue for its
inputs, for a free result bus lane, or in the reorder buffer for older instructions to commit.
Measured in simulation (`+DEBUG` trace of `sim/core/tb_core.sv`), ideal one-cycle memories.

More detail: [architecture](docs/spec/architecture.md) · [design decisions](docs/decisions/) · [measured results](docs/scorecard.md)

## Results

| | |
|---|---|
| ISA | RV32IM (no CSRs or traps yet) |
| CoreMark | **3.53 CoreMark/MHz** |
| Dhrystone | **1.70 DMIPS/MHz** |
| Correctness | matches Spike on 111 test programs, CoreMark and Dhrystone; RISCOF 47/47 |

Measured in simulation with ideal one-cycle memories.

RISCOF report (all 47 RV32I + RV32M tests passed): `report.html` in the
[v0.2.0 release](https://github.com/merledu/ooo-core/releases/tag/v0.2.0).
To make it yourself, see [RISC-V architectural tests](sim/README.md#risc-v-architectural-tests-riscof);
it is written to `sim/riscof/riscof_work/report.html`.

## Status

| Done | In progress | Planned |
|---|---|---|
| All 12 pipeline stages, verified against Spike | Timing closure on Artix-7 (xc7a100t-1) | Running on the FPGA, CSRs and traps, caches, Linux |

Versions and plans: [`docs/roadmap.md`](docs/roadmap.md) · changes: [`CHANGELOG.md`](CHANGELOG.md)

## Quick start

You need Verilator 5, `riscv32-unknown-elf-gcc`, Spike and Python 3 (Vivado for the FPGA).

```bash
sim/scripts/run_all.sh          # unit tests + the core against Spike
sim/scripts/run_all.sh --full   # also all configurations, CoreMark and Dhrystone
sim/bench/run_bench.py          # benchmarks only
cd fpga && vivado -mode batch -source synth.tcl   # synthesis + place and route
```

More options: [`sim/README.md`](sim/README.md)

## Repository

| Folder | Contents |
|---|---|
| `rtl/` | the processor, one folder per pipeline section (`rtl/rtl.f` lists every file) |
| `sim/` | testbenches, Spike comparison, RISCOF, benchmarks |
| `fpga/` | Vivado scripts for the Artix-7 |
| `docs/` | architecture, design decisions, results |

Full map: [`STRUCTURE.md`](STRUCTURE.md)

## Contributing

Read [`CONTRIBUTING.md`](CONTRIBUTING.md) first. In short: one issue per task, one branch per issue,
a pull request into `main`, and a review before merging.

## Team

| Name | Role | GitHub |
|---|---|---|
| Mutahir Ahmed Siddiqui | Research Fellow @ Micro Electronics Research Lab - UITU | [@HafizMutahirAhmed](https://github.com/HafizMutahirAhmed) |
