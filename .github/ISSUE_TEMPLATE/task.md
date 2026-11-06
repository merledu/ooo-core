---
name: Task
about: One module or one deliverable per issue
title: "type(scope): "
labels: ''
assignees: ''
---
## Goal
<!-- One or two sentences: what this delivers and why. Link the epic: Tracking: #N -->

## Scope (files)
<!-- Every file this issue creates or changes, e.g. rtl/execute/EX_Stage.sv, sim/unit/tb_ex.sv -->
-

## Interface / contract
<!-- Ports, widths, pulse vs level, latency, parameters. Check them against the RTL, don't guess from names. -->

## Acceptance
- [ ] `sim/scripts/run_all.sh` passes (transcript in the PR)
- [ ] Edge cases tested (stalls, flushes, full queues), not only random programs
- [ ] Benchmark / timing numbers before and after in `docs/scorecard.md` (performance or frequency work)
- [ ]

## Depends on
<!-- #issue numbers that must be merged first -->

## Out of scope
