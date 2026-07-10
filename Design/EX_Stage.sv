module EX_Stage #(
    parameter XLEN = 32,
    parameter PRF_ADDRESS = 6,
    parameter ROB_PTR_SIZE = 6
) (
    input logic CLK, reset,
    input logic [XLEN-1:0] rr_instr1_read_data1, rr_instr1_read_data2,
    input logic [XLEN-1:0] rr_instr2_read_data1, rr_instr2_read_data2,
    // Instruction 1 inputs
    input logic rr_valid1, rr_is_m_extension1, rr_jump_reg1, rr_jump1, rr_branch1,
    input logic rr_instr1_regsrc1, rr_instr1_regsrc2, rr_isimm1, rr_retaddr1, rr_upperimm1,
    input logic rr_regwrite1, rr_memwrite1, rr_memtoreg1,
    input logic [XLEN-3:0]                rr_pc1,
    input logic [PRF_ADDRESS-1:0]         rr_prd1,
    input logic [XLEN-1:0]                rr_immediate1,
    input logic [4:0]                     rr_alu_operation1,
    input logic [BTAG_SIZE-1:0]           rr_branch_tag1,
    input logic [MAX_BRANCHES-1:0]        rr_branch_mask1,
    input logic [BIQ_ADDRESS-1:0]         rr_biq_address1,
    input logic [ROB_PTR_SIZE-1:0]        rr_rob_index1,
    // Instruction 2 inputs
    input logic rr_valid2, rr_is_m_extension2, rr_jump_reg2, rr_jump2, rr_branch2,
    input logic rr_instr2_regsrc1, rr_instr2_regsrc2, rr_isimm2, rr_retaddr2, rr_upperimm2,
    input logic rr_regwrite2, rr_memwrite2, rr_memtoreg2,
    input logic [XLEN-3:0]                rr_pc2,
    input logic [PRF_ADDRESS-1:0]         rr_prd2,
    input logic [XLEN-1:0]                rr_immediate2,
    input logic [4:0]                     rr_alu_operation2,
    input logic [BTAG_SIZE-1:0]           rr_branch_tag2,
    input logic [MAX_BRANCHES-1:0]        rr_branch_mask2,
    input logic [BIQ_ADDRESS-1:0]         rr_biq_address2,
    input logic [ROB_PTR_SIZE-1:0]        rr_rob_index2,
    
    output logic [XLEN-1:0] cdb_result,
    output logic [PRF_ADDRESS-1:0] cdb_prd,
    output logic [ROB_PTR_SIZE-1:0] cdb_rob_index
);
    logic is_mul1, is_div1, is_alu1, is_mul2, is_div2, is_alu2;
    
    always_comb begin
        is_mul1 = 1'b0;
        is_div1 = 1'b0;
        is_alu1 = 1'b0;

        is_mul2 = 1'b0;
        is_div2 = 1'b0;
        is_alu2 = 1'b0;

        if (rr_alu_operation1[4:2] == 3'b100) begin
            is_mul1 = 1'b1; 
        end 
        else if (rr_alu_operation1 == 5'b101_00 || rr_alu_operation1 == 5'b101_01 || 
                 rr_alu_operation1 == 5'b110_10 || rr_alu_operation1 == 5'b110_11) begin
            is_div1 = 1'b1; 
        end
        else begin
            is_alu1 = 1'b1;  
        end

        if (rr_alu_operation2[4:2] == 3'b100) begin
            is_mul2 = 1'b1; 
        end
        else if (rr_alu_operation2 == 5'b101_00 || rr_alu_operation2 == 5'b101_01 || 
                 rr_alu_operation2 == 5'b110_10 || rr_alu_operation2 == 5'b110_11) begin
            is_div2 = 1'b1;  
        end
        else begin
            is_alu2 = 1'b1;  
        end
    end

    // =========================================================================
    // Multiplier Instantiation
    // =========================================================================
    logic mul_busy;
    logic mul_cdb_valid;
    logic [XLEN-1:0] mul_result;
    logic [PRF_ADDRESS-1:0] mul_prd;
    logic [ROB_PTR_SIZE-1:0] mul_rob_index;

    MUL_Unit multiplier_instantiation (
        // Global & Control
        .CLK(CLK), 
        .reset(reset), 
        .flush(flush), 
        
        // The Routed Valid Signal (from your traffic cop logic: issue_valid & is_mul)
        .valid(start_mul),               
        
        // Branch Mask & Flush Interface
        .cdb_branch_tag(cdb_branch_tag),
        .rr_branch_mask(rr_branch_mask),
        .cdb_branch_resolved(cdb_branch_resolved),
        .cdb_branch_correct(cdb_branch_correct),
        
        // Data & Instruction Inputs
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .alu_operation(alu_operation),
        .rr_prd(rr_prd),
        .rr_rob_index(rr_rob_index),
        
        // Outputs to the Wrapper / Common Data Bus
        .cdb_mul_busy(mul_busy),
        .cdb_write_data(mul_cdb_valid),
        .cdb_alu_result(mul_result),
        .cdb_prd(mul_prd),
        .cdb_rob_index(mul_rob_index)
    );

    DIV_Unit divider_instantiation (
        .CLK(CLK),
        .reset(reset),
    
        .valid(),         
        
        .flush(flush),
        .cdb_branch_tag(cdb_branch_tag),
        .rr_branch_mask(rr_branch_mask),
        .cdb_branch_resolved(cdb_branch_resolved),
        .cdb_branch_correct(cdb_branch_correct),
        
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .alu_operation(alu_operation),
        
        .rr_prd(rr_prd),
        .rr_rob_index(rr_rob_index),
        
        .cdb_div_busy(div_busy), 
    
        .cdb_write_data(div_cdb_valid),
        .cdb_alu_result(div_result),
        .cdb_prd(div_prd),
        .cdb_rob_index(div_rob_index)
    );

endmodule
