
module IG #(
    parameter XLEN = 32,
    parameter OPCODE_SIZE = 7,
    parameter INIT_IMMEDIATE_SIZE = 21
) (
    input logic [XLEN-1:0] instruction,
    output logic [INIT_IMMEDIATE_SIZE-1:0] immediate_output,
    output logic imm_type
    );
    logic [OPCODE_SIZE-1:0] opcode;
  
    always_comb begin
        opcode = instruction[OPCODE_SIZE-1:0];
        case(opcode) 
            7'b0010011, 7'b0000011, 7'b1100111: begin 
                immediate_output = {{9{instruction[31]}},instruction[31:20]}; 
                imm_type = 0; 
            end    
            7'b0010111, 7'b0110111: begin 
                immediate_output = {instruction[31:12], 1'b0}; 
                imm_type = 1;
            end
            7'b0100011: begin 
                immediate_output = {{9{instruction[31]}}, instruction[31:25], instruction[11:7]}; 
                imm_type = 0;
            end
            7'b1100011: begin 
                immediate_output = {{8{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8],1'b0}; 
                imm_type = 0;
            end
            7'b1101111: begin 
                immediate_output = {instruction[31], instruction[19:12], instruction[20], instruction[30:21],1'b0}; 
                imm_type = 0; 
            end
            default: begin 
                immediate_output = 21'b0; 
                imm_type = 0; 
            end
        endcase
    end
endmodule
