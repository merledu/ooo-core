// Unit test of the branch prediction structures: BTB, PHT, GHR, RAS and BIQ.
module tb_predictors;
    logic CLK = 0, reset = 1;
    always #1 CLK = ~CLK;
    int errors = 0, checks = 0;

    task automatic check(input string what, input logic [63:0] value, input logic [63:0] expected);
        checks++;
        if (value !== expected) begin errors++; $display("FAIL @%0t %s: %h expected %h", $time, what, value, expected); end
    endtask
    task automatic tick(); @(negedge CLK); endtask

    // ---------------------------------------------------------------- BTB
    logic btb_read_en = 1, btb_if_write = 0, btb_if_slot = 0, btb_ex_write = 0, btb_ex_slot = 0, btb_ex_is_branch = 0;
    logic [31:0] btb_read_pc = 0, btb_if_pc = 0, btb_ex_pc = 0, btb_target;
    logic [29:0] btb_ex_target = 0, btb_if_target = 0;
    logic btb_hit, btb_slot, btb_is_branch;
    // direct mapped (BTB_WAYS = 1): replacement of a row, stall, IF/EX write conflict
    BTB #(.BTB_WAYS(1)) btb (.CLK(CLK), .reset(reset), .read_en(btb_read_en), .if_write(btb_if_write), .if_slot(btb_if_slot),
             .ex_write(btb_ex_write), .ex_slot(btb_ex_slot), .ex_is_branch(btb_ex_is_branch),
             .read_pc(btb_read_pc), .if_pc(btb_if_pc), .ex_pc(btb_ex_pc), .ex_target_address(btb_ex_target), .if_target_address(btb_if_target),
             .btb_hit(btb_hit), .btb_slot(btb_slot), .btb_is_branch(btb_is_branch), .pred_target_address(btb_target));

    // 2-way set associative (the core's configuration): two bundles share a set, the least recently used way is replaced
    logic btb2_if_write = 0, btb2_ex_write = 0;
    logic [31:0] btb2_read_pc = 0, btb2_if_pc = 0, btb2_ex_pc = 0, btb2_target;
    logic [29:0] btb2_ex_target = 0, btb2_if_target = 0;
    logic btb2_hit, btb2_slot, btb2_is_branch;
    BTB #(.BTB_WAYS(2)) btb2 (.CLK(CLK), .reset(reset), .read_en(1'b1), .if_write(btb2_if_write), .if_slot(1'b0),
             .ex_write(btb2_ex_write), .ex_slot(1'b0), .ex_is_branch(1'b1),
             .read_pc(btb2_read_pc), .if_pc(btb2_if_pc), .ex_pc(btb2_ex_pc), .ex_target_address(btb2_ex_target), .if_target_address(btb2_if_target),
             .btb_hit(btb2_hit), .btb_slot(btb2_slot), .btb_is_branch(btb2_is_branch), .pred_target_address(btb2_target));

    // ---------------------------------------------------------------- PHT
    logic pht_taken = 0, pht_update = 0, pht_read_en = 1, pht_pred;
    logic [8:0] pht_index = 0, pht_rb_index = 0;
    PHT pht (.CLK(CLK), .reset(reset), .ex_actual_taken(pht_taken), .update_pht(pht_update), .read_en(pht_read_en),
             .pht_index(pht_index), .rb_pht_index(pht_rb_index), .pred_taken(pht_pred));

    // ---------------------------------------------------------------- GHR
    logic ghr_restore = 0, ghr_ex_taken = 0, ghr_ex_branch = 0, ghr_spec = 0, ghr_spec_taken = 0;
    logic [8:0] ghr_snap = 0, ghr_out, ghr_prev;
    GHR ghr (.CLK(CLK), .reset(reset), .restore_ghr(ghr_restore), .ex_actual_taken(ghr_ex_taken), .ex_is_branch(ghr_ex_branch),
             .spec_update(ghr_spec), .spec_taken(ghr_spec_taken), .ghr_snap(ghr_snap), .ghr_out(ghr_out), .prev_ghr(ghr_prev));

    // ---------------------------------------------------------------- RAS
    logic ras_restore = 0, ras_push = 0, ras_pop = 0, ras_en = 0;
    logic [31:0] ras_addr = 0, ras_top;
    logic [2:0] ras_rb_sp = 0, ras_sp_pre, ras_sp_post;
    logic [63:0] ras_rb_snap = 0, ras_snap_pre, ras_snap_post;
    RAS ras (.CLK(CLK), .reset(reset), .restore_ras(ras_restore), .push(ras_push), .pop(ras_pop), .update_en(ras_en),
             .if_actual_return_address(ras_addr), .rb_sp_snap(ras_rb_sp), .rb_ras_snap(ras_rb_snap),
             .pred_return_address(ras_top), .sp_snap_pre(ras_sp_pre), .sp_snap_post(ras_sp_post),
             .ras_snap_pre(ras_snap_pre), .ras_snap_post(ras_snap_post));

    // ---------------------------------------------------------------- BIQ (8 entries)
    logic biq_flush = 0, biq_alloc = 0, biq_pt = 0, biq_slot_in = 0, biq_ret_in = 0, biq_gflush = 0;
    logic [1:0] biq_dealloc = 0;
    logic [31:0] biq_target_in = 0, biq_target;
    logic [2:0] biq_id = 0, biq_flush_id = 0, biq_address;
    logic biq_pred_taken, biq_slot, biq_is_ret, biq_full;
    logic biq_res_cond = 0, biq_res_taken = 0, biq_train, biq_train_taken;
    BIQ #(.BIQ_ADDRESS(3)) biq (.CLK(CLK), .reset(reset), .flush(biq_flush), .biq_alloc(biq_alloc), .pred_taken(biq_pt), .slot(biq_slot_in),
             .is_ret(biq_ret_in), .rob_global_flush(biq_gflush), .biq_dealloc(biq_dealloc), .pred_target(biq_target_in),
             .biq_id(biq_id), .flush_biq_id(biq_flush_id), .pht_index(9'b0), .prev_ghr(9'b0), .sp_snap(3'b0), .ras_snap(64'b0),
             .resolve_cond(biq_res_cond), .resolve_taken(biq_res_taken), .train_pht(biq_train), .train_taken(biq_train_taken), .train_pht_index(),
             .biq_pred_taken(biq_pred_taken), .biq_slot(biq_slot), .biq_is_ret(biq_is_ret), .biq_full(biq_full),
             .biq_address(biq_address), .biq_pred_target(biq_target), .biq_restore_ghr(), .biq_sp_snap(), .biq_ras_snap(), .biq_pht_index());

    task automatic biq_push(input logic [31:0] target, input logic taken, output logic [2:0] id);
        tick(); biq_alloc = 1; biq_target_in = target; biq_pt = taken; biq_slot_in = target[2]; biq_ret_in = target[3];
        #0.2 id = biq_address;
        tick(); biq_alloc = 0;
    endtask
    task automatic biq_read(input logic [2:0] id, input logic [31:0] target, input logic taken);
        tick(); biq_id = id;
        tick();
        check("BIQ target", biq_target, target);
        check("BIQ flags", {biq_pred_taken, biq_slot, biq_is_ret}, {taken, target[2], target[3]});
    endtask

    logic [2:0] ids [16];
    initial begin
        repeat (3) tick();
        reset = 0;

        // ================= BTB =================
        tick(); btb_read_pc = 32'h8000_0100;
        tick(); check("BTB empty: miss", btb_hit, 0);
        // taken branch resolved in EX stage (2nd instruction of the bundle)
        btb_ex_write = 1; btb_ex_pc = 32'h8000_0100; btb_ex_target = 30'h2000_0080; btb_ex_slot = 1; btb_ex_is_branch = 1;
        tick(); btb_ex_write = 0;
        tick(); check("BTB hit", {btb_hit, btb_slot, btb_is_branch}, 3'b111);
                check("BTB target", btb_target, 32'h8000_0200);
        // bundle starting at the next instruction is a different entry
        btb_read_pc = 32'h8000_0104;
        tick(); check("BTB pc+4: miss", btb_hit, 0);
        // same index, other tag
        btb_read_pc = 32'h8000_0200;
        tick(); check("BTB other tag: miss", btb_hit, 0);
        // jal found in fetch stage
        btb_if_write = 1; btb_if_pc = 32'h8000_0200; btb_if_target = 30'h2000_0000; btb_if_slot = 0;
        tick(); btb_if_write = 0;
        tick(); check("BTB jal hit", {btb_hit, btb_slot, btb_is_branch}, 3'b100);
                check("BTB jal target", btb_target, 32'h8000_0000);
        // it replaced the branch (direct mapped, same row)
        btb_read_pc = 32'h8000_0100;
        tick(); check("BTB replaced entry: miss", btb_hit, 0);
        // stalled: output is held
        btb_read_pc = 32'h8000_0200; tick();
        btb_read_en = 0; btb_read_pc = 32'h8000_0100;
        tick(); check("BTB holds its output when stalled", btb_hit, 1);
        btb_read_en = 1;
        // EX and IF write the same row in one cycle: EX (older instruction) wins
        btb_if_write = 1; btb_if_pc = 32'h8000_0300; btb_if_target = 30'h1; btb_ex_write = 1; btb_ex_pc = 32'h8000_0300; btb_ex_target = 30'h2; btb_ex_slot = 0; btb_ex_is_branch = 0;
        tick(); btb_if_write = 0; btb_ex_write = 0; btb_read_pc = 32'h8000_0300;
        tick(); check("BTB EX write wins", btb_target, 32'h8);

        // ================= BTB, 2 ways =================
        // 0x100, 0x200 and 0x300 all fall in set 0 (32 sets)
        btb2_read_pc = 32'h8000_0100;
        btb2_ex_write = 1; btb2_ex_pc = 32'h8000_0100; btb2_ex_target = 30'h0000_0011;
        tick(); btb2_ex_pc = 32'h8000_0200; btb2_ex_target = 30'h0000_0022;
        tick(); btb2_ex_write = 0;
        tick(); check("BTB2 1st bundle of the set: hit", btb2_hit, 1);
                check("BTB2 1st bundle target", btb2_target, 32'h44);
        btb2_read_pc = 32'h8000_0200;
        tick(); check("BTB2 2nd bundle of the set kept the 1st: hit", btb2_hit, 1);
                check("BTB2 2nd bundle target", btb2_target, 32'h88);
        // use 0x100 again, so 0x200 is the least recently used way
        btb2_read_pc = 32'h8000_0100;
        tick(); check("BTB2 1st bundle still there: hit", btb2_hit, 1);
        // a 3rd bundle in the full set replaces 0x200, not 0x100
        btb2_if_write = 1; btb2_if_pc = 32'h8000_0300; btb2_if_target = 30'h0000_0033;
        tick(); btb2_if_write = 0;
        tick(); check("BTB2 most recently used bundle kept: hit", btb2_hit, 1);
                check("BTB2 kept bundle target", btb2_target, 32'h44);
        btb2_read_pc = 32'h8000_0300;
        tick(); check("BTB2 3rd bundle: hit", btb2_hit, 1);
                check("BTB2 3rd bundle target", btb2_target, 32'hcc);
        btb2_read_pc = 32'h8000_0200;
        tick(); check("BTB2 least recently used bundle replaced: miss", btb2_hit, 0);
        // rewriting a bundle that is already in the set updates its way in place
        btb2_ex_write = 1; btb2_ex_pc = 32'h8000_0300; btb2_ex_target = 30'h0000_0044; btb2_read_pc = 32'h8000_0100;
        tick(); btb2_ex_write = 0;
        tick(); check("BTB2 rewrite keeps the other way: hit", btb2_hit, 1);
        btb2_read_pc = 32'h8000_0300;
        tick(); check("BTB2 rewritten target", btb2_target, 32'h110);

        // ================= PHT =================
        pht_index = 9'd5; pht_rb_index = 9'd5;
        tick(); check("PHT starts not taken", pht_pred, 0);
        pht_update = 1; pht_taken = 1; tick();           // 01 -> 10
        pht_update = 0; tick(); check("PHT taken after 1 taken (weak)", pht_pred, 1);
        pht_update = 1; pht_taken = 1; repeat (5) tick();  // saturates at 11
        pht_taken = 0; tick();                           // 11 -> 10
        pht_update = 0; tick(); check("PHT still taken after 1 not taken", pht_pred, 1);
        pht_update = 1; pht_taken = 0; tick();           // 10 -> 01
        pht_update = 0; tick(); check("PHT not taken after 2 not taken", pht_pred, 0);
        pht_update = 1; repeat (5) tick();               // saturates at 00
        pht_taken = 1; tick();                           // 00 -> 01
        pht_update = 0; tick(); check("PHT not taken after saturation + 1 taken", pht_pred, 0);
        pht_index = 9'd6; tick(); check("PHT other counter untouched", pht_pred, 0);

        // ================= GHR =================
        ghr_spec = 1; ghr_spec_taken = 1; tick(); ghr_spec_taken = 0; tick(); ghr_spec_taken = 1; tick(); ghr_spec = 0;
        #0.2 check("GHR speculative history", ghr_out, 9'b101);
        ghr_restore = 1; ghr_snap = 9'b1_0000_0001; ghr_ex_branch = 1; ghr_ex_taken = 0; tick(); ghr_restore = 0;
        #0.2 check("GHR restore (branch): snapshot + outcome", ghr_out, 9'b0_0000_0010);
        ghr_restore = 1; ghr_snap = 9'b0_0000_0111; ghr_ex_branch = 0; tick(); ghr_restore = 0;
        #0.2 check("GHR restore (jump): snapshot", ghr_out, 9'b0_0000_0111);

        // ================= RAS =================
        ras_en = 1;
        ras_push = 1; ras_addr = 32'h100; tick();
        ras_addr = 32'h200; tick();
        ras_addr = 32'h300; #0.2;
        check("RAS top", ras_top, 32'h200);
        check("RAS snapshot after push", {ras_sp_post, ras_snap_post}, {3'd3, 32'h200, 32'h300});
        tick(); ras_push = 0;
        // stalled: nothing changes
        ras_en = 0; ras_pop = 1; tick(); ras_en = 1; ras_pop = 0;
        #0.2 check("RAS not popped while stalled", ras_top, 32'h300);
        ras_pop = 1; #0.2 check("RAS snapshot after pop", {ras_sp_post, ras_snap_post}, {3'd2, 32'h100, 32'h200});
        tick(); #0.2 check("RAS after 1 pop", ras_top, 32'h200);
        tick(); #0.2 check("RAS after 2 pops", ras_top, 32'h100);
        ras_pop = 0;
        // wrong path push, then restore the state saved by the mispredicted branch
        ras_push = 1; ras_addr = 32'hBAD; tick(); tick(); ras_push = 0;
        ras_restore = 1; ras_rb_sp = 3'd3; ras_rb_snap = {32'h200, 32'h300}; tick(); ras_restore = 0;
        #0.2 check("RAS restored top", ras_top, 32'h300);
        ras_pop = 1; tick(); #0.2 check("RAS restored 2nd entry", ras_top, 32'h200);
        tick(); ras_pop = 0; #0.2 check("RAS deeper entry survived", ras_top, 32'h100);
        // more calls than entries: the newest 8 return addresses are kept
        ras_push = 1; for (int i = 1; i <= 12; i++) begin ras_addr = 32'h1000 + i; tick(); end
        ras_push = 0; ras_pop = 1;
        for (int i = 12; i > 4; i--) begin #0.2 check("RAS overflow keeps the newest", ras_top, 32'h1000 + i); tick(); end
        ras_pop = 0;

        // ================= BIQ =================
        for (int i = 0; i < 5; i++) biq_push(32'h4000 + i * 4, i[0], ids[i]);
        for (int i = 0; i < 5; i++) check("BIQ entries are allocated in order", ids[i], i);
        for (int i = 4; i >= 0; i--) biq_read(ids[i], 32'h4000 + i * 4, i[0]);
        // conditional branches 0 (taken) and 3 (wrong path, flushed below) resolve in EX stage
        tick(); biq_res_cond = 1; biq_flush_id = ids[0]; biq_res_taken = 1;
        tick(); biq_flush_id = ids[3]; biq_res_taken = 0;
        tick(); biq_res_cond = 0;
        // branch 2 mispredicted: entries 3 and 4 are dropped, 2 stays until it commits
        tick(); biq_flush = 1; biq_flush_id = ids[2]; tick(); biq_flush = 0;
        biq_push(32'h5000, 1, ids[5]);
        check("BIQ entry after the mispredicted branch is reused", ids[5], 3'd3);
        biq_read(ids[2], 32'h4008, 0);
        biq_read(ids[5], 32'h5000, 1);
        // 2 branches commit in one cycle (0 and 1): they train the PHT one after the other, only the resolved one
        tick(); biq_dealloc = 2; tick(); biq_dealloc = 0;
        #0.2 check("committed taken branch trains the PHT", {biq_train, biq_train_taken}, 2'b11);
        tick(); #0.2 check("committed branch which did not resolve does not train", biq_train, 0);
        tick(); #0.2 check("nothing left to train", biq_train, 0);
        // fill it: 2 in use (ids 2,3), 6 more fit
        for (int i = 0; i < 6; i++) begin #0.2 check("BIQ not full yet", biq_full, 0); biq_push(32'h6000 + i * 4, 0, ids[6 + i]); end
        #0.2 check("BIQ full", biq_full, 1);
        check("BIQ index wraps", ids[11], 3'd1);
        tick(); biq_alloc = 1; tick(); biq_alloc = 0;      // ignored when full
        biq_read(ids[2], 32'h4008, 0);                     // oldest entry not overwritten
        tick(); biq_dealloc = 1; tick(); biq_dealloc = 0;
        #0.2 check("committed entry is in use until it trained the PHT", biq_full, 1);
        tick(); #0.2 check("BIQ not full after a commit", biq_full, 0);
        // entry 3 was resolved on the wrong path, then reused by a branch which did not resolve
        tick(); biq_dealloc = 1; tick(); biq_dealloc = 0;
        #0.2 check("outcome of a wrong path branch does not train the PHT", biq_train, 0);
        // misprediction of a branch whose entry is behind the wrap around
        tick(); biq_flush = 1; biq_flush_id = ids[10]; tick(); biq_flush = 0;
        biq_push(32'h7000, 1, ids[12]);
        check("BIQ flush across the wrap around", ids[12], 3'd1);
        // memory violation flush: every remaining entry is dropped
        tick(); biq_gflush = 1; tick(); biq_gflush = 0;
        for (int i = 0; i < 8; i++) begin #0.2 check("BIQ empty after global flush", biq_full, 0); biq_push(32'h8000 + i, 0, ids[0]); end
        #0.2 check("BIQ full again", biq_full, 1);

        if (errors == 0) $display("PASS tb_predictors (%0d checks)", checks);
        else             $display("FAIL tb_predictors: %0d errors in %0d checks", errors, checks);
        $finish;
    end

    initial begin
        #100000;
        $display("FAIL tb_predictors: timeout");
        $finish;
    end
endmodule
