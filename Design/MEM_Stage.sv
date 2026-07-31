module MEM_Stage #(
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

    output logic mem_lq_write,
    output logic [LQ_ADDRESS-1:0] mem_lq_index,
    output logic [XLEN-1:0] mem_read_data
);

    logic [3:0] ram_write_mask;
    logic [RAM_ADDRESS-1:0] ram_word_addr;
    logic [31:0] ram_write_data;
    logic [31:0] ram_read_data;

    DataMemoryWrapper dmw_instantiation (
        .CLK                (CLK),
        .reset              (reset),
        .rob_global_flush   (rob_global_flush),
        .lsq_mem_write      (lsq_mem_write),
        .lsq_mem_read       (lsq_mem_read),
        .lsq_memory_address (lsq_memory_address),
        .lsq_mem_write_data (lsq_mem_write_data),
        .lsq_mem_size       (lsq_mem_size),       
        .lsq_mem_sign_ext   (lsq_mem_sign_ext),
        .lsq_lq_index       (lsq_lq_index),
        
        .mem_lq_write       (mem_lq_write),
        .mem_lq_index       (mem_lq_index),
        .mem_read_data      (mem_read_data),
        
        .ram_write_mask     (ram_write_mask),
        .ram_word_addr      (ram_word_addr),
        .ram_write_data     (ram_write_data),
        .ram_read_data      (ram_read_data)
    );

    DataMemory dm_instantiation (
        .CLK                (CLK),
        .write_mask         (ram_write_mask),
        .word_addr          (ram_word_addr),
        .write_data         (ram_write_data),
        .read_data          (ram_read_data)
    );

endmodule