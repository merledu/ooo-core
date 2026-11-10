# Git workflow

How the team works on this repo. Short version: **issue → branch → PR → review → merge**.

```
main                     protected: nobody pushes to it directly
├── perf/registered-flush    one branch per issue
├── feat/csr-traps
└── fix/lsq-forward-size
```

## One-time setup

```bash
git clone https://github.com/merledu/ooo-core.git
cd ooo-core
git config user.name  "Your Name"
git config user.email "you@example.com"
pip install pre-commit && pre-commit install
```

## For every task

### 1. Pick an issue

Every piece of work has an issue (template: *Task*). It says the goal, the files, the
interface, and how we know it is done (Acceptance). Assign yourself before starting.

### 2. Make a branch from the latest main

```bash
git checkout main
git pull
git checkout -b perf/registered-flush        # type/short-name
```

Branch types: `feat/` new hardware or script, `fix/` bug, `perf/` IPC or frequency, `test/` testbench only,
`docs/`, `chore/` repo housekeeping, `synth/` Vivado / timing scripts.

### 3. Work and commit

Small commits, each with a clear message:

```
perf(execute): register the branch flush before it fans out
fix(lsq): forward a halfword store to a byte load at offset 1
test(rename): free list after a memory order flush
```

Format: `type(scope): what it does`. Scope = the `rtl/` folder, module or `sim/` folder.

Before committing, check that only source files are staged:

```bash
git status            # nothing from sim/build/, fpga/build/, no *.vcd, *.dcp, *.log
git add rtl/execute/EX_Stage.sv
git commit -m "perf(execute): register the branch flush before it fans out"
```

### 4. Stay up to date with main

```bash
git fetch origin
git rebase origin/main
# conflict? fix the file, then: git add <file> && git rebase --continue
```

### 5. Push and open a pull request

```bash
git push -u origin perf/registered-flush     # later pushes after a rebase: git push --force-with-lease
```

On GitHub open a PR into `main`. Fill in the template: `Closes #<issue>`, the commands to
reproduce, and the **real transcript** of `sim/scripts/run_all.sh`. For performance or timing work add the
before / after numbers. CODEOWNERS asks for a review automatically.

### 6. Review and merge

- The author never approves their own PR.
- The reviewer reruns the regression if anything is unclear and comments on the PR.
- When approved and CI is green: **Squash and merge**, then delete the branch.

## Labels, epics and milestones

- Every issue has two labels: the kind of work (`feature`, `fix`, `perf`, `test`, `docs`, `cleanup`) and the
  part of the core (`frontend`, `rename`, `issue`, `execute`, `memory`, `commit`, `fpga`, `verification`, `repo`).
- An **epic** (label `epic`) is a big goal; it lists its issues as a checklist (`- [ ] #30`) and every
  issue under it says `Tracking: #<epic>` in its Goal.
- A **milestone** is a version from the table below; every open issue belongs to one.

## Versions, tags and releases

Versions follow [Semantic Versioning](https://semver.org/); every version is listed in `CHANGELOG.md`.

| Version | When | Release |
|---|---|---|
| `v0.1.0` | all 12 pipeline stages in RTL (PR #6, 2026-07-31) | GitHub release |
| `v0.2.0` | the core matches Spike on every test (co-simulation in all configurations, RISCOF RV32IM, CoreMark, Dhrystone); repository restructured | GitHub release |
| `v0.3.0` | frequency and area: 150 MHz after place and route on the xc7a100t-1, at most about 60 % of the LUTs | tag only |
| `v0.4.0` | IPC: more than 5 CoreMark/MHz, still 150 MHz | tag only |
| `v0.5.0` | CSRs and machine-mode traps (Zicsr, `ecall`, `ebreak`, `mret`, interrupts, misaligned access) | tag only |
| `v0.6.0` | instruction and data caches with an AXI4 bus to external memory instead of ideal RAMs | tag only |
| `v0.7.0` | runs on the board: the core with DDR and UART on the FPGA, CoreMark printed from hardware | GitHub release |
| `v0.8.0` | Linux ISA: A extension, S/U modes, Sv32 MMU | tag only |
| `v0.9.0` | platform: CLINT, PLIC, 16550 UART, OpenSBI boots on the board | GitHub release |
| `v1.0.0` | boots Linux on the board | GitHub release |

What each version contains, item by item: [`roadmap.md`](roadmap.md). Targets: [decision 0007](decisions/0007-performance-targets.md).

To make a version (only a maintainer, only from `main` with CI green):

```bash
# 1. CHANGELOG.md: move the [Unreleased] items under a new heading, e.g. ## [0.3.0] - <date>
git commit -am "docs: changelog 0.3.0"          # through a PR like any other change
# 2. after that PR is merged:
git checkout main && git pull
git tag -a v0.3.0 -m "v0.3.0: 150 MHz on xc7a100t-1"
git push origin v0.3.0
```

A **release** (`v0.7.0`, `v0.9.0`, `v1.0.0`) is made on GitHub from the tag (Releases → Draft a new release) and
carries the files that are never in git: the bitstream, the Vivado reports and the benchmark logs.

## Rules that save time

- Never commit generated files; rebuild them (see `STRUCTURE.md`).
- Never rewrite `main`'s history. On your own branch, `--force-with-lease` after a rebase is fine.
- A change to a structure size or a default parameter goes in `docs/scorecard.md` with the benchmark numbers
  before and after.
- If something does not match the issue (a width, a handshake, a latency), write it in the issue and ask; don't
  silently redesign.
