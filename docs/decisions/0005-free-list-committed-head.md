# 0005: Free list recovery by following the committed head

- Status: accepted
- Date: 2026-10
- Issue: —

## Context
After a memory order flush everything not committed is dropped. The free list used to rebuild itself from the
architectural map table: a loop over every physical register in one clock, which is large and slow.

## Decision
The free list keeps a second head, `committed_head`, that moves with every committing instruction that has a
destination register. On `rob_global_flush` the head is set to it: the registers of the dropped instructions are
still in the list, in order, between the two heads.

## Why
No rebuild loop and no AMT input; recovery is one register copy.

## Consequences
The free list now relies on registers being taken in program order; `tb_rename` checks recovery after flushes.
