# Changelog

All notable changes. Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/);
versions follow [Semantic Versioning](https://semver.org/) (`v0.x` until the core boots Linux on the board).
The plan for the next versions is in [`docs/git-workflow.md`](docs/git-workflow.md#versions-tags-and-releases).

## [Unreleased]

Becomes `v0.2.0` once the reset-write fix below is merged and `sim/scripts/run_all.sh --full` passes.

### Known issue (to fix before v0.2.0)
- LSQ writes the data memory once while `reset` is high: before the first clock edge `sq_head` / `sq_commit` hold
  random values, `lsq_mem_write = (sq_head != sq_commit)` is not gated by `reset`, so a random SQ entry is written to a
  random word. With random initial values (`+verilator+rand+reset+2`) `rand_mix_36 --config booth` loads the corrupted
  byte (core `a0967eb4`, Spike `a0967e04`). Not visible on the FPGA, where flip-flops start at 0.

### Changed
- Repository restructured: `rtl/<section>/`, `sim/`, `fpga/`, `docs/` (see `STRUCTURE.md` for old → new paths).
- One file list (`rtl/rtl.f`) now feeds the simulations, the CI lint and Vivado.
- PHT trained by the BIQ when a branch commits (wrong-path branches no longer train it).
- BTB is 2-way set associative (`BTB_WAYS`), 256 entries; gshare 12-bit history; 8 branch tags;
  IQ 32, LQ 16, SQ 32 entries.
- Free list recovers from a memory order flush by following the committed head instead of rebuilding from the AMT.
- CDB arbiter stalls issue only after a LSQ / MUL / DIV result has waited one cycle (`STALL_DELAY`).

### Added
- `MUL_DSP`: 3-stage pipelined multiplier for FPGA DSPs (`USE_DSP_MUL = 1`, default); the Booth `MUL_Unit` stays for ASIC.
- `DMEM_DUAL_PORT` option: separate store and load ports on the data memory (default off).
- Observation ports on `main_datapath` (commits, memory writes).
- Verification: module testbenches, co-simulation of the whole core against Spike (directed and random programs,
  three configurations), RISCOF RV32I / RV32M, CoreMark and Dhrystone ports checked against Spike.
- Vivado scripts for the Artix-7 xc7a100tcsg324-1: synthesis, place and route, timing maps.
- `sim/scripts/run_all.sh`: the whole regression, exit code 1 on failure.
- README, STRUCTURE, CONTRIBUTING, git workflow and versions, issue / PR templates, CODEOWNERS, CI,
  pre-commit checks, specification, design decisions, scorecard.

### Fixed
- MUL / DIV units: iteration count and high word; results held until the CDB takes them; waiting results flushed
  on a misprediction.
- EX stage: `jalr` target and not-taken redirect; branches and stores report completion.

### Removed from git (kept locally)
- `Design/waveform.vcd`, simulation build output, `RAT_TestBench.sv` (its module no longer exists).
- The presentation (`.pptx`, 1.3 MB): shared outside git.

## [0.1.0] - 2026-07-31

All 12 pipeline stages in RTL, merged stage by stage (PRs #1 to #6): prediction, fetch, decode, rename,
dispatch, issue, register read, execute, LSQ, memory, writeback, commit.

[Unreleased]: https://github.com/merledu/ooo-core/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/merledu/ooo-core/releases/tag/v0.1.0
