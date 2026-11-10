Closes #

## What changed

## How to reproduce
<!-- Exact commands from the repo root, e.g. sim/scripts/run_all.sh --full -->
```bash

```

## Regression transcript
<!-- Paste the real tail of sim/scripts/run_all.sh, including the PASS / FAILED lines. A summary is not evidence. -->
```text

```

## Performance / timing
<!-- Performance or synthesis PRs only: measured numbers, not estimates -->
| Metric | Before | After |
|---|---|---|
| CoreMark/MHz | | |
| DMIPS/MHz | | |
| Slice LUTs | | |
| Fmax (post-route) | | |

## Known limitations / deferred

## Checklist
- [ ] `sim/scripts/run_all.sh` passes (`--full` for LSQ, multiplier or structure size changes)
- [ ] New RTL files added to `rtl/rtl.f`
- [ ] No generated files staged (sim/build/, fpga/build/, *.vcd, *.dcp, *.log); `git status` clean after a run
- [ ] Widths and handshakes checked against the RTL, not guessed from names
- [ ] Title is `type(scope): short description`
- [ ] Rebased on `origin/main`
