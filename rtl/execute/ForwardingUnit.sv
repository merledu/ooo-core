module ForwardingUnit #(
    parameter PRF_ADDRESS = 6
) (
    input logic prev_alu1_valid, prev_alu1_regwrite,
    input logic [PRF_ADDRESS-1:0] prev_alu1_prd,
    input logic prev_alu2_valid, prev_alu2_regwrite,
    input logic [PRF_ADDRESS-1:0] prev_alu2_prd,

    input logic [PRF_ADDRESS-1:0] rr_instr1_prs1, rr_instr1_prs2,
    input logic [PRF_ADDRESS-1:0] rr_instr2_prs1, rr_instr2_prs2,
    
    input logic rr_valid1, rr_regwrite1,
    input logic [PRF_ADDRESS-1:0] rr_prd1,

    output logic [1:0] forward_ALU1_A, forward_ALU1_B,
    output logic [1:0] forward_ALU2_A, forward_ALU2_B
);
    always_comb begin
        // ALU 1 - Op A
        if (prev_alu1_valid && prev_alu1_regwrite && (prev_alu1_prd == rr_instr1_prs1) && prev_alu1_prd != 0)
            forward_ALU1_A = 2'b01; 
        else if (prev_alu2_valid && prev_alu2_regwrite && (prev_alu2_prd == rr_instr1_prs1) && prev_alu2_prd != 0)
            forward_ALU1_A = 2'b10; 
        else
            forward_ALU1_A = 2'b00; 

        // ALU 1 - Op B
        if (prev_alu1_valid && prev_alu1_regwrite && (prev_alu1_prd == rr_instr1_prs2) && prev_alu1_prd != 0)
            forward_ALU1_B = 2'b01;
        else if (prev_alu2_valid && prev_alu2_regwrite && (prev_alu2_prd == rr_instr1_prs2) && prev_alu2_prd != 0)
            forward_ALU1_B = 2'b10;
        else
            forward_ALU1_B = 2'b00;

        // ALU 2 - Op A
        if (rr_valid1 && rr_regwrite1 && (rr_prd1 == rr_instr2_prs1) && rr_prd1 != 0)
            forward_ALU2_A = 2'b11; 
        else if (prev_alu1_valid && prev_alu1_regwrite && (prev_alu1_prd == rr_instr2_prs1) && prev_alu1_prd != 0)
            forward_ALU2_A = 2'b01; 
        else if (prev_alu2_valid && prev_alu2_regwrite && (prev_alu2_prd == rr_instr2_prs1) && prev_alu2_prd != 0)
            forward_ALU2_A = 2'b10; 
        else
            forward_ALU2_A = 2'b00;

        // ALU 2 - Op B
        if (rr_valid1 && rr_regwrite1 && (rr_prd1 == rr_instr2_prs2) && rr_prd1 != 0)
            forward_ALU2_B = 2'b11;
        else if (prev_alu1_valid && prev_alu1_regwrite && (prev_alu1_prd == rr_instr2_prs2) && prev_alu1_prd != 0)
            forward_ALU2_B = 2'b01;
        else if (prev_alu2_valid && prev_alu2_regwrite && (prev_alu2_prd == rr_instr2_prs2) && prev_alu2_prd != 0)
            forward_ALU2_B = 2'b10;
        else
            forward_ALU2_B = 2'b00;
    end
endmodule
