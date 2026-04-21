module IM #(
    parameter XLEN = 32,
    parameter MEM_ROWS = 100
) 
(
    input logic CLK, 
    input logic [XLEN-1:0] instr1_addr, instr2_addr,
    output logic [XLEN-1:0] instr_1, instr_2
);
    
    (* ram_style = "block" *) logic [XLEN-1:0] IM [0:MEM_ROWS-1];

    initial begin   
        $readmemh("instructions.hex", IM);
    end

    always_ff @(posedge CLK) begin
        instr_1 <= IM[instr1_addr];
        instr_2 <= IM[instr2_addr];
    end
endmodule