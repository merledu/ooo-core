# Design decisions

One short file per architecture decision (an "ADR"): what was decided, why, and what it costs.
A decision is never edited away; if it changes, add a new file that **supersedes** the old one
and set the old one's status to `superseded by NNNN`.

New decision: copy [`0000-template.md`](0000-template.md) to the next number.

| # | Decision | Status |
|---|---|---|
| [0001](0001-pht-trained-at-commit.md) | Train the PHT when a branch commits | accepted |
| [0002](0002-two-way-btb.md) | 2-way set associative BTB | accepted |
| [0003](0003-dsp-multiplier.md) | Pipelined DSP multiplier on the FPGA, Booth multiplier kept for ASIC | accepted |
| [0004](0004-single-port-data-memory.md) | One data memory port by default | accepted |
| [0005](0005-free-list-committed-head.md) | Free list recovery by following the committed head | accepted |
| [0006](0006-verify-against-spike.md) | Verify the whole core against Spike, instruction by instruction | accepted |
