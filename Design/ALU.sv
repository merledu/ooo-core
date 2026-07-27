module ALU #(
    parameter XLEN = 32
)(
    input logic valid,
    input logic [XLEN-1:0] dataA, dataB,
    input logic [4:0] rr_alu_operation,
    output logic [XLEN-1:0] alu_result
);

    always_comb begin
        alu_result = 0;
        if (valid) begin
            case(rr_alu_operation[3:0])
                4'b0000: alu_result = dataA | dataB;
                4'b0001: alu_result = dataA & dataB;
                4'b0010: alu_result = dataA + dataB;
                4'b0011: alu_result = dataA - dataB;
                4'b0101: alu_result = {31'b0, ($signed(dataA) < $signed(dataB))};
                4'b1000: alu_result = dataA << dataB[4:0];
                4'b1001: alu_result = dataA ^ dataB;
                4'b1010: alu_result = $unsigned(dataA) >> dataB[4:0];
                4'b1011: alu_result = $signed(dataA) >>> dataB[4:0];
                4'b1101: alu_result = {31'b0, (dataA < dataB)};
                default: alu_result = 32'b0;
            endcase
        end
    end
endmodule
