module LSQ #(
    parameter XLEN = 32,
    parameter LQ_ENTRIES = 32,
    parameter LQ_ADDRESS = $clog2(LQ_ENTRIES),
    parameter SQ_ENTRIES = 16,
    parameter SQ_ADDRESS = $clog2(SQ_ENTRIES),
    parameter PRF_ADDRESS = 6,
    parameter ROB_SIZE = 64,
    parameter ROB_PTR_SIZE = $clog2(ROB_SIZE),
    parameter MEM_INDEX_SIZE = 5
) (
    input logic CLK, reset, dis_fire, rob_global_flush, flush,
    // Dispatch
    input logic rn_valid1, rn_valid2,
    input logic rn_memtoreg1, rn_memtoreg2,
    input logic rn_memwrite1, rn_memwrite2,
    input logic rn_is_branch1, rn_is_branch2,
    input logic [ROB_PTR_SIZE-1:0] rn_rob_index1, rn_rob_index2,
    input logic [PRF_ADDRESS-1:0] rn_prd1, rn_prd2,
    input logic [1:0] rn_memory_type1, rn_memory_type2,
    input logic rn_memory_sign_ext1, rn_memory_sign_ext2,
    // Branch misprediction
    input logic [ROB_PTR_SIZE-1:0] ex_branch_rob_index,
    // Address (and store data) from EX stage
    input logic ex_address_available1, ex_is_load1, ex_is_store1,
    input logic [MEM_INDEX_SIZE-1:0] ex_mem_index1,
    input logic [XLEN-1:0] ex_memory_address1, ex_store_data1,
    input logic ex_address_available2, ex_is_load2, ex_is_store2,
    input logic [MEM_INDEX_SIZE-1:0] ex_mem_index2,
    input logic [XLEN-1:0] ex_memory_address2, ex_store_data2,
    // Commit
    input logic commit_is_load1, commit_is_load2,
    input logic commit_is_store1, commit_is_store2,
    // Data memory response
    input logic mem_lq_write,
    input logic [LQ_ADDRESS-1:0] mem_lq_index,
    input logic [XLEN-1:0] mem_read_data,
    input logic lsq_ack,

    output logic lsq_full,
    //LQ/SQ entries given to the instructions being dispatched
    output logic [LQ_ADDRESS-1:0] dis_lq_index1, dis_lq_index2,
    output logic [SQ_ADDRESS-1:0] dis_sq_index1, dis_sq_index2,
    output logic load1_violation_flush, load2_violation_flush,
    output logic lsq_mem_write, lsq_mem_read, lsq_write_prf,
    output logic [XLEN-1:0] lsq_memory_address, lsq_mem_write_data, lsq_write_prf_data,
    output logic [LQ_ADDRESS-1:0] lsq_lq_index,
    output logic [PRF_ADDRESS-1:0] lsq_write_prf_address,
    output logic [ROB_PTR_SIZE-1:0] lsq_rob_index,
    output logic [1:0] lsq_mem_size,
    output logic lsq_mem_sign_ext
);

    typedef struct packed {
        logic speculative_execution;        // executed while the address of an older store was unknown
        logic violated;                     // an older store turned out to write the bytes this load already read
        logic [ROB_PTR_SIZE-1:0] age;       // ROB index
        logic [SQ_ADDRESS:0] sq_ptr;        // SQ tail at dispatch: stores before it are older than this load
        logic [XLEN-1:0] address;
        logic address_available;
        logic fired;                        // data forwarded or memory read sent
        logic [PRF_ADDRESS-1:0] prd;
        logic [XLEN-1:0] prd_data;
        logic prd_available;                // data waiting to be broadcasted on the CDB
        logic [1:0] size;
        logic sign_extend;
    } lq_organization;

    typedef struct packed {
        logic [LQ_ADDRESS:0] lq_ptr;        // LQ tail at dispatch: loads from it onwards are younger than this store
        logic [XLEN-1:0] address;
        logic address_available;            // address and data arrive together from EX stage
        logic [XLEN-1:0] data;
        logic [1:0] size;
    } sq_organization;

    lq_organization LQ [LQ_ENTRIES-1:0];
    sq_organization SQ [SQ_ENTRIES-1:0];

    // SQ: head = oldest store not written to memory yet, commit = oldest store not committed yet
    logic [LQ_ADDRESS:0] lq_head, lq_tail, lq_next_head;
    logic [SQ_ADDRESS:0] sq_head, sq_commit, sq_tail, sq_next_commit;
    logic [LQ_ADDRESS:0] updated_lq_tail;
    logic [SQ_ADDRESS:0] updated_sq_tail;
    logic lq_full, sq_full;
    logic alloc_load1, alloc_load2, alloc_store1, alloc_store2;

    logic [LQ_ADDRESS:0] lq_count;
    logic [SQ_ADDRESS:0] sq_count;
    assign lq_count = lq_tail - lq_head;
    assign sq_count = sq_tail - sq_head;

    logic [LQ_ADDRESS:0] lq_tail_snapshot [ROB_SIZE-1:0];
    logic [SQ_ADDRESS:0] sq_tail_snapshot [ROB_SIZE-1:0];

    assign lq_full = (lq_count > (LQ_ADDRESS+1)'(LQ_ENTRIES - 2));
    assign sq_full = (sq_count > (SQ_ADDRESS+1)'(SQ_ENTRIES - 2));
    assign lsq_full = lq_full || sq_full;

    assign alloc_load1  = rn_valid1 && rn_memtoreg1;
    assign alloc_load2  = rn_valid2 && rn_memtoreg2;
    assign alloc_store1 = rn_valid1 && rn_memwrite1;
    assign alloc_store2 = rn_valid2 && rn_memwrite2;

    assign dis_lq_index1 = lq_tail[LQ_ADDRESS-1:0];
    assign dis_lq_index2 = LQ_ADDRESS'(lq_tail[LQ_ADDRESS-1:0] + LQ_ADDRESS'(alloc_load1));
    assign dis_sq_index1 = sq_tail[SQ_ADDRESS-1:0];
    assign dis_sq_index2 = SQ_ADDRESS'(sq_tail[SQ_ADDRESS-1:0] + SQ_ADDRESS'(alloc_store1));

    always_comb begin
        updated_lq_tail = lq_tail + (LQ_ADDRESS+1)'(alloc_load1) + (LQ_ADDRESS+1)'(alloc_load2);
        updated_sq_tail = sq_tail + (SQ_ADDRESS+1)'(alloc_store1) + (SQ_ADDRESS+1)'(alloc_store2);

        lq_next_head   = lq_head + (LQ_ADDRESS+1)'(commit_is_load1) + (LQ_ADDRESS+1)'(commit_is_load2);
        sq_next_commit = sq_commit + (SQ_ADDRESS+1)'(commit_is_store1) + (SQ_ADDRESS+1)'(commit_is_store2);
    end

    // bytes of the word accessed by a load/store
    function automatic logic [3:0] byte_mask(input logic [1:0] size, input logic [1:0] offset);
        case (size)
            2'b00:   return 4'b0001 << offset;
            2'b01:   return 4'b0011 << offset;
            default: return 4'b1111;
        endcase
    endfunction

    function automatic logic overlap(input logic [XLEN-1:0] address_a, input logic [1:0] size_a,
                                     input logic [XLEN-1:0] address_b, input logic [1:0] size_b);
        return (address_a[XLEN-1:2] == address_b[XLEN-1:2]) &&
               ((byte_mask(size_a, address_a[1:0]) & byte_mask(size_b, address_b[1:0])) != 4'b0);
    endfunction

    function automatic logic [XLEN-1:0] extend(input logic [XLEN-1:0] data, input logic [1:0] size, input logic sign_extend);
        case (size)
            2'b00:   return (sign_extend) ? {{24{data[7]}}, data[7:0]}   : {24'b0, data[7:0]};
            2'b01:   return (sign_extend) ? {{16{data[15]}}, data[15:0]} : {16'b0, data[15:0]};
            default: return data;
        endcase
    endfunction

    // ------------------------------------------------------------------------------------
    // Load execution: every cycle the oldest load which knows its address but has no data
    // yet searches the older stores (store-to-load forwarding CAM search)
    // ------------------------------------------------------------------------------------
    logic fire_found, fire_hit, fire_cover, fire_speculative, fire_forward, fire_read, store_arriving;
    logic [LQ_ADDRESS-1:0] fire_index;
    logic [SQ_ADDRESS:0] fire_limit;
    logic [XLEN-1:0] fire_store_word, fire_forward_data;

    assign store_arriving = (ex_address_available1 && ex_is_store1) || (ex_address_available2 && ex_is_store2);

    always_comb begin
        logic [LQ_ADDRESS-1:0] lq_idx;
        logic [SQ_ADDRESS-1:0] sq_idx;
        logic [3:0] load_mask, store_mask;
        lq_idx = '0;
        sq_idx = '0;
        load_mask = '0;
        store_mask = '0;

        fire_found = 0;
        fire_index = '0;
        for (int offset = 0; offset < LQ_ENTRIES; offset++) begin
            if (offset < lq_count) begin
                lq_idx = LQ_ADDRESS'(lq_head[LQ_ADDRESS-1:0] + LQ_ADDRESS'(offset));
                if (LQ[lq_idx].address_available && !LQ[lq_idx].fired && !fire_found) begin
                    fire_found = 1;
                    fire_index = lq_idx;
                end
            end
        end

        // stores from sq_head up to the SQ tail seen by the load at dispatch are older than the load
        fire_limit       = LQ[fire_index].sq_ptr - sq_head;
        load_mask        = byte_mask(LQ[fire_index].size, LQ[fire_index].address[1:0]);
        fire_hit         = 0;
        fire_cover       = 0;
        fire_speculative = 0;
        fire_store_word  = '0;
        // oldest to youngest, so the youngest matching store wins
        for (int offset = 0; offset < SQ_ENTRIES; offset++) begin
            if (offset < fire_limit) begin
                sq_idx = SQ_ADDRESS'(sq_head[SQ_ADDRESS-1:0] + SQ_ADDRESS'(offset));
                if (!SQ[sq_idx].address_available) begin
                    // this store may or may not write the bytes of the load
                    fire_speculative = 1;
                end
                else if (overlap(SQ[sq_idx].address, SQ[sq_idx].size, LQ[fire_index].address, LQ[fire_index].size)) begin
                    store_mask       = byte_mask(SQ[sq_idx].size, SQ[sq_idx].address[1:0]);
                    fire_hit         = 1;
                    fire_cover       = ((store_mask & load_mask) == load_mask);
                    fire_store_word  = SQ[sq_idx].data << {SQ[sq_idx].address[1:0], 3'b000};
                    fire_speculative = 0;
                end
            end
        end

        fire_forward_data = extend(fire_store_word >> {LQ[fire_index].address[1:0], 3'b000}, LQ[fire_index].size, LQ[fire_index].sign_extend);
        // nothing is fired in the cycle a store address arrives, so that the violation check below never misses a load
        fire_forward = fire_found && !store_arriving && fire_hit && fire_cover;
        // a store which writes only a part of the loaded bytes cannot be forwarded: wait until it is in memory
        fire_read    = fire_found && !store_arriving && !fire_hit && !lsq_mem_write;
    end

    // Memory Arbiter: committed stores are written in order, loads use the port when it is free
    always_comb begin
        lsq_mem_write = 0; lsq_mem_read = 0; lsq_lq_index = '0;
        lsq_memory_address = '0; lsq_mem_write_data = '0;
        lsq_mem_size = '0; lsq_mem_sign_ext = '0;

        if (sq_head != sq_commit) begin
            lsq_memory_address = SQ[sq_head[SQ_ADDRESS-1:0]].address;
            lsq_mem_write_data = SQ[sq_head[SQ_ADDRESS-1:0]].data;
            lsq_mem_size       = SQ[sq_head[SQ_ADDRESS-1:0]].size;
            lsq_mem_write = 1;
        end
        else if (fire_found && !store_arriving && !fire_hit) begin
            lsq_memory_address = LQ[fire_index].address;
            lsq_lq_index       = fire_index;
            lsq_mem_size       = LQ[fire_index].size;
            lsq_mem_sign_ext   = LQ[fire_index].sign_extend;
            lsq_mem_read = 1;
        end
    end

    // PRF Write Arbiter: oldest load whose data is ready goes to the CDB
    logic [LQ_ADDRESS-1:0] broadcast_index;
    always_comb begin
        logic [LQ_ADDRESS-1:0] lq_idx2;
        lq_idx2 = '0;

        lsq_write_prf = 0; lsq_write_prf_address = '0; lsq_write_prf_data = '0;
        lsq_rob_index = '0; broadcast_index = '0;
        for (int offset = 0; offset < LQ_ENTRIES; offset++) begin
            if (offset < lq_count) begin
                lq_idx2 = LQ_ADDRESS'(lq_head[LQ_ADDRESS-1:0] + LQ_ADDRESS'(offset));
                if (LQ[lq_idx2].prd_available && !lsq_write_prf) begin
                    lsq_write_prf = 1;
                    broadcast_index = lq_idx2;
                    lsq_write_prf_address = LQ[lq_idx2].prd;
                    lsq_write_prf_data = LQ[lq_idx2].prd_data;
                    lsq_rob_index = LQ[lq_idx2].age;
                end
            end
        end
    end

    // loads at the head of the ROB are the oldest loads of the LQ
    always_comb begin
        load1_violation_flush = (lq_count > 0) ? LQ[lq_head[LQ_ADDRESS-1:0]].violated : 1'b0;
        load2_violation_flush = (lq_count > 1) ? LQ[LQ_ADDRESS'(lq_head[LQ_ADDRESS-1:0] + LQ_ADDRESS'(1))].violated : 1'b0;
    end

    // a store address arrived: loads younger than the store which already executed speculatively
    // and read the same bytes have the wrong data
    task automatic check_violation(input logic [SQ_ADDRESS-1:0] sq_index, input logic [XLEN-1:0] address);
        logic [LQ_ADDRESS-1:0] idx;
        logic [LQ_ADDRESS:0] first_younger;
        first_younger = SQ[sq_index].lq_ptr - lq_head;
        for (int offset = 0; offset < LQ_ENTRIES; offset++) begin
            if ((offset < lq_count) && (offset >= first_younger)) begin
                idx = LQ_ADDRESS'(lq_head[LQ_ADDRESS-1:0] + LQ_ADDRESS'(offset));
                if (LQ[idx].fired && LQ[idx].speculative_execution &&
                    overlap(LQ[idx].address, LQ[idx].size, address, SQ[sq_index].size)) begin
                    LQ[idx].violated <= 1;
                end
            end
        end
    endtask

    always_ff @(posedge CLK) begin
        if (reset) begin
            lq_tail <= 0; sq_tail <= 0;
            lq_head <= 0; sq_head <= 0;
            sq_commit <= 0;
        end
        else begin
            // Commit
            lq_head   <= lq_next_head;
            sq_commit <= sq_next_commit;

            // committed store written to memory
            if (lsq_mem_write) begin
                sq_head <= sq_head + 1;
            end

            // Allocation / recovery of the tails
            if (rob_global_flush) begin
                // committed stores which are not in memory yet must survive
                lq_tail <= lq_next_head;
                sq_tail <= sq_next_commit;
            end
            else if (flush) begin
                lq_tail <= lq_tail_snapshot[ex_branch_rob_index];
                sq_tail <= sq_tail_snapshot[ex_branch_rob_index];
            end
            else if (dis_fire) begin
                lq_tail <= updated_lq_tail;
                sq_tail <= updated_sq_tail;
                // tails right after the branch, restored if it is mispredicted
                if (rn_is_branch1 && rn_valid1) begin
                    lq_tail_snapshot[rn_rob_index1] <= lq_tail + (LQ_ADDRESS+1)'(alloc_load1);
                    sq_tail_snapshot[rn_rob_index1] <= sq_tail + (SQ_ADDRESS+1)'(alloc_store1);
                end
                if (rn_is_branch2 && rn_valid2) begin
                    lq_tail_snapshot[rn_rob_index2] <= updated_lq_tail;
                    sq_tail_snapshot[rn_rob_index2] <= updated_sq_tail;
                end
            end

            // Data memory response
            if (mem_lq_write) begin
                LQ[mem_lq_index].prd_data <= mem_read_data;
                LQ[mem_lq_index].prd_available <= 1;
            end

            // Load execution
            if (fire_forward) begin
                LQ[fire_index].fired <= 1;
                LQ[fire_index].speculative_execution <= fire_speculative;
                LQ[fire_index].prd_data <= fire_forward_data;
                LQ[fire_index].prd_available <= 1;
            end
            else if (fire_read) begin
                LQ[fire_index].fired <= 1;
                LQ[fire_index].speculative_execution <= fire_speculative;
            end

            // CDB took the load data
            if (lsq_ack) begin
                LQ[broadcast_index].prd_available <= 0;
            end

            // Address from EX stage
            if (ex_address_available1 && ex_is_load1) begin
                LQ[ex_mem_index1[LQ_ADDRESS-1:0]].address_available <= 1;
                LQ[ex_mem_index1[LQ_ADDRESS-1:0]].address <= ex_memory_address1;
            end
            if (ex_address_available2 && ex_is_load2) begin
                LQ[ex_mem_index2[LQ_ADDRESS-1:0]].address_available <= 1;
                LQ[ex_mem_index2[LQ_ADDRESS-1:0]].address <= ex_memory_address2;
            end
            if (ex_address_available1 && ex_is_store1) begin
                SQ[ex_mem_index1[SQ_ADDRESS-1:0]].address_available <= 1;
                SQ[ex_mem_index1[SQ_ADDRESS-1:0]].address <= ex_memory_address1;
                SQ[ex_mem_index1[SQ_ADDRESS-1:0]].data <= ex_store_data1;
                check_violation(ex_mem_index1[SQ_ADDRESS-1:0], ex_memory_address1);
            end
            if (ex_address_available2 && ex_is_store2) begin
                SQ[ex_mem_index2[SQ_ADDRESS-1:0]].address_available <= 1;
                SQ[ex_mem_index2[SQ_ADDRESS-1:0]].address <= ex_memory_address2;
                SQ[ex_mem_index2[SQ_ADDRESS-1:0]].data <= ex_store_data2;
                check_violation(ex_mem_index2[SQ_ADDRESS-1:0], ex_memory_address2);
            end

            // Allocation (written last: a new entry always starts clean)
            if (dis_fire && !flush && !rob_global_flush) begin
                if (alloc_load1) begin
                    LQ[dis_lq_index1].speculative_execution <= 0;
                    LQ[dis_lq_index1].violated <= 0;
                    LQ[dis_lq_index1].age <= rn_rob_index1;
                    LQ[dis_lq_index1].sq_ptr <= sq_tail;
                    LQ[dis_lq_index1].address_available <= 0;
                    LQ[dis_lq_index1].fired <= 0;
                    LQ[dis_lq_index1].prd <= rn_prd1;
                    LQ[dis_lq_index1].prd_available <= 0;
                    LQ[dis_lq_index1].size <= rn_memory_type1;
                    LQ[dis_lq_index1].sign_extend <= rn_memory_sign_ext1;
                end
                if (alloc_load2) begin
                    LQ[dis_lq_index2].speculative_execution <= 0;
                    LQ[dis_lq_index2].violated <= 0;
                    LQ[dis_lq_index2].age <= rn_rob_index2;
                    // a store in the 1st instruction of the bundle is older than this load
                    LQ[dis_lq_index2].sq_ptr <= sq_tail + (SQ_ADDRESS+1)'(alloc_store1);
                    LQ[dis_lq_index2].address_available <= 0;
                    LQ[dis_lq_index2].fired <= 0;
                    LQ[dis_lq_index2].prd <= rn_prd2;
                    LQ[dis_lq_index2].prd_available <= 0;
                    LQ[dis_lq_index2].size <= rn_memory_type2;
                    LQ[dis_lq_index2].sign_extend <= rn_memory_sign_ext2;
                end
                if (alloc_store1) begin
                    SQ[dis_sq_index1].lq_ptr <= lq_tail;
                    SQ[dis_sq_index1].address_available <= 0;
                    SQ[dis_sq_index1].size <= rn_memory_type1;
                end
                if (alloc_store2) begin
                    // a load in the 1st instruction of the bundle is older than this store
                    SQ[dis_sq_index2].lq_ptr <= lq_tail + (LQ_ADDRESS+1)'(alloc_load1);
                    SQ[dis_sq_index2].address_available <= 0;
                    SQ[dis_sq_index2].size <= rn_memory_type2;
                end
            end
        end
    end
endmodule
