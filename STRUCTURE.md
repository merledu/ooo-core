# Repository structure

Where everything lives, and where new work goes. Folders under `rtl/` follow the sections of the pipeline
(`docs/images/processor_architecture.png`). A module lives in the folder of the stage that instantiates it,
except the ROB (`commit/`) and the LSQ (`memory/`), which are instantiated by the dispatch stage.

```text
.
├── README.md                 project overview, results, status, quick start
├── STRUCTURE.md              this file
├── CONTRIBUTING.md           setup, RTL and testbench conventions, definition of done
├── CHANGELOG.md              what changed in each version
├── .pre-commit-config.yaml   checks run on every commit (large files, line endings)
├── .github/
│   ├── CODEOWNERS            who is asked to review every PR
│   ├── workflows/ci.yml      on every PR: Verilator lint of rtl/rtl.f, unit tests, no generated / large files
│   ├── ISSUE_TEMPLATE/
│   │   ├── task.md           one module / one deliverable per issue
│   │   └── epic.md           a version made of several tasks
│   └── pull_request_template.md
├── rtl/                      synthesizable SystemVerilog only (no testbenches)
│   ├── rtl.f                 THE file list: every RTL file (simulation, lint and Vivado read it)
│   ├── frontend/             1 prediction, 2 fetch
│   │   ├── PD_Stage.sv       next PC: gshare (GHR + PHT), BTB, RAS, redirects
│   │   ├── PC.sv  GHR.sv  PHT.sv  BTB.sv  RAS.sv
│   │   ├── IF_Stage.sv       fetches a bundle of two instructions
│   │   ├── IM.sv             instruction memory (block RAM, $readmemh)
│   │   └── PreDecode.sv      finds jal, calls and returns in the fetched bundle
│   ├── decode/               3 decode
│   │   ├── ID_Stage.sv
│   │   ├── CU.sv  ALUCU.sv   control unit, ALU operation
│   │   ├── IG21.sv           extracts the 21-bit immediate
│   │   └── BIQ.sv            branch information queue: prediction state of every branch, trains the PHT at commit
│   ├── rename/               4 rename
│   │   ├── RN_Stage.sv
│   │   ├── RMT.sv            register map table
│   │   ├── FL.sv             free list of physical registers
│   │   └── BS.sv             branch snapshots (map table, free list head, branch mask)
│   ├── issue/                5 dispatch, 6 issue, 7 register read
│   │   ├── DIS_Stage.sv      writes ROB, issue queue and LSQ
│   │   ├── IQ.sv             issue queue, wake-up and select
│   │   ├── RR_Stage.sv  PRF.sv  IG.sv   register read, physical register file, immediate to 32 bits
│   ├── execute/              8 execute, 11 writeback
│   │   ├── EX_Stage.sv
│   │   ├── ALU.sv  ForwardingUnit.sv
│   │   ├── MUL_DSP.sv        3-stage pipelined multiplier for FPGA DSPs (USE_DSP_MUL = 1)
│   │   ├── MUL_Unit.sv       radix-4 Booth multiplier for ASIC (USE_DSP_MUL = 0)
│   │   ├── DIV_Unit.sv
│   │   └── CDB_Arbiter.sv    two common data bus lanes
│   ├── memory/               9 LSQ, 10 memory
│   │   ├── LSQ.sv            load / store queues, forwarding, memory order violations
│   │   ├── MEM_Stage.sv  DataMemoryWrapper.sv  DataMemory.sv
│   ├── commit/               12 commit
│   │   ├── ROB.sv
│   │   └── CM_Stage.sv
│   └── top/
│       └── main_datapath.sv  the whole core, all parameters
├── sim/
│   ├── README.md             every verification command
│   ├── scripts/run_all.sh    unit tests + core against Spike (--full: more configurations, benchmarks)
│   ├── unit/                 tb_<module>.sv and run_unit.sh
│   ├── core/                 tb_core.sv, run.py (core against Spike), gen_random.py, asm/, c/, crt0.S, link.ld
│   ├── riscof/               config.ini, ooo_core/ and spike_ref/ plugins
│   ├── bench/                run_bench.py, coremark_port/, dhrystone_port/
│   ├── smoke/                tb_main_datapath.sv + instructions.hex
│   └── build/                all simulation output (ignored)
├── fpga/
│   ├── synth.tcl             synthesis + place and route of the core (out of context, xc7a100tcsg324-1)
│   ├── impl.tcl              place and route from the synthesis checkpoint
│   ├── synth_module.tcl      one module on its own
│   ├── timing_map.tcl        which modules fail a clock period
│   ├── timing_modules.tcl    worst path into every module
│   └── build/                checkpoints and reports (ignored)
└── docs/
    ├── spec/architecture.md  pipeline, parameters, limits
    ├── decisions/            one file per design decision (ADR)
    ├── scorecard.md          measured results
    ├── git-workflow.md       issue → branch → PR → review → merge, versions and tags
    ├── images/               diagrams used by the docs (ooo_core_datapath.png: current datapath)
    ├── diagrams/             editable sources (draw.io): ooo_core_datapath.drawio
    └── slides/               presentations (ignored: shared outside git)
```

## Where new work goes

| New thing | Goes in | Also update |
|---|---|---|
| RTL module | the `rtl/<section>/` of the stage that uses it | `rtl/rtl.f` |
| Module testbench | `sim/unit/tb_<module>.sv` | table in `sim/README.md` |
| Directed test program | `sim/core/asm/*.S` or `sim/core/c/*.c` | — (`run.py all` picks it up) |
| Synthesis / timing script | `fpga/` | `fpga/README.md` |
| Design decision | `docs/decisions/NNNN-title.md` | table in `docs/decisions/README.md` |
| Measured number | `docs/scorecard.md` | — |

## Old → new paths

| Before | Now |
|---|---|
| `Design/*.sv` | `rtl/<section>/*.sv` |
| `Design/tb_main_datapath.sv`, `Design/instructions.hex` | `sim/smoke/` |
| `TestBenches/{unit,core,bench,riscof}/` | `sim/{unit,core,bench,riscof}/` |
| `TestBenches/README.md` | `sim/README.md` |
| `TestBenches/build/` | `sim/build/` |
| `Synthesis/*.tcl`, `Synthesis/build/` | `fpga/`, `fpga/build/` |
| `Documentation/*.png` | `docs/images/` |
| `Documentation/*.drawio`, `*.html` | `docs/diagrams/` |
| `Documentation/*.pptx` | `docs/slides/` (not in git) |
