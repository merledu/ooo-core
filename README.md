# RV32IM Dual-Issue Out-of-Order Processor

## Overview

This project implements a **dual-issue out-of-order RV32IM processor** in **SystemVerilog**. The processor exploits instruction-level parallelism through dynamic scheduling, register renaming, speculative execution, and in-order retirement.

The microarchitecture is organized as a **12-stage pipeline**:

1. Prediction
2. Fetch
3. Decode
4. Rename
5. Dispatch
6. Issue
7. Register Read
8. Execute
9. LSQ
10. Memory
11. Writeback
12. Commit

---
## Architecture Diagram

![Processor Architecture](Documentation/processor_architecture.png)
---

## Key Features

- RV32IM ISA support
- Dual-issue superscalar front-end
- Out-of-order execution
- Register renaming
- Dynamic instruction scheduling
- Branch prediction
- Load Store Queue (LSQ)
- Reorder Buffer (ROB)
- Speculative execution
- In-order commit
- Modular SystemVerilog implementation

---

## Pipeline Stages

### 1. Prediction
Generates the next program counter using branch prediction structures and speculative control-flow information.

### 2. Fetch
Fetches up to two instructions per cycle from instruction memory.

### 3. Decode
Decodes fetched instructions and extracts source/destination operands and control information.

### 4. Rename
Maps architectural registers to physical registers, eliminating WAR and WAW hazards.

### 5. Dispatch
Allocates resources such as ROB entries, issue queue entries, and LSQ entries.

### 6. Issue
Selects ready instructions for execution based on operand availability and functional unit readiness.

### 7. Register Read
Reads source operands from the physical register file or receives forwarded values.

### 8. Execute
Performs ALU operations, branch evaluation, multiplication/division, and address generation.

### 9. LSQ
Handles memory dependency tracking and load/store ordering.

### 10. Memory
Accesses data memory for load and store operations.

### 11. Writeback
Broadcasts execution results and updates destination physical registers.

### 12. Commit
Retires instructions in program order and updates architectural state.

---

## Out-of-Order Execution

The processor supports out-of-order execution using:

- Register Alias Table (RAT)
- Physical Register File (PRF)
- Reorder Buffer (ROB)
- Issue Queue / Reservation Stations
- Load Store Queue (LSQ)

Instructions may execute as soon as their operands become available, regardless of original program order. Correct architectural state is preserved through in-order commit.

---

## Branch Prediction

The prediction stage supports speculative execution to reduce branch penalties.

Possible components include:

- Branch Target Buffer (BTB)
- Pattern History Table (PHT)
- Return Address Stack (RAS)


---

## Running a program

`Design/tb_main_datapath.sv` runs the program in `Design/instructions.hex` (one 32-bit instruction per line,
first instruction at address 0). Another file can be chosen with `+HEX=<file>`.

Parameters of `main_datapath`: `RESET_PC` (address of the first instruction), `IM_ROWS` and `RAM_DEPTH`
(memory sizes in words, powers of 2), `ROB_SIZE`, `IQ_ROWS`, `LQ_ENTRIES`, `SQ_ENTRIES`, `MAX_BRANCHES`,
`PHT_ADDRESS`/`GHR_SIZE` (gshare), `BTB_ROWS`, ...

* `USE_DSP_MUL`: 1 (default, FPGA) pipelined multiplier `MUL_DSP` mapped to DSP blocks, result 3 cycles after
  execute; 0 (ASIC) radix-4 Booth multiplier `MUL_Unit`, ~18 cycles.
* `DMEM_DUAL_PORT`: 1 gives the data memory a store write port and a load read port (loads are not blocked by
  committed stores). Default 0: with the extra port loads run ahead of older stores more often and, without a
  memory dependence predictor, the extra memory order flushes cost more than the port gains.
* `NUM_PHY_REG` can be set below `1 << PRF_ADDRESS`; `NUM_PHY_REG - 32` (free list size) must be a power of 2.

Limits: instruction and data memory are separate, `ecall`/`ebreak`/CSR/`fence` instructions are ignored
and memory accesses must be aligned.

## Verification

The core is compared instruction by instruction with the Spike ISA simulator (random programs and
compiled C programs) and the main modules have their own testbenches. See [TestBenches/README.md](TestBenches/README.md).

---

## Author

Mutahir Ahmed Siddiqui

---
