// Unit test of MEM_Stage (DataMemoryWrapper + DataMemory): random aligned sb/sh/sw and lb/lbu/lh/lhu/lw
// compared with a byte array model. Also checks that the load answer carries the right LQ index.
module tb_data_memory;
    localparam DEPTH = 64;
    logic CLK = 0, reset = 1;
    always #1 CLK = ~CLK;

    logic lsq_mem_write = 0, lsq_mem_read = 0, lsq_mem_sign_ext = 0, mem_lq_write;
    logic [31:0] lsq_memory_address = 0, lsq_mem_write_data = 0, mem_read_data;
    logic [1:0] lsq_mem_size = 0;
    logic [4:0] lsq_lq_index = 0, mem_lq_index;

    MEM_Stage #(.RAM_DEPTH(DEPTH)) dut (.CLK(CLK), .reset(reset), .rob_global_flush(1'b0), .lsq_mem_write(lsq_mem_write),
        .lsq_mem_read(lsq_mem_read), .lsq_memory_address(lsq_memory_address), .lsq_mem_write_data(lsq_mem_write_data),
        .lsq_mem_size(lsq_mem_size), .lsq_load_address(lsq_memory_address), .lsq_load_size(lsq_mem_size),
        .lsq_mem_sign_ext(lsq_mem_sign_ext), .lsq_lq_index(lsq_lq_index),
        .mem_lq_write(mem_lq_write), .mem_lq_index(mem_lq_index), .mem_read_data(mem_read_data));

    logic [7:0] model [DEPTH*4];
    int errors = 0, tests = 0;

    task automatic store(input logic [31:0] addr, input logic [1:0] size, input logic [31:0] data);
        @(negedge CLK);
        lsq_mem_write = 1; lsq_mem_read = 0; lsq_memory_address = addr; lsq_mem_size = size; lsq_mem_write_data = data;
        for (int i = 0; i < (1 << size); i++) model[addr[7:0] + i] = data[8*i +: 8];
        @(negedge CLK);
        lsq_mem_write = 0;
    endtask

    task automatic load(input logic [31:0] addr, input logic [1:0] size, input logic sign);
        logic [31:0] expected;
        logic [4:0] idx;
        idx = $urandom;
        expected = 0;
        for (int i = 0; i < (1 << size); i++) expected[8*i +: 8] = model[addr[7:0] + i];
        if (sign && size == 0) expected = {{24{expected[7]}}, expected[7:0]};
        if (sign && size == 1) expected = {{16{expected[15]}}, expected[15:0]};
        @(negedge CLK);
        lsq_mem_read = 1; lsq_mem_write = 0; lsq_memory_address = addr; lsq_mem_size = size; lsq_mem_sign_ext = sign; lsq_lq_index = idx;
        @(negedge CLK);
        lsq_mem_read = 0; lsq_memory_address = $urandom; lsq_mem_size = $urandom; lsq_lq_index = $urandom;  // answer must not depend on them
        tests++;
        if (!mem_lq_write || mem_lq_index !== idx || mem_read_data !== expected) begin
            errors++;
            if (errors < 20) $display("FAIL load addr=%h size=%0d sign=%b: valid=%b index=%0d/%0d data=%h expected=%h", addr, size, sign,
                                      mem_lq_write, mem_lq_index, idx, mem_read_data, expected);
        end
        @(negedge CLK);
        if (mem_lq_write) begin errors++; $display("FAIL load answer lasts more than one cycle"); end
    endtask

    function automatic logic [31:0] rand_addr(input logic [1:0] size);
        logic [31:0] a;
        a = {$urandom_range(32'hFFFFFF), 8'($urandom)};   // upper bits are ignored by the small memory
        if (size == 1) a[0] = 0;
        if (size >= 2) a[1:0] = 0;
        return a;
    endfunction

    initial begin
        logic [1:0] size;
        repeat (2) @(negedge CLK);
        reset = 0;
        for (int i = 0; i < DEPTH; i++) store(i * 4, 2, $urandom);
        repeat (5000) begin
            size = $urandom_range(2);
            if ($urandom_range(1)) store(rand_addr(size), size, $urandom);
            else                   load(rand_addr(size), size, $urandom_range(1));
        end
        if (errors == 0) $display("PASS tb_data_memory (%0d loads checked)", tests);
        else             $display("FAIL tb_data_memory: %0d errors in %0d loads", errors, tests);
        $finish;
    end

    // watchdog
    initial begin
        #5000000;
        $display("FAIL tb_data_memory: timeout");
        $finish;
    end
endmodule
