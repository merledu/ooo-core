# 0007: 150 MHz on the xc7a100t-1 and more than 5 CoreMark/MHz

- Status: accepted
- Date: 2026-11-10
- Issue: —

## Context
v0.2.0 measures 3.53 CoreMark/MHz (IPC 1.015) and 1.30 DMIPS/MHz in simulation, 31.8 MHz after synthesis
and 99.4 % of the LUTs of the xc7a100tcsg324-1 ([scorecard](../scorecard.md)). The reference
dual-issue out-of-order core, NaxRiscv, gives 5.02 CoreMark/MHz, 2.93 DMIPS/MHz and 155 MHz on a -3 Artix-7
(the -1 part is about 15-25 % slower). Changes for frequency usually add cycles (lower CoreMark/MHz), and
changes for IPC usually add logic (lower frequency), so both targets have to be fixed before the work starts.

## Decision
1. Targets, both at the same time, on the xc7a100tcsg324-1 (slowest speed grade):
   - **150 MHz** after place and route (6.67 ns, no negative slack);
   - **more than 5.0 CoreMark/MHz** in simulation with the default configuration
     (IPC about 1.45 on CoreMark); Dhrystone above 2.5 DMIPS/MHz.
2. Order: **frequency and area first** (`v0.3.0`), then **IPC** (`v0.4.0`). The frequency work changes the
   shape of the pipeline (registered flush, split paths, split issue queues), so the IPC work tunes the final
   structure instead of being done twice.
3. Every later version (CSRs, caches, board, Linux) **keeps both targets**: a change that breaks 150 MHz or
   drops CoreMark/MHz below 5 needs its own decision.
4. Every change for frequency or IPC is measured before it is merged: full regression
   (`sim/scripts/run_all.sh --full`), CoreMark/MHz and Dhrystone (`sim/bench/run_bench.py --check`) and timing
   (`fpga/timing_map.tcl` at 6.67 ns). The numbers go in the PR and in `docs/scorecard.md`.

## Why
- 150 MHz on a -1 part is about 180 MHz on a -3: the per-cycle budget is 5-6 levels of logic plus routing,
  so it cannot be reached by tuning; it is a design target for every path.
- Area is part of the frequency work: at 99.4 % of the LUTs, routing congestion costs a large part of the
  cycle. Moving the big arrays (physical registers, ROB payload, branch snapshots, store queue data) into
  LUT-RAM frees space for timing and later for caches, MMU and peripherals.
- From 3.53 to more than 5 CoreMark/MHz is +42 %. The causes are measured and known: memory order flushes
  (269 in CoreMark, 2 per iteration in Dhrystone), issue select by slot instead of age (old instructions
  waited about 35 cycles in a test), about 20 mispredictions per 1000 instructions with a 6-cycle penalty,
  and the 8-byte aligned fetch bundle.

## Consequences
- `v0.3.0` may lower CoreMark/MHz; the budget is down to about 3.2. `v0.4.0` must win it back and go past 5.
- Area target for `v0.3.0`: at most about 60 % of the LUTs, so that caches, the MMU and the SoC
  (memory controller, UART, CLINT, PLIC) still fit.
- Possible structural changes: split issue queues (ALU / memory / mul-div), a branch resolution stage after
  the ALU, a two-cycle LSQ search, a fetch queue between prediction and fetch. Each one gets its own issue and,
  if it changes the architecture, its own decision.
- Plan per version: [`docs/roadmap.md`](../roadmap.md).
