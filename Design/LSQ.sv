module LSQ #(
    parameter XLEN = 32,
    parameter LQ_ENTRIES = 32,
    parameter LQ_ADDRESS = $clog2(LQ_ENTRIES),
    parameter SQ_ENTRIES = 16,
    parameter SQ_ADDRESS = $clog2(SQ_ENTRIES),
    parameter PRF_ADDRESS = 6,
    parameter ROB_SIZE = 64,
    parameter ROB_PTR_SIZE = $clog2(ROB_SIZE)
) (
    input logic CLK, reset, stall_frontend, rob_global_flush, flush,
    input logic rn_valid1, rn_valid2,
    input logic rn_memtoreg1, rn_memtoreg2,
    input logic rn_memwrite1, rn_memwrite2,
    input logic rn_is_branch1, rn_is_branch2,
    input logic [ROB_PTR_SIZE-1:0] rn_rob_index1, rn_rob_index2,
    input logic [PRF_ADDRESS-1:0] rn_prd1, rn_prd2,
    input logic [PRF_ADDRESS-1:0] rn_prs2_1, rn_prs2_2,
    input logic rn_prs2_busy1, rn_prs2_busy2,
    input logic [1:0] rn_memory_type1, rn_memory_type2,
    input logic rn_memory_sign_ext1, rn_memory_sign_ext2,
    input logic [ROB_PTR_SIZE:0] current_rob_index,
    input logic [ROB_PTR_SIZE-1:0] ex_branch_rob_index,
    input logic ex_address_available1, ex_is_load1,
    input logic [LQ_ADDRESS-1:0] ex_lq_index1,
    input logic [XLEN-1:0] ex_memory_address1,
    input logic ex_address_available2, ex_is_load2,
    input logic [LQ_ADDRESS-1:0] ex_lq_index2,
    input logic [XLEN-1:0] ex_memory_address2,
    
    input logic ex_mem_address1_available, ex_is_load1, ex_is_store1,
    input logic [XLEN-1:0] ex_mem_address1,
    input logic [LQ_ADDRESS-1:0] ex_lq_index1,
    input logic [SQ_ADDRESS-1:0] ex_sq_index1,
    input logic ex_mem_address2_available, ex_is_load2, ex_is_store2,
    input logic [XLEN-1:0] ex_mem_address2,
    input logic [LQ_ADDRESS-1:0] ex_lq_index2,
    input logic [SQ_ADDRESS-1:0] ex_sq_index2,
    
    input logic cdb_result1_available, cdb_result2_available,
    input logic [PRF_ADDRESS-1:0] cdb_tag1_broadcast, cdb_tag2_broadcast,
    input logic [XLEN-1:0] cdb_result1_broadcast, cdb_result2_broadcast,
    input logic commit_is_load1, commit_is_load2,
    input logic commit_is_store1, commit_is_store2,
    input logic mem_lq_write,
    input logic [LQ_ADDRESS-1:0] mem_lq_index,
    input logic [XLEN-1:0] mem_read_data,
    // Outputs
    output logic lsq_full,
    output logic load1_violation_flush, load2_violation_flush,
    output logic lsq_mem_write, lsq_mem_read, lsq_write_prf,
    output logic [XLEN-1:0] lsq_memory_address, lsq_mem_write_data, lsq_write_prf_data,
    output logic [LQ_ADDRESS-1:0] lsq_lq_index,
    output logic [PRF_ADDRESS-1:0] lsq_write_prf_address,
    output logic [1:0] lsq_mem_size,
    output logic lsq_mem_sign_ext
);
    
    typedef struct packed {
        logic speculative_execution;
        logic violated;
        logic [ROB_PTR_SIZE:0] age;
        logic [XLEN-1:0] address;
        logic address_available;
        logic [PRF_ADDRESS-1:0] prd;
        logic [XLEN-1:0] prd_data;
        logic prd_available;
        logic [1:0] size;
        logic sign_extend;
        logic forwarding_stalled;
        logic [SQ_ADDRESS-1:0] forwarding_sq_index;
        logic mem_read;
    } lq_organization;
     
    typedef struct packed {
        logic committed;
        logic [ROB_PTR_SIZE:0] age;
        logic [XLEN-1:0] address;
        logic address_available;
        logic [PRF_ADDRESS-1:0] prs2;
        logic [XLEN-1:0] prs2_data;
        logic prs2_available;
        logic [1:0] size;
    } sq_organization;
     
    lq_organization LQ [LQ_ENTRIES-1:0];
    sq_organization SQ [SQ_ENTRIES-1:0];    

    logic [LQ_ADDRESS:0] lq_head, lq_tail;
    logic [SQ_ADDRESS:0] sq_head, sq_tail;
    logic [LQ_ADDRESS:0] updated_lq_tail;
    logic [SQ_ADDRESS:0] updated_sq_tail;
    logic lq_full, sq_full;

    logic [LQ_ADDRESS:0] lq_count;
    logic [SQ_ADDRESS:0] sq_count;
    assign lq_count = lq_tail - lq_head;
    assign sq_count = sq_tail - sq_head;

    logic [LQ_ADDRESS:0] lq_tail_snapshot [ROB_SIZE-1:0];
    logic [SQ_ADDRESS:0] sq_tail_snapshot [ROB_SIZE-1:0];
    
    //  Safe full logic preventing superscalar overshoot
    assign lq_full = (LQ_ENTRIES - lq_count) <= 2;
    assign sq_full = (SQ_ENTRIES - sq_count) <= 2;
    assign lsq_full = lq_full || sq_full;

    always_comb begin 
        updated_lq_tail = lq_tail + (LQ_ADDRESS+1)'(rn_memtoreg1 && rn_valid1) + 
                                    (LQ_ADDRESS+1)'(rn_memtoreg2 && rn_valid2);
        
        updated_sq_tail = sq_tail + (SQ_ADDRESS+1)'(rn_memwrite1 && rn_valid1) + 
                                    (SQ_ADDRESS+1)'(rn_memwrite2 && rn_valid2);
    end
    
    logic [SQ_ADDRESS-1:0] aliased_sq_address1, aliased_sq_address2;
    logic aliasing1_occured, aliasing2_occured;
    logic address1_not_available, address2_not_available;
    
    // STLF CAM Search
    always_comb begin
        aliasing1_occured = 0;
        address1_not_available = 0;
        aliased_sq_address1 = '0;
        
        if (ex_address_available1 && ex_is_load1) begin
            for (int offset = 0; offset < SQ_ENTRIES; offset++) begin
                if (offset < sq_count) begin
                    logic [SQ_ADDRESS-1:0] idx;
                    idx = SQ_ADDRESS'(sq_head[SQ_ADDRESS-1:0] + offset);
                    
                    if (SQ[idx].age < LQ[ex_lq_index1].age) begin
                        if (SQ[idx].address_available) begin 
                            if (SQ[idx].address == ex_memory_address1) begin
                                if (SQ[idx].size == LQ[ex_lq_index1].size) begin
                                    aliased_sq_address1 = idx; 
                                    aliasing1_occured = 1; 
                                    address1_not_available = 0; 
                                end else begin
                                    // Partial overlap: Cannot forward, must stall!
                                    address1_not_available = 1; 
                                    aliasing1_occured = 0;
                                end
                            end
                        end
                        else begin
                            // Older store address unknown: Must stall!
                            address1_not_available = 1;
                            aliasing1_occured = 0;
                        end
                    end
                end
            end
        end
        
        aliasing2_occured = 0;
        address2_not_available = 0;
        aliased_sq_address2 = '0;

        if (ex_address_available2 && ex_is_load2) begin
            for (int offset = 0; offset < SQ_ENTRIES; offset++) begin
                if (offset < sq_count) begin
                    logic [SQ_ADDRESS-1:0] idx;
                    idx = SQ_ADDRESS'(sq_head[SQ_ADDRESS-1:0] + offset);
                    
                    if (SQ[idx].age < LQ[ex_lq_index2].age) begin
                        if (SQ[idx].address_available) begin 
                            if (SQ[idx].address == ex_memory_address2) begin
                                if (SQ[idx].size == LQ[ex_lq_index2].size) begin
                                    aliased_sq_address2 = idx;
                                    aliasing2_occured = 1;
                                    address2_not_available = 0;
                                end else begin
                                    // Partial overlap: Cannot forward, must stall!
                                    address2_not_available = 1;
                                    aliasing2_occured = 0;
                                end
                            end
                        end
                        else begin
                            address2_not_available = 1;
                            aliasing2_occured = 0;
                        end
                    end
                end
            end
        end
    end
  
    // Memory Arbiter
    always_comb begin 
        lsq_mem_write = 0;
        lsq_memory_address = '0;
        lsq_mem_write_data = '0;
        lsq_mem_size = '0;
        lsq_mem_sign_ext = '0;
        
        if (sq_count > 0 && SQ[sq_head[SQ_ADDRESS-1:0]].committed && 
            SQ[sq_head[SQ_ADDRESS-1:0]].address_available && SQ[sq_head[SQ_ADDRESS-1:0]].prs2_available) begin
            lsq_memory_address = SQ[sq_head[SQ_ADDRESS-1:0]].address;
            lsq_mem_write_data = SQ[sq_head[SQ_ADDRESS-1:0]].prs2_data;
            lsq_mem_size       = SQ[sq_head[SQ_ADDRESS-1:0]].size;
            lsq_mem_write = 1;
        end

        lsq_mem_read = 0;
        lsq_lq_index = '0;
        for (int offset = 0; offset < LQ_ENTRIES; offset++) begin
            if (offset < lq_count) begin
                logic [LQ_ADDRESS-1:0] idx;
                idx = LQ_ADDRESS'(lq_head[LQ_ADDRESS-1:0] + offset);
                
                if (LQ[idx].mem_read && !lsq_mem_read && !lsq_mem_write) begin
                    lsq_memory_address = LQ[idx].address;
                    lsq_lq_index = idx;
                    lsq_mem_size = LQ[idx].size;
                    lsq_mem_sign_ext = LQ[idx].sign_extend;
                    lsq_mem_read = 1; 
                end
            end
        end
    end
    
    // PRF Write Arbiter
    always_comb begin
        lsq_write_prf = 0;
        lsq_write_prf_address = '0;
        lsq_write_prf_data = '0;
        for (int offset = 0; offset < LQ_ENTRIES; offset++) begin
            if (offset < lq_count) begin
                logic [LQ_ADDRESS-1:0] idx;
                idx = LQ_ADDRESS'(lq_head[LQ_ADDRESS-1:0] + offset);
                
                if (LQ[idx].prd_available && !lsq_write_prf) begin
                    lsq_write_prf = 1;
                    lsq_write_prf_address = LQ[idx].prd;
                    lsq_write_prf_data = LQ[idx].prd_data;
                end
            end
        end
    end
    
    // Memory Violation Checking
    always_comb begin
        load1_violation_flush = (lq_count > 0) ? LQ[lq_head[LQ_ADDRESS-1:0]].violated : 1'b0;
        load2_violation_flush = (lq_count > 1) ? LQ[LQ_ADDRESS'(lq_head[LQ_ADDRESS-1:0] + 1)].violated : 1'b0;
    end

    // SEQUENTIAL BLOCK
    always_ff @(posedge CLK) begin
        if (reset) begin
            lq_tail <= 0; sq_tail <= 0; 
            lq_head <= 0; sq_head <= 0;
        end
        else if (rob_global_flush) begin
            lq_tail <= lq_head;
            sq_tail <= sq_head;
        end
        else begin
            // 1. COMMITS (Head Pointers) - Happens regardless of flushes
            lq_head <= lq_head + (LQ_ADDRESS+1)'(commit_is_load1) + (LQ_ADDRESS+1)'(commit_is_load2);
            sq_head <= sq_head + (SQ_ADDRESS+1)'(commit_is_store1) + (SQ_ADDRESS+1)'(commit_is_store2);

            if (commit_is_store1) SQ[sq_head[SQ_ADDRESS-1:0]].committed <= 1;
            if (commit_is_store2) SQ[SQ_ADDRESS'(sq_head[SQ_ADDRESS-1:0] + 1)].committed <= 1;

            // 2. ALLOCATE / FLUSH (Tail Pointers)
            if (flush) begin
                lq_tail <= lq_tail_snapshot[ex_branch_rob_index];
                sq_tail <= sq_tail_snapshot[ex_branch_rob_index];
            end
            else if (!stall_frontend) begin
                lq_tail <= updated_lq_tail;
                sq_tail <= updated_sq_tail;
                
                if (rn_is_branch1 && rn_valid1) begin
                    lq_tail_snapshot[rn_rob_index1] <= lq_tail + (LQ_ADDRESS+1)'(rn_memtoreg1);
                    sq_tail_snapshot[rn_rob_index1] <= sq_tail + (SQ_ADDRESS+1)'(rn_memwrite1);
                end
                if (rn_is_branch2 && rn_valid2) begin
                    lq_tail_snapshot[rn_rob_index2] <= updated_lq_tail;
                    sq_tail_snapshot[rn_rob_index2] <= updated_sq_tail;
                end
            end

            // Load Allocation
            if (rn_memtoreg1 && rn_valid1) begin
                LQ[lq_tail[LQ_ADDRESS-1:0]].speculative_execution <= 0;
                LQ[lq_tail[LQ_ADDRESS-1:0]].age <= current_rob_index;
                LQ[lq_tail[LQ_ADDRESS-1:0]].address_available <= 0;
                LQ[lq_tail[LQ_ADDRESS-1:0]].prd <= rn_prd1;
                LQ[lq_tail[LQ_ADDRESS-1:0]].size <= rn_memory_type1;
                LQ[lq_tail[LQ_ADDRESS-1:0]].sign_extend <= rn_memory_sign_ext1;
                LQ[lq_tail[LQ_ADDRESS-1:0]].prd_available <= 0;
                LQ[lq_tail[LQ_ADDRESS-1:0]].violated <= 0;
                LQ[lq_tail[LQ_ADDRESS-1:0]].mem_read <= 0;
                LQ[lq_tail[LQ_ADDRESS-1:0]].forwarding_stalled <= 0;
            end
            if (rn_memtoreg2 && rn_valid2) begin
                logic [LQ_ADDRESS-1:0] t2 = lq_tail[LQ_ADDRESS-1:0] + LQ_ADDRESS'(rn_memtoreg1);
                LQ[t2].speculative_execution <= 0;
                LQ[t2].age <= current_rob_index + 1;
                LQ[t2].address_available <= 0;
                LQ[t2].prd <= rn_prd2;
                LQ[t2].size <= rn_memory_type2;
                LQ[t2].sign_extend <= rn_memory_sign_ext2;
                LQ[t2].prd_available <= 0;
                LQ[t2].violated <= 0;
                LQ[t2].mem_read <= 0;
                LQ[t2].forwarding_stalled <= 0;
            end
            
            // Store Allocation
            if (rn_memwrite1 && rn_valid1) begin
                SQ[sq_tail[SQ_ADDRESS-1:0]].age <= current_rob_index;
                SQ[sq_tail[SQ_ADDRESS-1:0]].committed <= 0;
                SQ[sq_tail[SQ_ADDRESS-1:0]].address_available <= 0;
                SQ[sq_tail[SQ_ADDRESS-1:0]].prs2 <= rn_prs2_1;
                SQ[sq_tail[SQ_ADDRESS-1:0]].prs2_available <= ~rn_prs2_busy1;
                SQ[sq_tail[SQ_ADDRESS-1:0]].size <= rn_memory_type1;
            end
            if (rn_memwrite2 && rn_valid2) begin
                logic [SQ_ADDRESS-1:0] st2 = sq_tail[SQ_ADDRESS-1:0] + SQ_ADDRESS'(rn_memwrite1);
                SQ[st2].age <= current_rob_index + 1;
                SQ[st2].committed <= 0;
                SQ[st2].address_available <= 0;
                SQ[st2].prs2 <= rn_prs2_2;
                SQ[st2].prs2_available <= ~rn_prs2_busy2;
                SQ[st2].size <= rn_memory_type2;
            end

            // 3. STLF APPLYING (Address Calculation Return)
            if (ex_address_available1 && ex_is_load1) begin
                if(aliasing1_occured) begin
                    if (SQ[aliased_sq_address1].prs2_available) begin
                        LQ[ex_lq_index1].prd_available <= 1;
                        
                        // Inline STLF Format
                        if (LQ[ex_lq_index1].size == 2'b00) begin // Byte
                            LQ[ex_lq_index1].prd_data <= LQ[ex_lq_index1].sign_extend ? 
                                { {24{SQ[aliased_sq_address1].prs2_data[7]}}, SQ[aliased_sq_address1].prs2_data[7:0] } : 
                                { 24'b0, SQ[aliased_sq_address1].prs2_data[7:0] };
                        end 
                        else if (LQ[ex_lq_index1].size == 2'b01) begin // Half
                            LQ[ex_lq_index1].prd_data <= LQ[ex_lq_index1].sign_extend ? 
                                { {16{SQ[aliased_sq_address1].prs2_data[15]}}, SQ[aliased_sq_address1].prs2_data[15:0] } : 
                                { 16'b0, SQ[aliased_sq_address1].prs2_data[15:0] };
                        end 
                        else begin // Word
                            LQ[ex_lq_index1].prd_data <= SQ[aliased_sq_address1].prs2_data;
                        end
                    end else begin
                        LQ[ex_lq_index1].forwarding_stalled <= 1;
                        LQ[ex_lq_index1].forwarding_sq_index <= aliased_sq_address1;
                    end
                end else if (address1_not_available) begin
                    LQ[ex_lq_index1].mem_read <= 1;
                    LQ[ex_lq_index1].speculative_execution <= 1;
                end else begin
                    LQ[ex_lq_index1].mem_read <= 1;
                    LQ[ex_lq_index1].speculative_execution <= 0;
                end
            end

            if (ex_address_available2 && ex_is_load2) begin
                if (aliasing2_occured) begin
                    if (SQ[aliased_sq_address2].prs2_available) begin
                        LQ[ex_lq_index2].prd_available <= 1;
                        
                        // Inline STLF Format
                        if (LQ[ex_lq_index2].size == 2'b00) begin 
                            LQ[ex_lq_index2].prd_data <= LQ[ex_lq_index2].sign_extend ? 
                                { {24{SQ[aliased_sq_address2].prs2_data[7]}}, SQ[aliased_sq_address2].prs2_data[7:0] } : 
                                { 24'b0, SQ[aliased_sq_address2].prs2_data[7:0] };
                        end 
                        else if (LQ[ex_lq_index2].size == 2'b01) begin
                            LQ[ex_lq_index2].prd_data <= LQ[ex_lq_index2].sign_extend ? 
                                { {16{SQ[aliased_sq_address2].prs2_data[15]}}, SQ[aliased_sq_address2].prs2_data[15:0] } : 
                                { 16'b0, SQ[aliased_sq_address2].prs2_data[15:0] };
                        end 
                        else begin
                            LQ[ex_lq_index2].prd_data <= SQ[aliased_sq_address2].prs2_data;
                        end
                    end else begin
                        LQ[ex_lq_index2].forwarding_stalled <= 1;
                        LQ[ex_lq_index2].forwarding_sq_index <= aliased_sq_address2;
                    end
                end else if (address2_not_available) begin
                    LQ[ex_lq_index2].speculative_execution <= 1;
                    LQ[ex_lq_index2].mem_read <= 1;
                end else begin
                    LQ[ex_lq_index2].speculative_execution <= 0;
                    LQ[ex_lq_index2].mem_read <= 1;
                end
            end

            // 4. STLF WAKEUP (Snooping data for stalled loads)
            for (int offset = 0; offset < LQ_ENTRIES; offset++) begin
                if (offset < lq_count) begin
                    logic [LQ_ADDRESS-1:0] idx;
                    idx = LQ_ADDRESS'(lq_head[LQ_ADDRESS-1:0] + offset);
                    
                    if (LQ[idx].forwarding_stalled) begin
                        if (SQ[LQ[idx].forwarding_sq_index].prs2_available) begin
                            LQ[idx].prd_available <= 1;
                            LQ[idx].forwarding_stalled <= 0;
                            
                            // Inline STLF Format
                            if (LQ[idx].size == 2'b00) begin 
                                LQ[idx].prd_data <= LQ[idx].sign_extend ? 
                                    { {24{SQ[LQ[idx].forwarding_sq_index].prs2_data[7]}}, SQ[LQ[idx].forwarding_sq_index].prs2_data[7:0] } : 
                                    { 24'b0, SQ[LQ[idx].forwarding_sq_index].prs2_data[7:0] };
                            end 
                            else if (LQ[idx].size == 2'b01) begin 
                                LQ[idx].prd_data <= LQ[idx].sign_extend ? 
                                    { {16{SQ[LQ[idx].forwarding_sq_index].prs2_data[15]}}, SQ[LQ[idx].forwarding_sq_index].prs2_data[15:0] } : 
                                    { 16'b0, SQ[LQ[idx].forwarding_sq_index].prs2_data[15:0] };
                            end 
                            else begin 
                                LQ[idx].prd_data <= SQ[LQ[idx].forwarding_sq_index].prs2_data;
                            end
                        end
                    end
                end
            end

            // Memory returns load data (already formatted by Data Memory)
            if (mem_lq_write) begin
                LQ[mem_lq_index].prd_data <= mem_read_data;
                LQ[mem_lq_index].prd_available <= 1;
                LQ[mem_lq_index].mem_read <= 0; 
            end

            // 5. PRF WRITE ACKNOWLEDGMENT
            if (lsq_write_prf) begin
                for (int offset = 0; offset < LQ_ENTRIES; offset++) begin
                    if (offset < lq_count) begin
                        logic [LQ_ADDRESS-1:0] idx;
                        idx = LQ_ADDRESS'(lq_head[LQ_ADDRESS-1:0] + offset);
                        if (LQ[idx].prd == lsq_write_prf_address && LQ[idx].prd_available) begin
                            LQ[idx].prd_available <= 0; // Stop spamming PRF arbiter
                        end
                    end
                end
            end

            // Store Queue Snooping CDB
            if (cdb_result1_available) begin
                for (int offset = 0; offset < SQ_ENTRIES; offset++) begin
                    if (offset < sq_count) begin
                        logic [SQ_ADDRESS-1:0] idx;
                        idx = SQ_ADDRESS'(sq_head[SQ_ADDRESS-1:0] + offset);
                        if (!SQ[idx].prs2_available && (cdb_tag1_broadcast == SQ[idx].prs2)) begin
                            SQ[idx].prs2_available <= 1;
                            SQ[idx].prs2_data <= cdb_result1_broadcast;
                        end
                    end
                end
            end
            if (cdb_result2_available) begin
                for (int offset = 0; offset < SQ_ENTRIES; offset++) begin
                    if (offset < sq_count) begin
                        logic [SQ_ADDRESS-1:0] idx;
                        idx = SQ_ADDRESS'(sq_head[SQ_ADDRESS-1:0] + offset);
                        if (!SQ[idx].prs2_available && (cdb_tag2_broadcast == SQ[idx].prs2)) begin
                            SQ[idx].prs2_available <= 1;
                            SQ[idx].prs2_data <= cdb_result2_broadcast;
                        end
                    end
                end
            end

            // Record Execution Addresses
            if (ex_mem_address1_available && ex_is_load1) begin
                LQ[ex_lq_index1].address_available <= 1;
                LQ[ex_lq_index1].address <= ex_mem_address1;
            end
            if (ex_mem_address2_available && ex_is_load2) begin
                LQ[ex_lq_index2].address_available <= 1;
                LQ[ex_lq_index2].address <= ex_mem_address2;
            end
            if (ex_mem_address1_available && ex_is_store1) begin
                SQ[ex_sq_index1].address_available <= 1;
                SQ[ex_sq_index1].address <= ex_mem_address1;
            end
            if (ex_mem_address2_available && ex_is_store2) begin
                SQ[ex_sq_index2].address_available <= 1;
                SQ[ex_sq_index2].address <= ex_mem_address2;
            end

            // Memory Violation Checking
            if ((ex_mem_address1_available && ex_is_store1) || (ex_mem_address2_available && ex_is_store2)) begin
                for (int offset = 0; offset < LQ_ENTRIES; offset++) begin
                    if (offset < lq_count) begin
                        logic [LQ_ADDRESS-1:0] idx;
                        idx = LQ_ADDRESS'(lq_head[LQ_ADDRESS-1:0] + offset);
                        
                        if (LQ[idx].speculative_execution && LQ[idx].address_available) begin 
                            if (ex_mem_address1_available && ex_is_store1 && 
                               (LQ[idx].address == ex_mem_address1) && (LQ[idx].age > SQ[ex_sq_index1].age)) begin
                                LQ[idx].violated <= 1;
                            end
                            if (ex_mem_address2_available && ex_is_store2 && 
                               (LQ[idx].address == ex_mem_address2) && (LQ[idx].age > SQ[ex_sq_index2].age)) begin
                                LQ[idx].violated <= 1;
                            end
                        end
                    end
                end
            end
            
        end
    end
endmodule