module PreDecode(
    input logic [6:0] opcode1, opcode2, 
    input logic [4:0] rd1, rd2,
    output logic [1:0] predecode_instr1, predecode_instr2
);

    always_comb begin

        //1st instruction of bundle

        if (opcode1 == 7'b1100111 & rd1 == 5'b00001) begin
            predecode_instr1 = 2'b01; //ret
        end
        else if (opcode1 == 7'b1101111 & rd1 == 5'b00001) begin
            predecode_instr1 = 2'b10; //call
        end
        else if (opcode1 == 7'b1101111) begin
            predecode_instr1 = 2'b11; //jal
        end
        else begin
            predecode_instr1 = 2'b00; //other
        end

        //2nd instruction of bundle 

        if (opcode2 == 7'b1100111 & rd2 == 5'b00001) begin
            predecode_instr2 = 2'b01; //ret
        end
        else if (opcode2 == 7'b1101111 & rd2 == 5'b00001) begin
            predecode_instr2 = 2'b10; //call
        end
        else if (opcode2 == 7'b1101111) begin
            predecode_instr2 = 2'b11; //jal
        end
        else begin
            predecode_instr2 = 2'b00; //other
        end
    end
    
endmodule