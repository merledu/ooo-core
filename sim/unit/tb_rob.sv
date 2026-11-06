// Unit test of ROB against a queue model: random dispatch (0-2 per cycle), completion in random order,
// in-order commit of up to 2 instructions with the right rd/prd/old_prd/flags, full detection,
// branch misprediction (younger entries dropped) and memory violation flush (everything dropped, pc of the load).
module tb_rob;
    localparam ROB_SIZE = 16;       // small, so the pointers wrap and the buffer gets full
    logic CLK = 0, reset = 1;
    always #1 CLK = ~CLK;

    logic dis_fire = 0, flush = 0, rn_valid1 = 0, rn_valid2 = 0, cdb_done1 = 0, cdb_done2 = 0;
    logic rn_is_branch1 = 0, rn_is_branch2 = 0, rn_is_load1 = 0, rn_is_load2 = 0, rn_is_store1 = 0, rn_is_store2 = 0;
    logic [4:0] rn_rd1 = 0, rn_rd2 = 0;
    logic [5:0] rn_prd1 = 0, rn_prd2 = 0, rn_old_prd1 = 0, rn_old_prd2 = 0;
    logic [3:0] cdb_rob_index1 = 0, cdb_rob_index2 = 0, cdb_branch_rob_index = 0;
    logic [29:0] rn_pc1 = 0, rn_pc2 = 0;
    logic load1_violation = 0, load2_violation = 0;

    logic rob_full, commit1, commit2, global_flush;
    logic [4:0] current_rob_index;
    logic [3:0] rob_index1, rob_index2;
    logic c_branch1, c_branch2, c_load1, c_load2, c_store1, c_store2;
    logic [5:0] free1, free2, comm_prd1, comm_prd2;
    logic [4:0] comm_rd1, comm_rd2;
    logic [29:0] flush_pc;

    ROB #(.ROB_SIZE(ROB_SIZE)) dut (
        .CLK(CLK), .reset(reset), .dis_fire(dis_fire), .flush(flush), .rn_valid1(rn_valid1), .rn_valid2(rn_valid2),
        .cdb_done1(cdb_done1), .cdb_done2(cdb_done2), .rn_is_branch1(rn_is_branch1), .rn_is_branch2(rn_is_branch2),
        .rn_rd1(rn_rd1), .rn_rd2(rn_rd2), .rn_prd1(rn_prd1), .rn_prd2(rn_prd2), .rn_old_prd1(rn_old_prd1), .rn_old_prd2(rn_old_prd2),
        .cdb_rob_index1(cdb_rob_index1), .cdb_rob_index2(cdb_rob_index2), .cdb_branch_rob_index(cdb_branch_rob_index),
        .rn_is_load1(rn_is_load1), .rn_is_load2(rn_is_load2), .rn_is_store1(rn_is_store1), .rn_is_store2(rn_is_store2),
        .rn_pc1(rn_pc1), .rn_pc2(rn_pc2), .load1_violation_flush(load1_violation), .load2_violation_flush(load2_violation),
        .rob_full(rob_full), .commit_instr1(commit1), .commit_instr2(commit2), .current_rob_index(current_rob_index),
        .rob_index1(rob_index1), .rob_index2(rob_index2), .commit_is_branch1(c_branch1), .commit_is_branch2(c_branch2),
        .dis_free_old_prd1(free1), .dis_free_old_prd2(free2), .comm_prd1(comm_prd1), .comm_prd2(comm_prd2),
        .comm_rd1(comm_rd1), .comm_rd2(comm_rd2), .rob_global_flush(global_flush), .rob_flush_pc(flush_pc),
        .commit_is_load1(c_load1), .commit_is_load2(c_load2), .commit_is_store1(c_store1), .commit_is_store2(c_store2));

    typedef struct {
        logic [3:0] index;
        logic [29:0] pc;
        logic [4:0] rd;
        logic [5:0] prd, old_prd;
        logic is_load, is_store, is_branch, done;
    } entry_t;
    entry_t q [$];
    int errors = 0, committed = 0, flushes = 0, global_flushes = 0, full_cycles = 0, pc_counter = 0;

    task automatic err(input string msg);
        errors++;
        if (errors < 20) $display("FAIL @%0t %s", $time, msg);
    endtask

    function automatic entry_t new_entry(input logic [3:0] index);
        entry_t e;
        e.index = index; e.pc = 30'(pc_counter++); e.rd = $urandom; e.prd = $urandom; e.old_prd = $urandom;
        e.is_load = ($urandom_range(4) == 0); e.is_store = !e.is_load && ($urandom_range(4) == 0);
        e.is_branch = !e.is_load && !e.is_store && ($urandom_range(3) == 0); e.done = 0;
        return e;
    endfunction

    task automatic check_commit(input int slot, input entry_t e, input logic [4:0] rd, input logic [5:0] prd, input logic [5:0] old_prd,
                                input logic l, input logic s, input logic b);
        committed++;
        if (rd !== e.rd || prd !== e.prd || old_prd !== e.old_prd || l !== e.is_load || s !== e.is_store || b !== e.is_branch)
            err($sformatf("commit slot %0d: wrong entry (rd=%0d prd=%0d old=%0d, expected rd=%0d prd=%0d old=%0d)", slot, rd, prd, old_prd, e.rd, e.prd, e.old_prd));
    endtask

    initial begin
        entry_t e1, e2;
        logic exp_c1, exp_c2, exp_gf;
        int n, pick, undone [$];
        repeat (3) @(negedge CLK);
        reset = 0;
        repeat (20000) begin
            @(negedge CLK);
            // ---------------- inputs of this cycle
            dis_fire = 0; flush = 0; cdb_done1 = 0; cdb_done2 = 0; rn_valid1 = 0; rn_valid2 = 0;
            load1_violation = ($urandom_range(40) == 0); load2_violation = ($urandom_range(40) == 0);
            #0.2;
            if (rob_full) full_cycles++;
            if (rob_full !== (q.size() >= ROB_SIZE - 1)) err($sformatf("rob_full=%b with %0d entries", rob_full, q.size()));
            if (!rob_full && $urandom_range(3) != 0) begin
                rn_valid1 = $urandom_range(5) != 0; rn_valid2 = $urandom_range(5) != 0;
                dis_fire = rn_valid1 || rn_valid2;
            end
            #0.2;
            if (rn_valid1) begin
                e1 = new_entry(rob_index1);
                rn_pc1 = e1.pc; rn_rd1 = e1.rd; rn_prd1 = e1.prd; rn_old_prd1 = e1.old_prd; rn_is_load1 = e1.is_load; rn_is_store1 = e1.is_store; rn_is_branch1 = e1.is_branch;
            end
            if (rn_valid2) begin
                e2 = new_entry(rob_index2);
                rn_pc2 = e2.pc; rn_rd2 = e2.rd; rn_prd2 = e2.prd; rn_old_prd2 = e2.old_prd; rn_is_load2 = e2.is_load; rn_is_store2 = e2.is_store; rn_is_branch2 = e2.is_branch;
            end
            if (rn_valid1 && rn_valid2 && rob_index2 !== 4'(rob_index1 + 1)) err("rob_index2 is not rob_index1 + 1");
            if (!rn_valid1 && rn_valid2 && rob_index2 !== rob_index1) err("rob_index2 must be the tail when instr1 is not valid");
            // completion of up to 2 random entries
            undone.delete();
            foreach (q[i]) if (!q[i].done) undone.push_back(i);
            n = 0;
            if (undone.size() != 0 && $urandom_range(2) != 0) begin
                pick = undone[$urandom_range(undone.size() - 1)];
                cdb_done1 = 1; cdb_rob_index1 = q[pick].index; n = 1;
                // a branch is resolved when it completes, sometimes it was mispredicted
                if (q[pick].is_branch) begin
                    cdb_branch_rob_index = q[pick].index;
                    flush = ($urandom_range(2) == 0);
                end
            end
            if (undone.size() > 1 && $urandom_range(1)) begin
                int pick2;
                pick2 = undone[$urandom_range(undone.size() - 1)];
                if (!cdb_done1 || pick2 != pick) begin cdb_done2 = 1; cdb_rob_index2 = q[pick2].index; n = 2; end
            end
            if (flush) dis_fire = 0;      // wrong path bundle is not dispatched
            #0.2;

            // ---------------- commit outputs (same rule as the ROB: memory violation is detected at the head)
            exp_gf = 0; exp_c1 = 0; exp_c2 = 0;
            if (q.size() > 0 && q[0].done) begin
                if (q[0].is_load && load1_violation) exp_gf = 1;
                else begin
                    exp_c1 = 1;
                    if (q.size() > 1 && q[1].done && !(q[1].is_load && (q[0].is_load ? load2_violation : load1_violation))) exp_c2 = 1;
                end
            end
            if (commit1 !== exp_c1 || commit2 !== exp_c2) err($sformatf("commit %b%b expected %b%b", commit1, commit2, exp_c1, exp_c2));
            if (global_flush !== exp_gf) err($sformatf("global flush %b expected %b", global_flush, exp_gf));
            if (exp_gf && flush_pc !== q[0].pc) err("flush pc is not the pc of the load at the head");
            if (exp_gf) dis_fire = 0;
            if (exp_c1) check_commit(1, q[0], comm_rd1, comm_prd1, free1, c_load1, c_store1, c_branch1);
            if (exp_c2) check_commit(2, q[1], comm_rd2, comm_prd2, free2, c_load2, c_store2, c_branch2);

            // ---------------- model update (what the ROB does at the clock edge)
            if (cdb_done1) foreach (q[i]) if (q[i].index == cdb_rob_index1) q[i].done = 1;
            if (cdb_done2) foreach (q[i]) if (q[i].index == cdb_rob_index2) q[i].done = 1;
            if (exp_gf) begin
                q.delete(); global_flushes++;
            end
            else begin
                if (flush) begin
                    flushes++;
                    while (q.size() != 0 && q[q.size() - 1].index != cdb_branch_rob_index) void'(q.pop_back());
                    if (q.size() == 0) err("testbench: mispredicted branch not in the model");
                end
                else if (dis_fire) begin
                    if (rn_valid1) q.push_back(e1);
                    if (rn_valid2) q.push_back(e2);
                end
                if (exp_c1) void'(q.pop_front());
                if (exp_c2) void'(q.pop_front());
            end
        end
        if (full_cycles == 0) err("ROB never full");
        if (flushes == 0 || global_flushes == 0) err("flushes not tested");
        if (errors == 0) $display("PASS tb_rob (%0d commits, %0d branch flushes, %0d violation flushes, %0d full cycles)", committed, flushes, global_flushes, full_cycles);
        else             $display("FAIL tb_rob: %0d errors", errors);
        $finish;
    end

    // watchdog
    initial begin
        #5000000;
        $display("FAIL tb_rob: timeout");
        $finish;
    end
endmodule
