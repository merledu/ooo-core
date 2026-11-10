# Roadmap

From the verified core (`v0.2.0`) to Linux on the board (`v1.0.0`). Targets and their reasons:
[decision 0007](decisions/0007-performance-targets.md). Each version is a GitHub milestone; each item below
becomes one or more issues (see [`git-workflow.md`](git-workflow.md)).

**Every version from `v0.4.0` on keeps both targets: 150 MHz after place and route on the xc7a100tcsg324-1
and more than 5 CoreMark/MHz.** A change that breaks one of them needs a decision.

| Version | Goal | Done when |
|---|---|---|
| `v0.1.0` ✓ | all 12 pipeline stages in RTL | merged (2026-07-31) |
| `v0.2.0` ✓ | the core matches Spike on every test | co-simulation, RISCOF 47/47, CoreMark, Dhrystone (2026-11-10) |
| `v0.3.0` | frequency and area | **150 MHz** post-route, at most about 60 % LUTs, CoreMark/MHz at least about 3.2 |
| `v0.4.0` | IPC | **more than 5 CoreMark/MHz**, more than 2.5 DMIPS/MHz, still 150 MHz |
| `v0.5.0` | CSRs and machine-mode traps | RISCOF privileged (M-mode) tests pass, Spike match with traps and interrupts |
| `v0.6.0` | caches and a memory bus | CoreMark against Spike with caches and a slow external memory model |
| `v0.7.0` | runs on the board | CoreMark printed over UART from the FPGA at 150 MHz |
| `v0.8.0` | Linux ISA: A extension, S/U modes, Sv32 MMU | riscv-tests (`rv32si`, `rv32ui-v`), RISCOF privileged + A, Spike match with paging |
| `v0.9.0` | platform: CLINT, PLIC, OpenSBI | OpenSBI boots and prints its banner on the board |
| `v1.0.0` | Linux | Linux boots to a shell on the board |

## v0.3.0: frequency and area

Goal: 150 MHz after place and route on the xc7a100tcsg324-1 (today 31.8 MHz after synthesis, 99.4 % of the LUTs).

1. **Area**: physical register file, ROB payload, branch snapshots and store queue data in LUT-RAM instead of
   flip-flops and multiplexers.
2. **Registered flush**: register the misprediction / memory order flush and give each section its own copy
   (no single net reaches every module in one cycle).
3. **Reset cleanup**: reset only the control state (valid bits, pointers), not the data arrays.
4. **Front end**: registered redirect PC; a small fetch queue between prediction and fetch; almost-full stall
   signals instead of full, so a stall does not travel back through the whole front end in one cycle.
5. **Back end**:
   - branch resolution in its own stage after the ALU;
   - LSQ search and store-to-load forwarding over two cycles;
   - split issue queues (ALU / memory / mul-div) with smaller selects;
   - smaller forwarding network if needed.
6. **Vivado**: retiming, `max_fanout` on the big nets, `phys_opt_design`, several implementation strategies.

Each change: full regression, CoreMark/MHz and timing before merging (decision 0007).

## v0.4.0: IPC

Goal: more than 5 CoreMark/MHz (IPC about 1.45 on CoreMark, today 1.015), keeping 150 MHz.

1. **Memory dependence predictor** (load-wait table or store sets): a load that caused a memory order flush
   waits for older stores the next time. Removes most of the 269 flushes in CoreMark and 2 per iteration in
   Dhrystone; then revisit `DMEM_DUAL_PORT` ([decision 0004](decisions/0004-single-port-data-memory.md)).
2. **Oldest-first issue select** (today the lowest free slot wins and old instructions can wait about 35 cycles).
3. **Fetch**: two instructions per cycle after a taken branch to an address that is not 8-byte aligned.
4. **Branch prediction**: a stronger predictor (for example a small TAGE), and win back the cycles the
   registered redirect costs in the misprediction penalty.
5. If still short: a third result bus lane, shorter load latency (3 cycles after the address today).

## v0.5.0: CSRs and machine-mode traps

1. Zicsr: `csrrw/s/c` and the immediate forms, executed at commit (serializing).
2. M-mode CSRs: `mstatus`, `misa`, `mtvec`, `mepc`, `mcause`, `mtval`, `mie`, `mip`, `mscratch`, `mhartid`;
   counters `mcycle`, `minstret` (CoreMark timing on the board) and `cycle` / `instret`.
3. Precise exceptions at commit: illegal instruction, `ecall`, `ebreak`, misaligned load / store / fetch;
   `mret`; trap entry flushes the pipeline and fetches from `mtvec`.
4. Interrupts: timer, software and external inputs, taken at commit.
5. `fence` and `fence.i` (needed before instruction caches).
6. Verification: Spike co-simulation with traps; RISCOF privileged tests (M-mode).

## v0.6.0: caches and a memory bus

1. Instruction cache and data cache (start 8-16 KB each, set associative), with the ideal memories removed.
2. Non-blocking data cache (at least hit under miss) so the out-of-order core keeps working during a miss.
3. A standard bus to external memory (AXI4), so the Xilinx memory controller and peripherals connect directly.
4. `fence.i` clears or synchronizes the instruction cache.
5. Verification: Spike co-simulation with a slow memory model (tens of cycles of latency); CoreMark/MHz
   with caches goes in the scorecard.

## v0.7.0: runs on the board

1. SoC top: core, caches, Xilinx DDR memory controller (MIG), UART, boot ROM, clocking at 150 MHz.
2. Program loader over UART (or a boot ROM that loads from UART).
3. CoreMark and Dhrystone run on the board and print their scores; the bitstream, the Vivado reports and the
   logs go in the GitHub release.

## v0.8.0: Linux ISA

1. **A extension**: `lr.w` / `sc.w` and the AMOs, executed in order at the head of the ROB.
2. **Privilege modes**: S and U modes; `medeleg` / `mideleg`, the S-mode CSRs (`sstatus`, `stvec`, `sepc`,
   `scause`, `stval`, `satp`, `sie`, `sip`), `sret`, `wfi`.
3. **Sv32 MMU**: instruction and data TLBs, hardware page table walker, `sfence.vma`, page faults, the
   A/D bits.
4. Verification: riscv-tests (`rv32si`, `rv32ui-v` / `rv32um-v` with virtual memory), RISCOF privileged and A,
   Spike co-simulation with paging.

## v0.9.0: platform

1. CLINT (`mtime`, `mtimecmp`, software interrupts) and PLIC.
2. 16550-compatible UART, so the standard OpenSBI and Linux drivers work.
3. Device tree for the SoC.
4. OpenSBI ported to the platform; boots on the board and prints its banner.
5. Linux started in simulation (Verilator) to the first kernel messages, to debug before the board.

## v1.0.0: Linux

1. Linux kernel and a small root file system (Buildroot, `rv32ima`) loaded into DDR.
2. Boots to a shell over UART on the board, at 150 MHz.
3. GitHub release with the bitstream, the boot images and the boot log.
