# 0004: One data memory port by default

- Status: accepted
- Date: 2026-10
- Issue: —

## Context
With one port, a load cannot read while a committed store is being written.

## Decision
`DMEM_DUAL_PORT` adds a store write port and a load read port; the default stays 0 (one port).

## Why
With the second port loads run ahead of older stores more often, and without a memory dependence predictor the
extra memory order flushes cost more than the port gains.

## Consequences
Revisit together with a load-wait table (Dhrystone has 2 memory order flushes per iteration from the same load).
