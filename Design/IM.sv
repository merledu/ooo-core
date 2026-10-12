module IM #(
    parameter XLEN = 32,
    parameter MEM_ROWS = 1024,
    parameter IM_ADDRESS = $clog2(MEM_ROWS),
    parameter HEX_FILE = "instructions.hex"
) 
(
    input logic CLK, read_en,
    input logic [XLEN-1:0] instr1_addr, instr2_addr, //word addresses
    output logic [XLEN-1:0] instr_1, instr_2
);
    
    (* ram_style = "block" *) logic [XLEN-1:0] IM [0:MEM_ROWS-1];

    initial begin   
        string hex_file;
        for (int i = 0; i < MEM_ROWS; i++) begin
            IM[i] = '0;
        end
        // +HEX=<file> on the simulator command line overrides the default program
        if (!$value$plusargs("HEX=%s", hex_file)) begin
            hex_file = HEX_FILE;
        end
        $readmemh(hex_file, IM);
    end

    always_ff @(posedge CLK) begin
        if (read_en) begin
            instr_1 <= IM[instr1_addr[IM_ADDRESS-1:0]];
            instr_2 <= IM[instr2_addr[IM_ADDRESS-1:0]];
        end
    end
endmodule
