// Every synthesizable file of the core, paths relative to the repository root.
// Used by the simulations (sim/), the lint in CI and Vivado (fpga/). A new RTL file is added here.
// frontend
rtl/frontend/BTB.sv
rtl/frontend/GHR.sv
rtl/frontend/IF_Stage.sv
rtl/frontend/IM.sv
rtl/frontend/PC.sv
rtl/frontend/PD_Stage.sv
rtl/frontend/PHT.sv
rtl/frontend/PreDecode.sv
rtl/frontend/RAS.sv
// decode
rtl/decode/ALUCU.sv
rtl/decode/BIQ.sv
rtl/decode/CU.sv
rtl/decode/ID_Stage.sv
rtl/decode/IG21.sv
// rename
rtl/rename/BS.sv
rtl/rename/FL.sv
rtl/rename/RMT.sv
rtl/rename/RN_Stage.sv
// issue
rtl/issue/DIS_Stage.sv
rtl/issue/IG.sv
rtl/issue/IQ.sv
rtl/issue/PRF.sv
rtl/issue/RR_Stage.sv
// execute
rtl/execute/ALU.sv
rtl/execute/CDB_Arbiter.sv
rtl/execute/DIV_Unit.sv
rtl/execute/EX_Stage.sv
rtl/execute/ForwardingUnit.sv
rtl/execute/MUL_DSP.sv
rtl/execute/MUL_Unit.sv
// memory
rtl/memory/DataMemory.sv
rtl/memory/DataMemoryWrapper.sv
rtl/memory/LSQ.sv
rtl/memory/MEM_Stage.sv
// commit
rtl/commit/CM_Stage.sv
rtl/commit/ROB.sv
// top
rtl/top/main_datapath.sv
