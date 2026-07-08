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
    input logic CLK, reset, stall_frontend, branch_mispredicted,
    input logic cdb_done1, cdb_done2,
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

    output logic [PRF_ADDRESS-1:0]  dis_free_old_prd1, dis_free_old_prd2,
    output logic [BIQ_ADDRESS-1:0]  dis_biq_address

);


    logic [ROB_PTR_SIZE-1:0] branch_rob_index;
    logic rob_full;                          
    logic [ROB_PTR_SIZE-1:0] current_rob_index;

    





    ROB rob_instantiation (
        // System Inputs
        .CLK                 (CLK),                  
        .reset               (reset),                
        
        // Control Inputs
        .stall_frontend      (stall_frontend),       
        .branch_mispredicted (branch_mispredicted),  
        .rn_valid1           (rn_valid1),            
        .rn_valid2           (rn_valid2),            
        
        // Execution/Writeback Inputs (from Common Data Bus)
        .cdb_done1           (cdb_done1),            
        .cdb_done2           (cdb_done2),            
        .cdb_rob_index1      (cdb_rob_index1),       
        .cdb_rob_index2      (cdb_rob_index2),       
        
        // Rename Stage Inputs
        .rn_old_prd1         (rn_old_prd1),          
        .rn_old_prd2         (rn_old_prd2),          
        .rn_biq_address      (rn_biq_address),       
        
        // Branch Recovery Input
        .branch_rob_index    (branch_rob_index),     

        // inputs
        .rob_full            (rob_full),             // Route to frontend to stall fetch/decode
        .dis_biq_address     (dis_biq_address),      // Route to branch predictor/fetch for recovery
        .current_rob_index   (current_rob_index),    // Route to rename to tag newly dispatched instructions
        .dis_free_old_prd1   (dis_free_old_prd1),    // Route to PRF Free List 
        .dis_free_old_prd2   (dis_free_old_prd2)     // Route to PRF Free List 
    );
endmodule