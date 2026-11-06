# 0003: Pipelined DSP multiplier on the FPGA, Booth multiplier kept for ASIC

- Status: accepted
- Date: 2026-10
- Issue: —

## Context
The radix-4 Booth `MUL_Unit` takes about 18 cycles per multiplication and is built from LUTs.

## Decision
`MUL_DSP`: operand registers → product register → output register, mapped to DSP48 blocks, result 3 cycles after
execute, same ports and CDB protocol as `MUL_Unit`. `USE_DSP_MUL` selects it (1, default) or `MUL_Unit` (0).

## Why
The FPGA has 240 DSPs and the core uses 4; LUTs are the scarce resource (99 % used after synthesis).

## Consequences
Both multipliers must stay correct: `sim/unit/tb_muldiv.sv` tests both, and `run.py all --config booth` runs the
whole core with the Booth multiplier.
