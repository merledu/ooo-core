# 0002: 2-way set associative BTB

- Status: accepted
- Date: 2026-10-16
- Issue: —

## Context
The direct-mapped BTB lost entries when two branches in a loop shared a row.

## Decision
`BTB_WAYS` parameter, default 2 (256 entries in 128 sets). A write goes to the way that already holds the bundle,
else to an empty way, else to the way that was not used most recently. When fetch and EX write the same entry in one
clock, EX wins (older instruction). `BTB_WAYS = 1` gives the old direct-mapped BTB.

## Why
Dhrystone mispredictions −24 % (DMIPS/MHz +0.4 %); CoreMark unchanged (2026-10-16 sweep).

## Consequences
One more tag compare and a way select on the fetch path; check it in the timing map at 6.67 ns.
`sim/unit/tb_predictors.sv` tests both `BTB_WAYS = 1` and `2`.
