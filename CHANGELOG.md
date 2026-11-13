# Changelog

All notable changes. Format: [Keep a Changelog](https://keepachangelog.com/en/1.1.0/);
versions follow [Semantic Versioning](https://semver.org/) (`v0.x` until the core boots Linux on the board).
The plan for the next versions is in [`docs/roadmap.md`](docs/roadmap.md).

## [Unreleased]

### Added
- Roadmap from `v0.3.0` to Linux (`docs/roadmap.md`) and decision 0007: 150 MHz on the xc7a100t-1 and more
  than 5 CoreMark/MHz, frequency and area first, then IPC. An IPC version (`v0.4.0`) is added, so CSRs, caches
  and the board move to `v0.5.0`-`v0.7.0`, with `v0.8.0` (Linux ISA) and `v0.9.0` (platform) before `v1.0.0`.

### Changed
- Dhrystone is built with GCC builtins on, as in riscv-tests (was `-ffreestanding -fno-builtin`, which sent every
  `strcpy` to a byte loop: 52 % of the timed instructions). 1.30 → 1.70 DMIPS/MHz, core unchanged.

## [0.2.0] - 2026-11-07

The core matches Spike on every test, and the repository is set up for the team.

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
- New datapath diagram matching the current RTL: `docs/diagrams/ooo_core_datapath.drawio` (editable) and `docs/images/ooo_core_datapath.png`.
- Verification: module testbenches, co-simulation of the whole core against Spike (directed and random programs,
  three configurations), RISCOF RV32I / RV32M, CoreMark and Dhrystone ports checked against Spike.
- Vivado scripts for the Artix-7 xc7a100tcsg324-1: synthesis, place and route, timing maps.
- `sim/scripts/run_all.sh`: the whole regression, exit code 1 on failure.
- README, STRUCTURE, CONTRIBUTING, git workflow and versions, issue / PR templates, CODEOWNERS, CI,
  pre-commit checks, specification, design decisions, scorecard.

### Fixed
- LSQ no longer writes the data memory while `reset` is high. Before the first clock edge `sq_head` / `sq_commit`
  could hold any value, so a random SQ entry was written to a random word (seen with random initial values as
  `rand_mix_36 --config booth` loading a corrupted byte). Not visible on the FPGA, where flip-flops start at 0.
- MUL / DIV units: iteration count and high word; results held until the CDB takes them; waiting results flushed
  on a misprediction.
- EX stage: `jalr` target and not-taken redirect; branches and stores report completion.

### Removed from git (kept locally)
- `Design/waveform.vcd`, simulation build output, `RAT_TestBench.sv` (its module no longer exists).
- The presentation (`.pptx`, 1.3 MB): shared outside git.

## [0.1.0] - 2026-07-31

All 12 pipeline stages in RTL, merged stage by stage (PRs #1 to #6): prediction, fetch, decode, rename,
dispatch, issue, register read, execute, LSQ, memory, writeback, commit.

[Unreleased]: https://github.com/merledu/FissionRV/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/merledu/FissionRV/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/merledu/FissionRV/releases/tag/v0.1.0
