module DataMemory #(
    parameter RAM_DEPTH = 64,
    parameter RAM_ADDRESS = $clog2(RAM_DEPTH)
) (
    input logic CLK,
    input logic [3:0] write_mask,
    input logic [RAM_ADDRESS-1:0] word_addr,
    input logic [31:0] write_data,
    output logic [31:0] read_data
);

    // The physical byte-addressable RAM array
    logic [7:0] RAM [0:RAM_DEPTH-1][0:3]; 

    // Synchronous Read and Write
    always_ff @(posedge CLK) begin
        // Byte-enabled Write
        if (write_mask[0]) RAM[word_addr][0] <= write_data[7:0];
        if (write_mask[1]) RAM[word_addr][1] <= write_data[15:8];
        if (write_mask[2]) RAM[word_addr][2] <= write_data[23:16];
        if (write_mask[3]) RAM[word_addr][3] <= write_data[31:24];
        
        // Synchronous Read
        read_data <= {RAM[word_addr][3], RAM[word_addr][2], RAM[word_addr][1], RAM[word_addr][0]};
    end

endmodule