module DataMemoryWrapper #(
    parameter XLEN = 32,
    parameter LQ_ADDRESS = 5,  
    parameter RAM_DEPTH = 64,
    parameter RAM_ADDRESS = $clog2(RAM_DEPTH)
) (
    input logic CLK, reset, rob_global_flush,
    input logic lsq_mem_write,
    input logic lsq_mem_read,
    input logic [XLEN-1:0] lsq_memory_address,
    input logic [XLEN-1:0] lsq_mem_write_data,
    input logic [1:0] lsq_mem_size,             
    input logic lsq_mem_sign_ext,
    input logic [LQ_ADDRESS-1:0] lsq_lq_index,
    input logic [31:0] ram_read_data,

    output logic mem_lq_write,
    output logic [LQ_ADDRESS-1:0] mem_lq_index,
    output logic [XLEN-1:0] mem_read_data,
    output logic [3:0] ram_write_mask,
    output logic [RAM_ADDRESS-1:0] ram_word_addr,
    output logic [31:0] ram_write_data
);

    logic [1:0] write_offset;
    
    assign write_offset = lsq_memory_address[1:0];
    assign ram_word_addr = lsq_memory_address[RAM_ADDRESS+1 : 2]; 

    always_comb begin
        ram_write_mask = 4'b0000;
        ram_write_data = lsq_mem_write_data << {write_offset, 3'b000}; 

        if (lsq_mem_write) begin
            if (lsq_mem_size == 2'b00) begin // Byte (SB)
                ram_write_mask[write_offset] = 1'b1;
            end 
            else if (lsq_mem_size == 2'b01) begin // Halfword (SH)
                ram_write_mask[write_offset] = 1'b1;
                ram_write_mask[write_offset + 1] = 1'b1;
            end 
            else begin // Word (SW)
                ram_write_mask = 4'b1111;
            end
        end
    end

    logic saved_valid;
    logic [1:0] saved_size;
    logic saved_sign_ext;
    logic [1:0] saved_offset;
    logic [LQ_ADDRESS-1:0] saved_lq_index;

    always_ff @(posedge CLK) begin
        if (reset || rob_global_flush) begin
            saved_valid <= 0;
        end 
        else begin
            saved_valid <= lsq_mem_read;
            if (lsq_mem_read) begin
                saved_size     <= lsq_mem_size;  
                saved_sign_ext <= lsq_mem_sign_ext;
                saved_offset   <= lsq_memory_address[1:0];
                saved_lq_index <= lsq_lq_index;
            end
        end
    end

    logic [31:0] shifted_mem_read_data;
    
    assign mem_lq_write = saved_valid;
    assign mem_lq_index = saved_lq_index;

    always_comb begin
        shifted_mem_read_data = ram_read_data >> {saved_offset, 3'b000};
        mem_read_data = ram_read_data; 

        if (saved_size == 2'b00) begin // Byte (LB / LBU)
            mem_read_data = saved_sign_ext ? {{24{shifted_mem_read_data[7]}}, shifted_mem_read_data[7:0]} 
                                           : {24'b0, shifted_mem_read_data[7:0]};
        end 
        else if (saved_size == 2'b01) begin // Halfword (LH / LHU)
            mem_read_data = saved_sign_ext ? {{16{shifted_mem_read_data[15]}}, shifted_mem_read_data[15:0]} 
                                           : {16'b0, shifted_mem_read_data[15:0]};
        end
    end

endmodule