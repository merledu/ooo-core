# 0006: Verify the whole core against Spike, instruction by instruction

- Status: accepted
- Date: 2026-10
- Issue: —

## Context
Waveform checks of a few programs missed bugs that only show with particular timing (flushes during stalls,
forwarding corner cases).

## Decision
`sim/core/run.py` runs every program on the core and on Spike and requires the same list of committed instructions
(pc, destination, value) and the same list of memory writes. Programs: directed asm / C (-O0 and -O2), a random
program generator, CoreMark and Dhrystone. RISCOF runs the official RV32I / RV32M tests. Three configurations
(default, small structures to provoke full / stall cases, Booth multiplier).

## Why
A mismatch points to the first wrong instruction, not just a wrong final result.

## Consequences
Every change to the core must pass `sim/scripts/run_all.sh` (and `--full` for structural changes) before it is merged.
