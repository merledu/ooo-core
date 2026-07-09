module DIS_Stage #(
    parameter XLEN = 32,
    parameter PRF_ADDRESS = 6,
    parameter BIQ_ADDRESS = 5,
    parameter ROB_SIZE = 64,
    parameter INIT_IMMEDIATE_SIZE = 21,
    parameter ROB_PTR_SIZE = $clog2(ROB_SIZE),
    parameter MAX_BRANCHES = 4,
    parameter BTAG_SIZE = $clog2(MAX_BRANCHES)
) (
    input logic CLK, reset, flush, branch_mispredicted, stall_frontend,
    input logic cdb_done1, cdb_done2,cdb_wakeup1, cdb_wakeup2, cdb_branch_resolved, cdb_branch_correct,
    input logic [PRF_ADDRESS-1:0] cdb_waked_reg1, cdb_waked_reg2,
    input logic [BTAG_SIZE-1:0] cdb_branch_tag,
    input logic [ROB_PTR_SIZE-1:0] cdb_rob_index1, cdb_rob_index2,
    input logic [PRF_ADDRESS-1:0] rn_prd1, rn_prs1_1, rn_prs2_1, rn_old_prd1, 
    input logic [PRF_ADDRESS-1:0] rn_prd2, rn_prs1_2, rn_prs2_2, rn_old_prd2,             
    input logic rn_prs1_busy1, rn_prs2_busy1, rn_prs1_busy2, rn_prs2_busy2,
    input logic [BTAG_SIZE-1:0] rn_branch_tag,
    input logic [MAX_BRANCHES-1:0] rn_branch_mask,
    input logic [BIQ_ADDRESS-1:0] rn_biq_address,
    input logic [XLEN-3:0] rn_pc,
    input logic [4:0] rn_rd_1, rn_rd_2,
    input logic [INIT_IMMEDIATE_SIZE-1:0] rn_immout1, rn_immout2,
    input logic rn_is_m_extension1, rn_is_m_extension2,
    input logic [4:0] rn_alu_operation1, rn_alu_operation2,
    input logic rn_valid1, rn_jump_reg1, rn_jump1, rn_branch1, 
    input logic rn_regsrc1_1, rn_regsrc2_1, rn_immtype1, rn_isimm1, rn_retaddr1,
    input logic rn_upperimm1, rn_regwrite1, rn_memwrite1, rn_memtoreg1, 
    input logic rn_valid2, rn_jump_reg2, rn_jump2, rn_branch2, 
    input logic rn_regsrc1_2, rn_regsrc2_2, rn_immtype2, rn_isimm2, rn_retaddr2,
    input logic rn_upperimm2, rn_regwrite2, rn_memwrite2, rn_memtoreg2,
     // input from cdb
    input logic [ROB_PTR_SIZE-1:0] cdb_branch_rob_index,
     // for frontend
    output logic dis_stall_frontend,
     // for commit 
    output logic commit_instr1, commit_instr2,
    output logic [PRF_ADDRESS-1:0] dis_free_old_prd1, dis_free_old_prd2,
    output logic [PRF_ADDRESS-1:0] comm_prd1, comm_prd2,
    output logic [4:0] comm_rd1, comm_rd2,
     // Issued Instruction 1
    output logic iss_valid1, iss_is_m_extension1, iss_jump_reg1, iss_jump1, iss_branch1, 
    output logic iss_instr1_regsrc1, iss_instr1_regsrc2, iss_immtype1, iss_isimm1, iss_retaddr1,
    output logic iss_upperimm1, iss_regwrite1, iss_memwrite1, iss_memtoreg1,
    output logic [XLEN-3:0] iss_pc1,
    output logic [PRF_ADDRESS-1:0] iss_prd1, iss_instr1_prs1, iss_instr1_prs2,
    output logic [INIT_IMMEDIATE_SIZE-1:0] iss_immediate1,
    output logic [4:0] iss_alu_operation1,
    output logic [BTAG_SIZE-1:0] iss_branch_tag1,
    output logic [MAX_BRANCHES-1:0] iss_branch_mask1,
    output logic [BIQ_ADDRESS-1:0] iss_biq_address1,
    output logic [ROB_PTR_SIZE-1:0] iss_rob_index1,

    // Issued Instruction 2
    output logic iss_valid2, iss_is_m_extension2, iss_jump_reg2, iss_jump2, iss_branch2, 
    output logic iss_instr2_regsrc1, iss_instr2_regsrc2, iss_immtype2, iss_isimm2, iss_retaddr2,
    output logic iss_upperimm2, iss_regwrite2, iss_memwrite2, iss_memtoreg2,
    output logic [XLEN-3:0] iss_pc2,
    output logic [PRF_ADDRESS-1:0] iss_prd2, iss_instr2_prs1, iss_instr2_prs2,
    output logic [INIT_IMMEDIATE_SIZE-1:0] iss_immediate2,
    output logic [4:0] iss_alu_operation2,
    output logic [BTAG_SIZE-1:0] iss_branch_tag2,
    output logic [MAX_BRANCHES-1:0] iss_branch_mask2,
    output logic [BIQ_ADDRESS-1:0] iss_biq_address2,
    output logic [ROB_PTR_SIZE-1:0] iss_rob_index2
);


    logic rob_full, iq_full;           
    logic [ROB_PTR_SIZE-1:0] current_rob_index;

    assign dis_stall_frontend = rob_full || iq_full;

    ROB rob_instantiation (
        // ------------------- Globals & Control -------------------
        .CLK                (CLK),
        .reset              (reset),
        .stall_frontend     (stall_frontend),
        .branch_mispredicted(flush),
        
        // ------------------- Dispatch/Rename Inputs -------------------
        .rn_valid1          (rn_valid1),
        .rn_valid2          (rn_valid2),
        .rn_rd1             (rn_rd_1),
        .rn_rd2             (rn_rd_2),
        .rn_prd1            (rn_prd1),
        .rn_prd2            (rn_prd2),
        .rn_old_prd1        (rn_old_prd1),
        .rn_old_prd2        (rn_old_prd2),

        // ------------------- Execution/CDB Inputs -------------------
        .cdb_done1          (cdb_done1),
        .cdb_done2          (cdb_done2),
        .cdb_rob_index1     (cdb_rob_index1),
        .cdb_rob_index2     (cdb_rob_index2),
        .cdb_branch_rob_index(cdb_branch_rob_index),

        // ------------------- Status Outputs -------------------
        .rob_full           (rob_full),
        .current_rob_index  (current_rob_index),

        // ------------------- Commit Outputs -------------------
        .commit_instr1      (commit_instr1),
        .commit_instr2      (commit_instr2),
        .comm_prd1          (comm_prd1),
        .comm_prd2          (comm_prd2),
        .comm_rd1           (comm_rd1),
        .comm_rd2           (comm_rd2),
        
        // ------------------- Free List Recovery Outputs -------------------
        .dis_free_old_prd1  (dis_free_old_prd1),
        .dis_free_old_prd2  (dis_free_old_prd2)
    );

    
    IQ iq_instantiation (
        // ------------------- Globals & Control -------------------
        .CLK                (CLK),
        .reset              (reset),
        .rob_full           (rob_full),
        .flush              (flush),
        
        // ------------------- CDB & Branch Wakeups -------------------
        .cdb_wakeup1        (cdb_wakeup1),
        .cdb_wakeup2        (cdb_wakeup2),
        .cdb_branch_resolved(cdb_branch_resolved),
        .cdb_branch_correct (cdb_branch_correct),
        .cdb_waked_reg1     (cdb_waked_reg1),
        .cdb_waked_reg2     (cdb_waked_reg2),
        .cdb_branch_tag     (cdb_branch_tag),

        // ------------------- Dispatch Input: Instruction 1 -------------------
        .rn_valid1          (rn_valid1),
        .rn_pc              (rn_pc),
        .rn_prd1            (rn_prd1),
        .rn_prs1_1          (rn_prs1_1),
        .rn_prs2_1          (rn_prs2_1),
        .rn_prs1_busy1      (rn_prs1_busy1),
        .rn_prs2_busy1      (rn_prs2_busy1),
        .rn_immout1         (rn_immout1),
        .rn_alu_operation1  (rn_alu_operation1),
        .rn_is_m_extension1 (rn_is_m_extension1),
        .rn_jump_reg1       (rn_jump_reg1),
        .rn_jump1           (rn_jump1),
        .rn_branch1         (rn_branch1),
        .rn_regsrc1_1       (rn_regsrc1_1),
        .rn_regsrc2_1       (rn_regsrc2_1),
        .rn_immtype1        (rn_immtype1),
        .rn_isimm1          (rn_isimm1),
        .rn_retaddr1        (rn_retaddr1),
        .rn_upperimm1       (rn_upperimm1),
        .rn_regwrite1       (rn_regwrite1),
        .rn_memwrite1       (rn_memwrite1),
        .rn_memtoreg1       (rn_memtoreg1),
        
        // ------------------- Dispatch Input: Shared Branch Info -------------------
        .rn_branch_tag      (rn_branch_tag),
        .rn_branch_mask     (rn_branch_mask),
        .rn_biq_address     (rn_biq_address),
        .current_rob_index  (current_rob_index),

        // ------------------- Dispatch Input: Instruction 2 -------------------
        .rn_valid2          (rn_valid2),
        .rn_prd2            (rn_prd2),
        .rn_prs1_2          (rn_prs1_2),
        .rn_prs2_2          (rn_prs2_2),
        .rn_prs1_busy2      (rn_prs1_busy2),
        .rn_prs2_busy2      (rn_prs2_busy2),
        .rn_immout2         (rn_immout2),
        .rn_alu_operation2  (rn_alu_operation2),
        .rn_is_m_extension2 (rn_is_m_extension2),
        .rn_jump_reg2       (rn_jump_reg2),
        .rn_jump2           (rn_jump2),
        .rn_branch2         (rn_branch2),
        .rn_regsrc1_2       (rn_regsrc1_2),
        .rn_regsrc2_2       (rn_regsrc2_2),
        .rn_immtype2        (rn_immtype2),
        .rn_isimm2          (rn_isimm2),
        .rn_retaddr2        (rn_retaddr2),
        .rn_upperimm2       (rn_upperimm2),
        .rn_regwrite2       (rn_regwrite2),
        .rn_memwrite2       (rn_memwrite2),
        .rn_memtoreg2       (rn_memtoreg2),
        

        // ------------------- Outputs: Status -------------------
        .iq_full            (iq_full),

        // ------------------- Issued Output: Instruction 1 -------------------
        .iss_valid1         (iss_valid1),
        .iss_is_m_extension1(iss_is_m_extension1),
        .iss_jump_reg1      (iss_jump_reg1),
        .iss_jump1          (iss_jump1),
        .iss_branch1        (iss_branch1),
        .iss_instr1_regsrc1 (iss_instr1_regsrc1),
        .iss_instr1_regsrc2 (iss_instr1_regsrc2),
        .iss_immtype1       (iss_immtype1),
        .iss_isimm1         (iss_isimm1),
        .iss_retaddr1       (iss_retaddr1),
        .iss_upperimm1      (iss_upperimm1),
        .iss_regwrite1      (iss_regwrite1),
        .iss_memwrite1      (iss_memwrite1),
        .iss_memtoreg1      (iss_memtoreg1),
        .iss_pc1            (iss_pc1),
        .iss_prd1           (iss_prd1),
        .iss_instr1_prs1    (iss_instr1_prs1),
        .iss_instr1_prs2    (iss_instr1_prs2),
        .iss_immediate1     (iss_immediate1),
        .iss_alu_operation1 (iss_alu_operation1),
        .iss_branch_tag1    (iss_branch_tag1),
        .iss_branch_mask1   (iss_branch_mask1),
        .iss_biq_address1   (iss_biq_address1),
        .iss_rob_index1     (iss_rob_index1),

        // ------------------- Issued Output: Instruction 2 -------------------
        .iss_valid2         (iss_valid2),
        .iss_is_m_extension2(iss_is_m_extension2),
        .iss_jump_reg2      (iss_jump_reg2),
        .iss_jump2          (iss_jump2),
        .iss_branch2        (iss_branch2),
        .iss_instr2_regsrc1 (iss_instr2_regsrc1),
        .iss_instr2_regsrc2 (iss_instr2_regsrc2),
        .iss_immtype2       (iss_immtype2),
        .iss_isimm2         (iss_isimm2),
        .iss_retaddr2       (iss_retaddr2),
        .iss_upperimm2      (iss_upperimm2),
        .iss_regwrite2      (iss_regwrite2),
        .iss_memwrite2      (iss_memwrite2),
        .iss_memtoreg2      (iss_memtoreg2),
        .iss_pc2            (iss_pc2),
        .iss_prd2           (iss_prd2),
        .iss_instr2_prs1    (iss_instr2_prs1),
        .iss_instr2_prs2    (iss_instr2_prs2),
        .iss_immediate2     (iss_immediate2),
        .iss_alu_operation2 (iss_alu_operation2),
        .iss_branch_tag2    (iss_branch_tag2),
        .iss_branch_mask2   (iss_branch_mask2),
        .iss_biq_address2   (iss_biq_address2),
        .iss_rob_index2     (iss_rob_index2)
    );

    
endmodule