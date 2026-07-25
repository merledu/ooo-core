module DIS_Stage #(
    parameter XLEN = 32,
    parameter PRF_ADDRESS = 6,
    parameter BIQ_ADDRESS = 5,
    parameter ROB_SIZE = 64,
    parameter INIT_IMMEDIATE_SIZE = 21,
    parameter ROB_PTR_SIZE = $clog2(ROB_SIZE),
    parameter MAX_BRANCHES = 4,
    parameter BTAG_SIZE = $clog2(MAX_BRANCHES),
    parameter LQ_ENTRIES = 32,
    parameter LQ_ADDRESS = $clog2(LQ_ENTRIES),
    parameter SQ_ENTRIES = 16,
    parameter SQ_ADDRESS = $clog2(SQ_ENTRIES)
) (
    input logic CLK, reset, flush, stall_frontend, cdb_mul_busy, cdb_div_busy,
    input logic cdb_done1, cdb_done2, cdb_wakeup1, cdb_wakeup2, cdb_branch_resolved,
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
    input logic [XLEN-3:0] rn_pc1, rn_pc2, // Needed for ROB allocation
    input logic [4:0] rn_rd_1, rn_rd_2,
    input logic [INIT_IMMEDIATE_SIZE-1:0] rn_immout1, rn_immout2,
    input logic rn_is_m_extension1, rn_is_m_extension2,
    input logic [1:0] rn_memory_type1, rn_memory_type2, 
    input logic rn_memory_sign_ext1, rn_memory_sign_ext2,
    input logic [4:0] rn_alu_operation1, rn_alu_operation2,
    
    input logic rn_valid1, rn_jump_reg1, rn_jump1, rn_branch1, 
    input logic rn_regsrc1_1, rn_regsrc2_1, rn_immtype1, rn_isimm1, rn_retaddr1,
    input logic rn_upperimm1, rn_regwrite1, rn_memwrite1, rn_memtoreg1, 
    
    input logic rn_valid2, rn_jump_reg2, rn_jump2, rn_branch2, 
    input logic rn_regsrc1_2, rn_regsrc2_2, rn_immtype2, rn_isimm2, rn_retaddr2,
    input logic rn_upperimm2, rn_regwrite2, rn_memwrite2, rn_memtoreg2,
    
    input logic rn_is_load1, rn_is_load2,   // Needed for ROB
    input logic rn_is_store1, rn_is_store2, // Needed for ROB
    input logic [ROB_PTR_SIZE-1:0] rn_rob_index1, rn_rob_index2, // Needed for LSQ snapshot tracking
    
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
    output logic [ROB_PTR_SIZE-1:0] iss_rob_index2,

    // LSQ EXTERNAL PORTS REQUIRED FOR CONNECTIVITY
    input logic cdb_address_available1, cdb_is_load1,
    input logic [LQ_ADDRESS-1:0] cdb_lq_index1,
    input logic [XLEN-1:0] cdb_memory_address1,
    
    input logic cdb_address_available2, cdb_is_load2,
    input logic [LQ_ADDRESS-1:0] cdb_lq_index2,
    input logic [XLEN-1:0] cdb_memory_address2,
    
    input logic ex_mem_address1_available, ex_is_load1, ex_is_store1,
    input logic [XLEN-1:0] ex_mem_address1,
    input logic [LQ_ADDRESS-1:0] ex_lq_index1,
    input logic [SQ_ADDRESS-1:0] ex_sq_index1,
    
    input logic ex_mem_address2_available, ex_is_load2, ex_is_store2,
    input logic [XLEN-1:0] ex_mem_address2,
    input logic [LQ_ADDRESS-1:0] ex_lq_index2,
    input logic [SQ_ADDRESS-1:0] ex_sq_index2,
    
    input logic cdb_result1_available, cdb_result2_available,
    input logic [XLEN-1:0] cdb_result1_broadcast, cdb_result2_broadcast,
    
    // Memory Responses
    input logic mem_lq_write,
    input logic [LQ_ADDRESS-1:0] mem_lq_index,
    input logic [XLEN-1:0] mem_read_data,

    // Output Memory Requests from LSQ
    output logic lsq_mem_write, lsq_mem_read,
    output logic [XLEN-1:0] lsq_memory_address, lsq_mem_write_data,
    output logic [1:0] lsq_mem_size,
    output logic lsq_mem_sign_ext,
    
    // PRF Write Outputs from LSQ
    output logic lsq_write_prf,
    output logic [XLEN-1:0] lsq_write_prf_data,
    output logic [LQ_ADDRESS-1:0] lsq_lq_index,
    output logic [PRF_ADDRESS-1:0] lsq_write_prf_address,
    
    // Global Flush Signals exported to Frontend
    output logic rob_global_flush,
    output logic [XLEN-3:0] rob_flush_pc
);

    // INTERNAL WIRES (Connecting ROB, IQ, and LSQ)
    logic rob_full, iq_full, lsq_full;           
    logic [ROB_PTR_SIZE:0] current_rob_index;
    
    // Violation Flush Signals (LSQ -> ROB)
    logic load1_violation_flush;
    logic load2_violation_flush;
    
    // Commit Signals (ROB -> LSQ)
    logic commit_is_load1;
    logic commit_is_load2;
    logic commit_is_store1;
    logic commit_is_store2;

    // Stall logic now checks all three queues!
    assign dis_stall_frontend = rob_full || iq_full || lsq_full;

    // MODULE INSTANTIATIONS

    ROB #(
        .XLEN               (XLEN),
        .PRF_ADDRESS        (PRF_ADDRESS),
        .ROB_SIZE           (ROB_SIZE),
        .ROB_PTR_SIZE       (ROB_PTR_SIZE)
    ) rob_instantiation (
        .CLK                    (CLK),
        .reset                  (reset),
        .stall_frontend         (stall_frontend),
        .flush                  (flush), 
        
        .rn_valid1              (rn_valid1),
        .rn_valid2              (rn_valid2),
        .rn_rd1                 (rn_rd_1),
        .rn_rd2                 (rn_rd_2),
        .rn_prd1                (rn_prd1),
        .rn_prd2                (rn_prd2),
        .rn_old_prd1            (rn_old_prd1),
        .rn_old_prd2            (rn_old_prd2),
        .rn_pc1                 (rn_pc1),           
        .rn_pc2                 (rn_pc2),           
        .rn_is_load1            (rn_is_load1),      
        .rn_is_load2            (rn_is_load2),      
        .rn_is_store1           (rn_is_store1),     
        .rn_is_store2           (rn_is_store2),     

        .cdb_done1              (cdb_done1),
        .cdb_done2              (cdb_done2),
        .cdb_rob_index1         (cdb_rob_index1),
        .cdb_rob_index2         (cdb_rob_index2),
        .cdb_branch_rob_index   (cdb_branch_rob_index),

        .load1_violation_flush  (load1_violation_flush), 
        .load2_violation_flush  (load2_violation_flush), 

        .rob_full               (rob_full),
        .current_rob_index      (current_rob_index),

        .commit_instr1          (commit_instr1),
        .commit_instr2          (commit_instr2),
        .comm_prd1              (comm_prd1),
        .comm_prd2              (comm_prd2),
        .comm_rd1               (comm_rd1),
        .comm_rd2               (comm_rd2),
        .commit_is_load1        (commit_is_load1),   
        .commit_is_load2        (commit_is_load2),   
        .commit_is_store1       (commit_is_store1),  
        .commit_is_store2       (commit_is_store2),  
        
        .rob_global_flush       (rob_global_flush),  
        .rob_flush_pc           (rob_flush_pc),      

        .dis_free_old_prd1      (dis_free_old_prd1),
        .dis_free_old_prd2      (dis_free_old_prd2)
    );
    
    IQ iq_instantiation (
        .CLK                (CLK),
        .reset              (reset),
        .rob_full           (rob_full),
        .flush              (flush),
        
        .cdb_mul_busy       (cdb_mul_busy),
        .cdb_div_busy       (cdb_div_busy),
        .cdb_wakeup1        (cdb_wakeup1),
        .cdb_wakeup2        (cdb_wakeup2),
        .cdb_branch_resolved(cdb_branch_resolved),
        .cdb_branch_correct (!flush),
        .cdb_waked_reg1     (cdb_waked_reg1),
        .cdb_waked_reg2     (cdb_waked_reg2),
        .cdb_branch_tag     (cdb_branch_tag),

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
        
        .rn_branch_tag      (rn_branch_tag),
        .rn_branch_mask     (rn_branch_mask),
        .rn_biq_address     (rn_biq_address),
        .current_rob_index  (current_rob_index[ROB_PTR_SIZE-1:0]),

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
        
        .iq_full            (iq_full),

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

        .iss_valid2         (iss_valid2),
        .iss_is_m_extension2(iss_is_m_extension2), // [FIXED TYPO]
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

    LSQ #(
        .XLEN               (XLEN),
        .LQ_ENTRIES         (LQ_ENTRIES),
        .LQ_ADDRESS         (LQ_ADDRESS),
        .SQ_ENTRIES         (SQ_ENTRIES),
        .SQ_ADDRESS         (SQ_ADDRESS),
        .PRF_ADDRESS        (PRF_ADDRESS),
        .ROB_SIZE           (ROB_SIZE),
        .ROB_PTR_SIZE       (ROB_PTR_SIZE)
    ) lsq_instantiation (
        .CLK                        (CLK),
        .reset                      (reset),
        .stall_frontend             (stall_frontend),
        .rob_global_flush           (rob_global_flush),
        .branch_mispredicted        (flush),
        
        .rn_valid1                  (rn_valid1),
        .rn_valid2                  (rn_valid2),
        .rn_memtoreg1               (rn_memtoreg1),
        .rn_memtoreg2               (rn_memtoreg2),
        .rn_memwrite1               (rn_memwrite1),
        .rn_memwrite2               (rn_memwrite2),
        .rn_is_branch1              (rn_is_branch1),
        .rn_is_branch2              (rn_is_branch2),
        .rn_rob_index1              (rn_rob_index1),
        .rn_rob_index2              (rn_rob_index2),
        .rn_prd1                    (rn_prd1),
        .rn_prd2                    (rn_prd2),
        .rn_prs2_1                  (rn_prs2_1),
        .rn_prs2_2                  (rn_prs2_2),
        .rn_prs2_busy1              (rn_prs2_busy1),
        .rn_prs2_busy2              (rn_prs2_busy2),
        .rn_memory_type1            (rn_memory_type1),
        .rn_memory_type2            (rn_memory_type2),
        .rn_memory_sign_ext1        (rn_memory_sign_ext1),
        .rn_memory_sign_ext2        (rn_memory_sign_ext2),
        .current_rob_index          (current_rob_index),
        
        // Branch Recovery
        .cdb_branch_rob_index       (cdb_branch_rob_index),

        .cdb_address_available1     (cdb_address_available1),
        .cdb_is_load1               (cdb_is_load1),
        .cdb_lq_index1              (cdb_lq_index1),
        .cdb_memory_address1        (cdb_memory_address1),
        
        .cdb_address_available2     (cdb_address_available2),
        .cdb_is_load2               (cdb_is_load2),
        .cdb_lq_index2              (cdb_lq_index2),
        .cdb_memory_address2        (cdb_memory_address2),

        .ex_mem_address1_available  (ex_mem_address1_available),
        .ex_is_load1                (ex_is_load1),
        .ex_is_store1               (ex_is_store1),
        .ex_mem_address1            (ex_mem_address1),
        .ex_lq_index1               (ex_lq_index1),
        .ex_sq_index1               (ex_sq_index1),
        
        .ex_mem_address2_available  (ex_mem_address2_available),
        .ex_is_load2                (ex_is_load2),
        .ex_is_store2               (ex_is_store2),
        .ex_mem_address2            (ex_mem_address2),
        .ex_lq_index2               (ex_lq_index2),
        .ex_sq_index2               (ex_sq_index2),
        
        // CDB Broadcast / Snooping
        .cdb_result1_available      (cdb_result1_available),
        .cdb_result2_available      (cdb_result2_available),
        .cdb_tag1_broadcast         (cdb_waked_reg1), // Mapped to waked_reg from top
        .cdb_tag2_broadcast         (cdb_waked_reg2), // Mapped to waked_reg from top
        .cdb_result1_broadcast      (cdb_result1_broadcast),
        .cdb_result2_broadcast      (cdb_result2_broadcast),
        
        // Commit Signals (from internal ROB)
        .commit_is_load1            (commit_is_load1),
        .commit_is_load2            (commit_is_load2),
        .commit_is_store1           (commit_is_store1),
        .commit_is_store2           (commit_is_store2),
        
        // Memory Interface (Read Responses)
        .mem_lq_write               (mem_lq_write),
        .mem_lq_index               (mem_lq_index),
        .mem_read_data              (mem_read_data),

        // Outputs to Top Level
        .lsq_full                   (lsq_full),
        .load1_violation_flush      (load1_violation_flush), // Routed to internal ROB
        .load2_violation_flush      (load2_violation_flush), // Routed to internal ROB
        
        // Memory Interface (Requests)
        .lsq_mem_write              (lsq_mem_write),
        .lsq_mem_read               (lsq_mem_read),
        .lsq_memory_address         (lsq_memory_address),
        .lsq_mem_write_data         (lsq_mem_write_data),
        .lsq_mem_size               (lsq_mem_size),
        .lsq_mem_sign_ext           (lsq_mem_sign_ext),
        
        // PRF Write Arbitration
        .lsq_write_prf              (lsq_write_prf),
        .lsq_write_prf_data         (lsq_write_prf_data),
        .lsq_lq_index               (lsq_lq_index),
        .lsq_write_prf_address      (lsq_write_prf_address)
    );
    
endmodule
