module ForwardingUnit #(
    parameter PRF_ADDRESS = 6
) (
    input logic ex_valid1,
    input logic [PRF_ADDRESS-1:0] ex_prd1,
    input logic ex_valid2,
    input logic [PRF_ADDRESS-1:0] ex_prd2,
    input logic [PRF_ADDRESS-1:0] rr_instr1_prs1,
    input logic [PRF_ADDRESS-1:0] rr_instr1_prs2,
    input logic [PRF_ADDRESS-1:0] rr_instr2_prs1,
    input logic [PRF_ADDRESS-1:0] rr_instr2_prs2,
    input logic rr_valid1,
    input logic rr_regwrite1,
    input logic [PRF_ADDRESS-1:0] rr_prd1,

    output logic [1:0] forward_ALU1_A,
    output logic [1:0] forward_ALU1_B,
    output logic [1:0] forward_ALU2_A,
    output logic [1:0] forward_ALU2_B
);
    
    always_comb begin
        // ALU 1 - Operand A
        if (ex_valid1 && (ex_prd1 == rr_instr1_prs1) && ex_prd1 != 0) begin
            forward_ALU1_A = 2'b01; 
        end
        else if (ex_valid2 && (ex_prd2 == rr_instr1_prs1) && ex_prd2 != 0) begin
            forward_ALU1_A = 2'b10; 
        end
        else begin
            forward_ALU1_A = 2'b00; 
        end
        // ALU 1 - Operand B
        if (ex_valid1 && (ex_prd1 == rr_instr1_prs2) && ex_prd1 != 0) begin
            forward_ALU1_B = 2'b01;
        end
        else if (ex_valid2 && (ex_prd2 == rr_instr1_prs2) && ex_prd2 != 0) begin
            forward_ALU1_B = 2'b10;
        end
        else begin
            forward_ALU1_B = 2'b00;
        end



        // ALU 2 - Operand A
        if (rr_valid1 && rr_regwrite1 && (rr_prd1 == rr_instr2_prs1) && rr_prd1 != 0) begin
            forward_ALU2_A = 2'b11; 
        end
        else if (ex_valid1 && (ex_prd1 == rr_instr2_prs1) && ex_prd1 != 0) begin
            forward_ALU2_A = 2'b01; 
        end
        else if (ex_valid2 && (ex_prd2 == rr_instr2_prs1) && ex_prd2 != 0) begin
            forward_ALU2_A = 2'b10; 
        end
        else begin
            forward_ALU2_A = 2'b00;
        end
        // ALU 2 - Operand B
        if (rr_valid1 && rr_regwrite1 && (rr_prd1 == rr_instr2_prs2) && rr_prd1 != 0) begin
            forward_ALU2_B = 2'b11;
        end
        else if (ex_valid1 && (ex_prd1 == rr_instr2_prs2) && ex_prd1 != 0) begin
            forward_ALU2_B = 2'b01;
        end
        else if (ex_valid2 && (ex_prd2 == rr_instr2_prs2) && ex_prd2 != 0) begin
            forward_ALU2_B = 2'b10;
        end
        else begin
            forward_ALU2_B = 2'b00;
        end
    end
endmodule
