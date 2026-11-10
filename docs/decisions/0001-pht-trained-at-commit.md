# 0001: Train the PHT when a branch commits

- Status: accepted
- Date: 2026-10
- Issue: —

## Context
The PHT used to be updated when a conditional branch resolved in EX. Branches on a wrong path also resolve
in EX before the older misprediction squashes them, so they trained the counters with outcomes that never happen.

## Decision
The BIQ records each conditional branch's outcome when it resolves (`resolve_cond`, `resolve_taken`). When the
branch commits, the BIQ trains the PHT with it, one branch per clock (`train_pht`, `train_pht_index`). A BIQ entry
is freed only after it has trained the PHT (`train_ptr` follows the head).

## Why
Only committed (real) outcomes reach the counters.

## Consequences
- Training comes later than before, so a branch that runs again soon after sees an older counter. With a much
  larger window (ROB 128, IQ 64, 16 branch tags) mispredictions rose from 19 to 24 per 1000 instructions on
  CoreMark for that reason (2026-10-16 sweep).
- The BIQ can stay full one clock longer while the oldest entry trains.
