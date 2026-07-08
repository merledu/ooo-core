module ALUCU(
    input logic [2:0] ALUOp,
    input logic [2:0] func3,
    input logic [6:0] func7,
    output logic [4:0] ALUOperation
);

    always_comb begin
        casez({ALUOp, func3, func7[5], func7[0]})

            // RV32M Extension
            8'b101000?1: ALUOperation = 5'b100_00; // MUL
            8'b101001?1: ALUOperation = 5'b100_01; // MULH
            8'b101010?1: ALUOperation = 5'b100_10; // MULHSU
            8'b101011?1: ALUOperation = 5'b100_11; // MULHU

            8'b101100?1: ALUOperation = 5'b101_00; // DIV
            8'b101101?1: ALUOperation = 5'b101_01; // DIVU
            
            8'b101110?1: ALUOperation = 5'b110_10; // REM
            8'b101111?1: ALUOperation = 5'b110_11; // REMU

            // Existing RV32I decode
            8'b000110??, 8'b101110?0: ALUOperation = 5'b00000;
            8'b000111??, 8'b101111?0: ALUOperation = 5'b00001;

            8'b100?????, 8'b10100000,
            8'b000000??, 8'b110?????,
            8'b001?????, 8'b111?????,
            8'b010?????: ALUOperation = 5'b00010;

            8'b10100010: ALUOperation = 5'b00011;

            8'b101010?0, 8'b000010??: ALUOperation = 5'b00101;

            8'b101001?0, 8'b000001??: ALUOperation = 5'b01000;

            8'b101100?0, 8'b000100??: ALUOperation = 5'b01001;

            8'b10110100, 8'b0001010?: ALUOperation = 5'b01010;

            8'b10110110, 8'b0001011?: ALUOperation = 5'b01011;

            8'b101011?0, 8'b000011??: ALUOperation = 5'b01101;

            default: ALUOperation = 5'b11111;
        endcase
    end
endmodule
