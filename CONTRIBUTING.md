# Contributing

1. Read [`docs/git-workflow.md`](docs/git-workflow.md): issue → branch → PR → review → merge.
2. Read [`STRUCTURE.md`](STRUCTURE.md): where each kind of file goes.
3. Install the tools: Verilator 5, `riscv32-unknown-elf-gcc` with rv32im, Spike, Python 3 (and RISCOF for the
   architectural tests, Vivado for synthesis).
4. Install the pre-commit checks once:
   ```bash
   pip install pre-commit
   pre-commit install
   ```
   They block files over 1 MB and fix line endings and trailing spaces before every commit.

## RTL conventions

- SystemVerilog, one module per file, file name = module name.
- Clock `CLK`, synchronous active-high `reset` (the names used across the core).
- Every module parameter that sizes a structure comes from `main_datapath`; don't hard-code a size inside a module.
- Comment every port with what it means and whether it is a one-cycle **pulse** or a **level**.
- A new file goes into `rtl/rtl.f` in the same PR.
- Code under `` `ifdef SYNTHESIS `` must behave the same as the simulation path (only file loading may differ).

## Testbench conventions

- Module tests: `sim/unit/tb_<module>.sv`, top module `tb_<module>`, self-checking, ending with one
  `PASS tb_<module> (...)` or `FAIL ...` line; `run_unit.sh` counts them.
- Test edge values and stalls / flushes, not only random data.
- A change to the core is checked against Spike: `sim/scripts/run_all.sh` must pass, and `--full` for any change to
  the LSQ, the multiplier or a structure size.

## Definition of done

A task is done when its issue's acceptance list is ticked, `sim/scripts/run_all.sh` passes,
the PR shows the transcript, benchmark or timing changes are in `docs/scorecard.md`, and a teammate approved it.
