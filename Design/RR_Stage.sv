module RR_Stage #(
    parameter XLEN = 32,
    parameter MAX_BRANCHES = 4,
    parameter BTAG_SIZE = $clog2(MAX_BRANCHES),
    parameter PRF_ADDRESS = 6,
    parameter INIT_IMMEDIATE_SIZE = 21,
    parameter BIQ_ADDRESS = 5,
    parameter ROB_SIZE = 64,
    parameter ROB_PTR_SIZE = $clog2(ROB_SIZE)
) (
    input logic CLK, reset, flush, cdb_regwrite1, cdb_regwrite2, rob_global_flush,
    input logic [BTAG_SIZE-1:0] cdb_branch_tag,
    input logic [PRF_ADDRESS-1:0] cdb_write_address1, cdb_write_address2,
    input logic [XLEN-1:0] cdb_write_data1, cdb_write_data2,
     // Issued Instruction 1
    input logic iss_valid1, iss_is_m_extension1, iss_jump_reg1, iss_jump1, iss_branch1, 
    input logic iss_instr1_regsrc1, iss_instr1_regsrc2, iss_immtype1, iss_isimm1, iss_retaddr1,
    input logic iss_upperimm1, iss_regwrite1, iss_memwrite1, iss_memtoreg1,
    input logic [XLEN-3:0] iss_pc1,
    input logic [PRF_ADDRESS-1:0] iss_prd1, iss_instr1_prs1, iss_instr1_prs2,
    input logic [INIT_IMMEDIATE_SIZE-1:0] iss_immediate1,
    input logic [4:0] iss_alu_operation1,
    input logic [BTAG_SIZE-1:0] iss_branch_tag1,
    input logic [MAX_BRANCHES-1:0] iss_branch_mask1,
    input logic [BIQ_ADDRESS-1:0] iss_biq_address1,
    input logic [ROB_PTR_SIZE-1:0] iss_rob_index1,

    // Issued Instruction 2
    input logic iss_valid2, iss_is_m_extension2, iss_jump_reg2, iss_jump2, iss_branch2, 
    input logic iss_instr2_regsrc1, iss_instr2_regsrc2, iss_immtype2, iss_isimm2, iss_retaddr2,
    input logic iss_upperimm2, iss_regwrite2, iss_memwrite2, iss_memtoreg2,
    input logic [XLEN-3:0] iss_pc2,
    input logic [PRF_ADDRESS-1:0] iss_prd2, iss_instr2_prs1, iss_instr2_prs2,
    input logic [INIT_IMMEDIATE_SIZE-1:0] iss_immediate2,
    input logic [4:0] iss_alu_operation2,
    input logic [BTAG_SIZE-1:0] iss_branch_tag2,
    input logic [MAX_BRANCHES-1:0] iss_branch_mask2,
    input logic [BIQ_ADDRESS-1:0] iss_biq_address2,
    input logic [ROB_PTR_SIZE-1:0] iss_rob_index2,

    output logic [XLEN-1:0] rr_instr1_read_data1, rr_instr1_read_data2,
    output logic [XLEN-1:0] rr_instr2_read_data1, rr_instr2_read_data2,
    // Instruction 1 Outputs
    output logic rr_valid1, rr_is_m_extension1, rr_jump_reg1, rr_jump1, rr_branch1,
    output logic rr_instr1_regsrc1, rr_instr1_regsrc2, rr_isimm1, rr_retaddr1, rr_upperimm1,
    output logic rr_regwrite1, rr_memwrite1, rr_memtoreg1,
    output logic [XLEN-3:0]                rr_pc1,
    output logic [PRF_ADDRESS-1:0]         rr_prd1,
    output logic [XLEN-1:0]                rr_immediate1,
    output logic [4:0]                     rr_alu_operation1,
    output logic [BTAG_SIZE-1:0]           rr_branch_tag1,
    output logic [MAX_BRANCHES-1:0]        rr_branch_mask1,
    output logic [BIQ_ADDRESS-1:0]         rr_biq_address1,
    output logic [ROB_PTR_SIZE-1:0]        rr_rob_index1,
    // Instruction 2 Outputs
    output logic rr_valid2, rr_is_m_extension2, rr_jump_reg2, rr_jump2, rr_branch2,
    output logic rr_instr2_regsrc1, rr_instr2_regsrc2, rr_isimm2, rr_retaddr2, rr_upperimm2,
    output logic rr_regwrite2, rr_memwrite2, rr_memtoreg2,
    output logic [XLEN-3:0]                rr_pc2,
    output logic [PRF_ADDRESS-1:0]         rr_prd2,
    output logic [XLEN-1:0]                rr_immediate2,
    output logic [4:0]                     rr_alu_operation2,
    output logic [BTAG_SIZE-1:0]           rr_branch_tag2,
    output logic [MAX_BRANCHES-1:0]        rr_branch_mask2,
    output logic [BIQ_ADDRESS-1:0]         rr_biq_address2,
    output logic [ROB_PTR_SIZE-1:0]        rr_rob_index2
);
    always_ff @(posedge CLK) begin
        rr_valid1 <= iss_valid1 && (!(flush && iss_branch_mask1[cdb_branch_tag]) && !rob_global_flush);   
        rr_valid2 <= iss_valid2 && (!(flush && iss_branch_mask2[cdb_branch_tag]) && !rob_global_flush);   
        //for 1st instruction 
        rr_is_m_extension1 <= iss_is_m_extension1;
        rr_jump_reg1       <= iss_jump_reg1; 
        rr_jump1           <= iss_jump1;
        rr_branch1         <= iss_branch1;
        rr_instr1_regsrc1  <= iss_instr1_regsrc1;
        rr_instr1_regsrc2  <= iss_instr1_regsrc2;
        rr_isimm1          <= iss_isimm1;
        rr_retaddr1        <= iss_retaddr1;
        rr_upperimm1       <= iss_upperimm1;
        rr_regwrite1       <= iss_regwrite1;
        rr_memwrite1       <= iss_memwrite1;
        rr_memtoreg1       <= iss_memtoreg1;
        rr_pc1             <= iss_pc1;
        rr_prd1            <= iss_prd1;
        rr_alu_operation1  <= iss_alu_operation1;
        rr_branch_tag1     <= iss_branch_tag1;
        rr_branch_mask1    <= iss_branch_mask1;
        rr_biq_address1    <= iss_biq_address1;
        rr_rob_index1      <= iss_rob_index1;


        //for 2nd instruction
        rr_is_m_extension2 <= iss_is_m_extension2;
        rr_jump_reg2       <= iss_jump_reg2; 
        rr_jump2           <= iss_jump2;
        rr_branch2         <= iss_branch2;
        rr_instr2_regsrc1  <= iss_instr2_regsrc1;
        rr_instr2_regsrc2  <= iss_instr2_regsrc2;
        rr_isimm2          <= iss_isimm2;
        rr_retaddr2        <= iss_retaddr2;
        rr_upperimm2       <= iss_upperimm2;
        rr_regwrite2       <= iss_regwrite2;
        rr_memwrite2       <= iss_memwrite2;
        rr_memtoreg2       <= iss_memtoreg2;
        rr_pc2             <= iss_pc2;
        rr_prd2            <= iss_prd2;
        rr_alu_operation2  <= iss_alu_operation2;
        rr_branch_tag2     <= iss_branch_tag2;
        rr_branch_mask2    <= iss_branch_mask2;
        rr_biq_address2    <= iss_biq_address2;
        rr_rob_index2      <= iss_rob_index2;
    end
    
    PRF prf_instantiation (
        // ------------------- Globals & Control -------------------
        .CLK                 (CLK),
        .reset               (reset),
        
        // ------------------- Write Ports (From CDB) -------------------
        .cdb_regwrite1       (cdb_regwrite1),
        .cdb_regwrite2       (cdb_regwrite2),
        .cdb_write_address1  (cdb_write_address1),
        .cdb_write_address2  (cdb_write_address2),
        .cdb_write_data1     (cdb_write_data1),
        .cdb_write_data2     (cdb_write_data2),

        // ------------------- Read Ports (From Issue Queue) -------------------
        .iss_instr1_prs1     (iss_instr1_prs1),
        .iss_instr1_prs2     (iss_instr1_prs2),
        .iss_instr2_prs1     (iss_instr2_prs1),
        .iss_instr2_prs2     (iss_instr2_prs2),

        // ------------------- Read Data (To ALU/Execution) -------------------
        .rr_instr1_read_data1(rr_instr1_read_data1),
        .rr_instr1_read_data2(rr_instr1_read_data2),
        .rr_instr2_read_data1(rr_instr2_read_data1),
        .rr_instr2_read_data2(rr_instr2_read_data2)
    );
    IG ig_instantiation (
        // ------------------- Inputs (From Issue Queue) -------------------
        .iss_immediate1(iss_immediate1),
        .iss_immediate2(iss_immediate2),
        .iss_immtype1  (iss_immtype1),
        .iss_immtype2  (iss_immtype2),
        
        // ------------------- Outputs (To ALU/Execution) -------------------
        .rr_immediate1 (rr_immediate1),
        .rr_immediate2 (rr_immediate2)
    );
endmodule
