// Unit test of LSQ together with MEM_Stage (data memory). Directed scenarios:
//  1. load without older store reads the memory
//  2. store-to-load forwarding (word, sign/zero extended half and byte out of a word store), youngest store wins
//  3. a store is written to memory only after it is committed, stores are written in program order
//  4. load which overlaps a narrower store waits until that store is in memory
//  5. load executed before an older store knew its address: violation when the store hits the same bytes, none otherwise
//  6. branch misprediction drops the younger loads/stores, memory violation flush keeps the committed stores
module tb_lsq;
    logic CLK = 0, reset = 1;
    always #1 CLK = ~CLK;

    logic dis_fire = 0, rob_global_flush = 0, flush = 0;
    logic rn_valid1 = 0, rn_valid2 = 0, rn_memtoreg1 = 0, rn_memtoreg2 = 0, rn_memwrite1 = 0, rn_memwrite2 = 0, rn_is_branch1 = 0;
    logic [5:0] rn_rob_index1 = 0, rn_rob_index2 = 0, rn_prd1 = 0, rn_prd2 = 0, ex_branch_rob_index = 0;
    logic [1:0] rn_memory_type1 = 0, rn_memory_type2 = 0;
    logic rn_sign1 = 0, rn_sign2 = 0;
    logic ex_valid1 = 0, ex_is_load1 = 0, ex_is_store1 = 0, ex_valid2 = 0, ex_is_load2 = 0, ex_is_store2 = 0;
    logic [4:0] ex_index1 = 0, ex_index2 = 0;
    logic [31:0] ex_addr1 = 0, ex_data1 = 0, ex_addr2 = 0, ex_data2 = 0;
    logic commit_is_load1 = 0, commit_is_store1 = 0;
    logic cdb_ready = 1;

    logic lsq_full, viol1, viol2, lsq_mem_write, lsq_mem_read, lsq_write_prf, lsq_mem_sign_ext, mem_lq_write, lsq_ack;
    logic [4:0] dis_lq_index1, dis_lq_index2, lsq_lq_index, mem_lq_index;
    logic [3:0] dis_sq_index1, dis_sq_index2;
    logic [31:0] lsq_memory_address, lsq_mem_write_data, lsq_write_prf_data, mem_read_data, lsq_load_address;
    logic [5:0] lsq_write_prf_address, lsq_rob_index;
    logic [1:0] lsq_mem_size, lsq_load_size;

    assign lsq_ack = lsq_write_prf && cdb_ready;

    LSQ lsq (
        .CLK(CLK), .reset(reset), .dis_fire(dis_fire), .rob_global_flush(rob_global_flush), .flush(flush),
        .rn_valid1(rn_valid1), .rn_valid2(rn_valid2), .rn_memtoreg1(rn_memtoreg1), .rn_memtoreg2(rn_memtoreg2),
        .rn_memwrite1(rn_memwrite1), .rn_memwrite2(rn_memwrite2), .rn_is_branch1(rn_is_branch1), .rn_is_branch2(1'b0),
        .rn_rob_index1(rn_rob_index1), .rn_rob_index2(rn_rob_index2), .rn_prd1(rn_prd1), .rn_prd2(rn_prd2),
        .rn_memory_type1(rn_memory_type1), .rn_memory_type2(rn_memory_type2), .rn_memory_sign_ext1(rn_sign1), .rn_memory_sign_ext2(rn_sign2),
        .ex_branch_rob_index(ex_branch_rob_index),
        .ex_address_available1(ex_valid1), .ex_is_load1(ex_is_load1), .ex_is_store1(ex_is_store1), .ex_mem_index1(ex_index1),
        .ex_memory_address1(ex_addr1), .ex_store_data1(ex_data1),
        .ex_address_available2(ex_valid2), .ex_is_load2(ex_is_load2), .ex_is_store2(ex_is_store2), .ex_mem_index2(ex_index2),
        .ex_memory_address2(ex_addr2), .ex_store_data2(ex_data2),
        .commit_is_load1(commit_is_load1), .commit_is_load2(1'b0), .commit_is_store1(commit_is_store1), .commit_is_store2(1'b0),
        .mem_lq_write(mem_lq_write), .mem_lq_index(mem_lq_index), .mem_read_data(mem_read_data), .lsq_ack(lsq_ack),
        .lsq_full(lsq_full), .dis_lq_index1(dis_lq_index1), .dis_lq_index2(dis_lq_index2), .dis_sq_index1(dis_sq_index1), .dis_sq_index2(dis_sq_index2),
        .load1_violation_flush(viol1), .load2_violation_flush(viol2),
        .lsq_mem_write(lsq_mem_write), .lsq_mem_read(lsq_mem_read), .lsq_write_prf(lsq_write_prf),
        .lsq_memory_address(lsq_memory_address), .lsq_mem_write_data(lsq_mem_write_data), .lsq_write_prf_data(lsq_write_prf_data),
        .lsq_lq_index(lsq_lq_index), .lsq_write_prf_address(lsq_write_prf_address), .lsq_rob_index(lsq_rob_index),
        .lsq_mem_size(lsq_mem_size), .lsq_load_address(lsq_load_address), .lsq_load_size(lsq_load_size), .lsq_mem_sign_ext(lsq_mem_sign_ext));

    MEM_Stage mem (.CLK(CLK), .reset(reset), .rob_global_flush(rob_global_flush), .lsq_mem_write(lsq_mem_write), .lsq_mem_read(lsq_mem_read),
        .lsq_memory_address(lsq_memory_address), .lsq_mem_write_data(lsq_mem_write_data), .lsq_mem_size(lsq_mem_size),
        .lsq_load_address(lsq_load_address), .lsq_load_size(lsq_load_size), .lsq_mem_sign_ext(lsq_mem_sign_ext), .lsq_lq_index(lsq_lq_index),
        .mem_lq_write(mem_lq_write), .mem_lq_index(mem_lq_index), .mem_read_data(mem_read_data));

    int errors = 0, checks = 0;
    logic [5:0] rob = 0;                // ROB index given to the next instruction
    // monitors: memory writes in order, loads broadcasted on the CDB
    logic [31:0] writes_addr [$], writes_data [$];
    logic [31:0] result [64];           // by prd
    logic got [64];
    int mem_reads = 0;
    always @(posedge CLK) if (!reset) begin
        if (lsq_mem_write) begin writes_addr.push_back(lsq_memory_address); writes_data.push_back(lsq_mem_write_data); end
        if (lsq_mem_read) mem_reads++;
        if (lsq_ack) begin result[lsq_write_prf_address] = lsq_write_prf_data; got[lsq_write_prf_address] = 1; end
    end

    task automatic check(input string what, input logic [31:0] value, input logic [31:0] expected);
        checks++;
        if (value !== expected) begin errors++; $display("FAIL @%0t %s: %h expected %h", $time, what, value, expected); end
    endtask

    task automatic idle(input int n = 1);
        repeat (n) begin
            @(negedge CLK);
            dis_fire = 0; rn_valid1 = 0; rn_valid2 = 0; ex_valid1 = 0; ex_valid2 = 0; commit_is_load1 = 0; commit_is_store1 = 0; flush = 0; rob_global_flush = 0;
        end
    endtask

    // dispatch one instruction, returns its LQ / SQ entry
    task automatic dispatch(input logic is_load, input logic [1:0] size, input logic sign, input logic [5:0] prd, output logic [4:0] index);
        idle();
        dis_fire = 1; rn_valid1 = 1; rn_memtoreg1 = is_load; rn_memwrite1 = !is_load; rn_is_branch1 = 0;
        rn_memory_type1 = size; rn_sign1 = sign; rn_prd1 = prd; rn_rob_index1 = rob++;
        #0.2 index = is_load ? dis_lq_index1 : {1'b0, dis_sq_index1};
        got[prd] = 0;
    endtask
    task automatic dispatch_branch(output logic [5:0] branch_rob);
        idle();
        dis_fire = 1; rn_valid1 = 1; rn_memtoreg1 = 0; rn_memwrite1 = 0; rn_is_branch1 = 1; rn_rob_index1 = rob; branch_rob = rob++;
    endtask
    // address (and data of a store) computed in EX stage
    task automatic execute(input logic is_load, input logic [4:0] index, input logic [31:0] addr, input logic [31:0] data = 0);
        idle();
        ex_valid1 = 1; ex_is_load1 = is_load; ex_is_store1 = !is_load; ex_index1 = index; ex_addr1 = addr; ex_data1 = data;
    endtask
    task automatic commit(input logic is_load);
        idle();
        commit_is_load1 = is_load; commit_is_store1 = !is_load;
    endtask
    task automatic expect_load(input string what, input logic [5:0] prd, input logic [31:0] expected);
        int t;
        t = 0;
        while (!got[prd] && t < 50) begin idle(); t++; end
        checks++;
        if (!got[prd]) begin errors++; $display("FAIL @%0t %s: load never completed", $time, what); end
        else check(what, result[prd], expected);
    endtask
    // store which is executed and committed right away
    task automatic store_now(input logic [1:0] size, input logic [31:0] addr, input logic [31:0] data);
        logic [4:0] s;
        dispatch(0, size, 0, 0, s); execute(0, s, addr, data); commit(0);
    endtask

    logic [4:0] l0, l1, l2, l3, s0, s1, s2;
    logic [5:0] br;
    int n;

    initial begin
        for (int i = 0; i < 64; i++) got[i] = 0;
        repeat (3) @(negedge CLK);
        reset = 0;

        // ---- 1. memory read
        store_now(2, 32'h10, 32'hA1B2C3D4);
        store_now(2, 32'h14, 32'h80FF7F01);
        idle(4);
        check("stores written to memory", writes_addr.size(), 2);
        dispatch(1, 2, 0, 6'd10, l0); execute(1, l0, 32'h10);
        expect_load("lw from memory", 10, 32'hA1B2C3D4);
        commit(1);
        dispatch(1, 0, 1, 6'd11, l0); execute(1, l0, 32'h17);   expect_load("lb (sign)", 11, 32'hFFFFFF80);  commit(1);
        dispatch(1, 0, 0, 6'd12, l0); execute(1, l0, 32'h16);   expect_load("lbu", 12, 32'h000000FF);        commit(1);
        dispatch(1, 1, 1, 6'd13, l0); execute(1, l0, 32'h16);   expect_load("lh (sign)", 13, 32'hFFFF80FF);  commit(1);
        dispatch(1, 1, 0, 6'd14, l0); execute(1, l0, 32'h14);   expect_load("lhu", 14, 32'h00007F01);        commit(1);

        // ---- 2. forwarding from stores which are not committed
        n = mem_reads;
        dispatch(0, 2, 0, 0, s0); dispatch(0, 2, 0, 0, s1);
        dispatch(1, 2, 0, 6'd20, l0); dispatch(1, 1, 1, 6'd21, l1); dispatch(1, 0, 0, 6'd22, l2);
        execute(0, s0, 32'h20, 32'h11111111);
        execute(0, s1, 32'h20, 32'hCAFE8421);          // younger store to the same word wins
        execute(1, l0, 32'h20); execute(1, l1, 32'h22); execute(1, l2, 32'h21);
        expect_load("forward word", 20, 32'hCAFE8421);
        expect_load("forward half (sign)", 21, 32'hFFFFCAFE);
        expect_load("forward byte", 22, 32'h00000084);
        check("forwarded loads did not read memory", mem_reads, n);
        // ---- 3. nothing is written before commit, then in order
        check("no write before commit", writes_addr.size(), 2);
        commit(0); commit(0); commit(1); commit(1); commit(1);
        idle(4);
        check("writes after commit", writes_addr.size(), 4);
        check("1st write data", writes_data[2], 32'h11111111);
        check("2nd write data", writes_data[3], 32'hCAFE8421);

        // ---- 4. byte store inside the loaded word: load waits for the store to reach memory
        dispatch(0, 0, 0, 0, s0);
        dispatch(1, 2, 0, 6'd30, l0);
        execute(0, s0, 32'h21, 32'h000000EE);
        execute(1, l0, 32'h20);
        idle(8);
        check("load waits for the partial store", {31'b0, got[30]}, 0);
        commit(0);
        expect_load("load after partial store", 30, 32'hCAFEEE21);
        commit(1);

        // ---- 5. memory dependence speculation
        // store address unknown, load reads memory, store then hits the same word -> violation
        dispatch(0, 2, 0, 0, s0);
        dispatch(1, 2, 0, 6'd31, l0);
        dispatch(1, 2, 0, 6'd32, l1);
        execute(1, l0, 32'h10);
        execute(1, l1, 32'h14);
        expect_load("speculative load (stale data)", 31, 32'hA1B2C3D4);
        expect_load("speculative load (other word)", 32, 32'h80FF7F01);
        check("no violation before the store address", {30'b0, viol1, viol2}, 0);
        execute(0, s0, 32'h10, 32'h12345678);
        idle();
        check("violation of the load which read the stored word only", {30'b0, viol1, viol2}, 32'b10);
        // ROB commits the store, then flushes at the violated load: both loads are dropped, the store survives
        commit(0);
        idle(); rob_global_flush = 1;
        idle(4);
        check("committed store written after the flush", writes_data[writes_data.size() - 1], 32'h12345678);
        dispatch(1, 2, 0, 6'd33, l0); execute(1, l0, 32'h10);
        expect_load("load refetched after the flush", 33, 32'h12345678);
        commit(1);

        // ---- 6. branch misprediction: younger load and store are dropped, older ones stay
        dispatch(0, 2, 0, 0, s0);                       // older store
        dispatch_branch(br);
        dispatch(0, 2, 0, 0, s1);                       // wrong path store
        dispatch(1, 2, 0, 6'd40, l0);                   // wrong path load
        execute(0, s1, 32'h30, 32'hBADBAD00);
        execute(1, l0, 32'h30);
        idle(); flush = 1; ex_branch_rob_index = br;
        idle(6);
        check("wrong path load is not broadcasted after the flush", {31'b0, got[40]}, 0);
        execute(0, s0, 32'h30, 32'h600D600D);
        commit(0);
        dispatch(0, 2, 0, 0, s2);                       // reuses the SQ entry of the wrong path store
        check("SQ entry reused after flush", {27'b0, s2}, {27'b0, s1});
        dispatch(1, 2, 0, 6'd41, l1);
        check("LQ entry reused after flush", {27'b0, l1}, {27'b0, l0});
        execute(1, l1, 32'h30);
        idle(8);
        check("load waits for the address of the older store", {31'b0, got[41]}, 1);   // it speculates: reads memory
        execute(0, s2, 32'h34, 32'h0);                  // different word: no violation
        idle();
        check("no violation for a different word", {31'b0, viol1}, 0);
        expect_load("load after flush", 41, 32'h600D600D);
        n = 0;
        foreach (writes_data[i]) if (writes_data[i] == 32'hBADBAD00) n++;
        check("wrong path store never written", n, 0);

        if (errors == 0) $display("PASS tb_lsq (%0d checks)", checks);
        else             $display("FAIL tb_lsq: %0d errors in %0d checks", errors, checks);
        $finish;
    end

    initial begin
        #200000;
        $display("FAIL tb_lsq: timeout");
        $finish;
    end
endmodule
