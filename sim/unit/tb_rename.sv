// Unit test of RN_Stage (RMT + free list + branch snapshots) against a rename model:
//  - sources are renamed to the newest mapping (also when instr2 reads what instr1 of the same bundle writes)
//  - old_prd is the previous mapping of the destination
//  - a physical register is never given out while it is still in use
//  - busy bits follow allocation and CDB wakeups (also a wakeup in the cycle of the rename)
//  - the stage stalls when the free list is empty or all branch tags are in use
//  - a branch misprediction restores the map table and the free list
module tb_rename;
    logic CLK = 0, reset = 1;
    always #1 CLK = ~CLK;

    logic flush = 0;
    logic id_valid1 = 0, id_valid2 = 0, id_take_snap = 0;
    logic id_regwrite1 = 0, id_regwrite2 = 0, id_branch2 = 0;
    logic [4:0] rs1_1 = 0, rs2_1 = 0, rd_1 = 0, rs1_2 = 0, rs2_2 = 0, rd_2 = 0;
    logic cdb_wakeup1 = 0, cdb_branch_resolved = 0, push1 = 0, push2 = 0;
    logic [5:0] cdb_reg1 = 0, free_reg1 = 0, free_reg2 = 0;
    logic [1:0] cdb_branch_tag = 0;
    logic [31:0][5:0] amt_state;

    logic rn_stall, rn_valid1, rn_valid2;
    logic [5:0] prd1, prs1_1, prs2_1, old_prd1, prd2, prs1_2, prs2_2, old_prd2;
    logic busy1_1, busy2_1, busy1_2, busy2_2;
    logic [1:0] rn_branch_tag;
    logic [3:0] mask1, mask2;

    RN_Stage dut (
        .CLK(CLK), .reset(reset), .flush(flush), .id_take_snap(id_take_snap), .id_valid1(id_valid1), .id_valid2(id_valid2),
        .dis_stall_frontend(1'b0), .rob_global_flush(1'b0), .amt_state(amt_state),
        .cdb_wakeup1(cdb_wakeup1), .cdb_wakeup2(1'b0), .comm_free_push1(push1), .comm_free_push2(push2),
        .cdb_branch_resolved(cdb_branch_resolved),
        .id_is_m_extension1(1'b0), .id_is_m_extension2(1'b0), .id_jump_reg1(1'b0), .id_jump_reg2(1'b0), .id_jump1(1'b0), .id_jump2(1'b0),
        .id_branch1(1'b0), .id_branch2(id_branch2), .id_regsrc1_1(1'b0), .id_immtype1(1'b0), .id_memwrite1(1'b0), .id_immtype2(1'b0),
        .id_regsrc2_1(1'b0), .id_regsrc1_2(1'b0), .id_regsrc2_2(1'b0), .id_upperimm1(1'b0), .id_upperimm2(1'b0),
        .id_regwrite1(id_regwrite1), .id_regwrite2(id_regwrite2), .id_memwrite2(1'b0), .id_memtoreg1(1'b0), .id_memtoreg2(1'b0),
        .id_retaddr1(1'b0), .id_retaddr2(1'b0), .id_isimm1(1'b0), .id_isimm2(1'b0),
        .cdb_waked_reg1(cdb_reg1), .cdb_waked_reg2(6'b0), .comm_free_reg1(free_reg1), .comm_free_reg2(free_reg2),
        .cdb_branch_tag(cdb_branch_tag),
        .id_rs1_1(rs1_1), .id_rs2_1(rs2_1), .id_rd_1(rd_1), .id_rs1_2(rs1_2), .id_rs2_2(rs2_2), .id_rd_2(rd_2),
        .id_immout1(21'b0), .id_immout2(21'b0), .id_biq_address(5'b0), .id_pc(30'b0), .id_alu_operation1(5'b0), .id_alu_operation2(5'b0),
        .id_memory_type1(2'b0), .id_memory_type2(2'b0), .id_memory_sign_ext1(1'b0), .id_memory_sign_ext2(1'b0),
        .rn_stall_frontend(rn_stall),
        .rn_prd1(prd1), .rn_prs1_1(prs1_1), .rn_prs2_1(prs2_1), .rn_old_prd1(old_prd1),
        .rn_prd2(prd2), .rn_prs1_2(prs1_2), .rn_prs2_2(prs2_2), .rn_old_prd2(old_prd2),
        .rn_prs1_busy1(busy1_1), .rn_prs2_busy1(busy2_1), .rn_prs1_busy2(busy1_2), .rn_prs2_busy2(busy2_2),
        .rn_branch_tag(rn_branch_tag), .rn_branch_mask1(mask1), .rn_branch_mask2(mask2),
        .rn_biq_address(), .rn_pc(), .rn_rd_1(), .rn_rd_2(), .rn_immout1(), .rn_immout2(), .rn_is_m_extension1(), .rn_is_m_extension2(),
        .rn_alu_operation1(), .rn_alu_operation2(),
        .rn_valid1(rn_valid1), .rn_jump_reg1(), .rn_jump1(), .rn_branch1(), .rn_regsrc1_1(), .rn_regsrc2_1(), .rn_immtype1(), .rn_isimm1(),
        .rn_retaddr1(), .rn_upperimm1(), .rn_regwrite1(), .rn_memwrite1(), .rn_memtoreg1(), .rn_memory_type1(), .rn_memory_sign_ext1(),
        .rn_valid2(rn_valid2), .rn_jump_reg2(), .rn_jump2(), .rn_branch2(), .rn_regsrc1_2(), .rn_regsrc2_2(), .rn_immtype2(), .rn_isimm2(),
        .rn_retaddr2(), .rn_upperimm2(), .rn_regwrite2(), .rn_memwrite2(), .rn_memtoreg2(), .rn_memory_type2(), .rn_memory_sign_ext2());

    // ----------------------------------------------------------------- model
    logic [5:0] map [32];          // speculative register map
    logic [5:0] saved_map [32];    // map right after the outstanding branch
    logic in_use [64];             // physical register is mapped or its release is pending
    logic busy [64];
    logic [5:0] to_free [$];       // old mappings in program order (freed at commit)
    logic [5:0] after_branch [$];  // registers allocated after the outstanding branch
    int frees_after_branch;
    logic branch_pending, branch_seen;
    logic [1:0] branch_tag;
    int errors = 0, checks = 0, stalls = 0, flushes = 0;

    // expectation for the bundle renamed in the previous cycle. FROM1 = "the register given to instr1"
    localparam logic [6:0] FROM1 = 7'h40;
    logic exp_valid1, exp_valid2, exp_w1, exp_w2, exp_branch;
    logic [6:0] exp_prs1_1, exp_prs2_1, exp_prs1_2, exp_prs2_2, exp_old1, exp_old2;
    logic exp_busy1_1, exp_busy2_1, exp_busy1_2, exp_busy2_2;
    logic [4:0] exp_rd1, exp_rd2;

    initial for (int i = 0; i < 32; i++) amt_state[i] = 6'(i);

    task automatic err(input string msg);
        errors++;
        if (errors < 20) $display("FAIL @%0t %s", $time, msg);
    endtask

    function automatic logic [5:0] resolve(input logic [6:0] e);
        return (e == FROM1) ? prd1 : e[5:0];
    endfunction

    task automatic allocate(input logic [5:0] prd, input logic [5:0] old, input logic [4:0] rd, input string who);
        if (prd == 0 || in_use[prd]) err($sformatf("%s got p%0d which is still in use", who, prd));
        in_use[prd] = 1; busy[prd] = 1; map[rd] = prd;
        to_free.push_back(old);
        if (branch_seen) begin after_branch.push_back(prd); frees_after_branch++; end
    endtask

    // 1. outputs of the bundle renamed in the previous cycle
    task automatic check_outputs();
        if (rn_valid1 !== exp_valid1 || rn_valid2 !== exp_valid2) err($sformatf("valid %b%b expected %b%b", rn_valid1, rn_valid2, exp_valid1, exp_valid2));
        if (exp_valid1) begin
            checks++;
            if (prs1_1 !== exp_prs1_1[5:0] || prs2_1 !== exp_prs2_1[5:0]) err($sformatf("instr1 sources p%0d p%0d expected p%0d p%0d", prs1_1, prs2_1, exp_prs1_1[5:0], exp_prs2_1[5:0]));
            if (busy1_1 !== exp_busy1_1 || busy2_1 !== exp_busy2_1) err($sformatf("instr1 busy %b%b expected %b%b", busy1_1, busy2_1, exp_busy1_1, exp_busy2_1));
            if (exp_w1) begin
                if (old_prd1 !== exp_old1[5:0]) err($sformatf("instr1 old_prd p%0d expected p%0d", old_prd1, exp_old1[5:0]));
                allocate(prd1, old_prd1, exp_rd1, "instr1");
            end
            else if (prd1 !== 0) err("instr1 has no destination but got a register");
        end
        if (exp_valid2) begin
            checks++;
            if (prs1_2 !== resolve(exp_prs1_2) || prs2_2 !== resolve(exp_prs2_2)) err($sformatf("instr2 sources p%0d p%0d expected p%0d p%0d", prs1_2, prs2_2, resolve(exp_prs1_2), resolve(exp_prs2_2)));
            if (busy1_2 !== exp_busy1_2 || busy2_2 !== exp_busy2_2) err($sformatf("instr2 busy %b%b expected %b%b", busy1_2, busy2_2, exp_busy1_2, exp_busy2_2));
            if (exp_w2) begin
                if (old_prd2 !== resolve(exp_old2)) err($sformatf("instr2 old_prd p%0d expected p%0d", old_prd2, resolve(exp_old2)));
                allocate(prd2, old_prd2, exp_rd2, "instr2");
            end
            else if (prd2 !== 0) err("instr2 has no destination but got a register");
        end
        if (exp_valid2 && exp_branch) begin
            // snapshot is taken after the whole bundle (branch is instr2)
            for (int i = 0; i < 32; i++) saved_map[i] = map[i];
            branch_tag = rn_branch_tag;
            branch_seen = 1;
            if (mask2[rn_branch_tag]) err("branch depends on its own tag");
        end
    endtask

    // 2. expectation for the bundle in ID stage now (the model already contains everything older)
    task automatic expect_bundle();
        logic fire, w1, w2;
        fire = !rn_stall && !flush;
        w1 = id_valid1 && id_regwrite1 && rd_1 != 0;
        w2 = id_valid2 && id_regwrite2 && rd_2 != 0;
        if (cdb_wakeup1) busy[cdb_reg1] = 0;     // wakeup of this cycle is seen by this bundle
        exp_valid1 = fire && id_valid1;  exp_valid2 = fire && id_valid2;
        exp_w1 = w1; exp_w2 = w2; exp_rd1 = rd_1; exp_rd2 = rd_2;
        exp_branch = id_take_snap && id_branch2;
        exp_prs1_1 = {1'b0, map[rs1_1]}; exp_prs2_1 = {1'b0, map[rs2_1]}; exp_old1 = {1'b0, map[rd_1]};
        exp_busy1_1 = busy[map[rs1_1]];  exp_busy2_1 = busy[map[rs2_1]];
        exp_prs1_2 = (w1 && rs1_2 == rd_1) ? FROM1 : {1'b0, map[rs1_2]};
        exp_prs2_2 = (w1 && rs2_2 == rd_1) ? FROM1 : {1'b0, map[rs2_2]};
        exp_old2   = (w1 && rd_2 == rd_1)  ? FROM1 : {1'b0, map[rd_2]};
        exp_busy1_2 = (w1 && rs1_2 == rd_1) ? 1'b1 : busy[map[rs1_2]];
        exp_busy2_2 = (w1 && rs2_2 == rd_1) ? 1'b1 : busy[map[rs2_2]];
        if (rn_stall) stalls++;
    endtask

    task automatic random_bundle(input logic with_branch);
        id_valid1 = $urandom_range(9) != 0; id_valid2 = $urandom_range(9) != 0;
        rs1_1 = $urandom; rs2_1 = $urandom; rs1_2 = $urandom; rs2_2 = $urandom;
        rd_1 = $urandom_range(3) ? 5'($urandom) : 5'b0; rd_2 = $urandom_range(3) ? 5'($urandom) : 5'b0;
        if ($urandom_range(2) == 0) rs1_2 = rd_1;
        if ($urandom_range(3) == 0) rs2_2 = rd_1;
        if ($urandom_range(3) == 0) rd_2 = rd_1;
        id_regwrite1 = (rd_1 != 0); id_regwrite2 = (rd_2 != 0);
        id_take_snap = 0; id_branch2 = 0;
        if (with_branch) begin id_valid2 = 1; id_branch2 = 1; id_take_snap = 1; id_regwrite2 = 0; rd_2 = 0; end
    endtask

    task automatic no_bundle();
        id_valid1 = 0; id_valid2 = 0; id_take_snap = 0; id_branch2 = 0; id_regwrite1 = 0; id_regwrite2 = 0;
    endtask

    // commit (free the oldest old mappings) and wakeups
    task automatic background(input int commit_rate);
        push1 = 0; push2 = 0; cdb_wakeup1 = 0;
        if ((to_free.size() - frees_after_branch) > 2 && $urandom_range(9) < commit_rate) begin
            free_reg1 = to_free.pop_front(); push1 = (free_reg1 != 0);
            if (push1) in_use[free_reg1] = 0;
            if ((to_free.size() - frees_after_branch) > 2 && $urandom_range(1)) begin
                free_reg2 = to_free.pop_front(); push2 = (free_reg2 != 0);
                if (push2) in_use[free_reg2] = 0;
            end
        end
        cdb_reg1 = $urandom;
        if (cdb_reg1 != 0 && in_use[cdb_reg1] && busy[cdb_reg1] && $urandom_range(1)) cdb_wakeup1 = 1;
    endtask

    logic consumed;
    task automatic cycle(input logic with_branch, input int commit_rate, input logic idle);
        @(negedge CLK);
        check_outputs();
        flush = 0; cdb_branch_resolved = 0;
        if (idle) no_bundle();
        else if (consumed) random_bundle(with_branch);   // a stalled bundle stays in ID stage
        background(commit_rate);
        #0.5;
        expect_bundle();
        consumed = !rn_stall;
        if (with_branch && consumed && !idle) branch_pending = 1;
    endtask

    // branch outcome arrives from EX stage
    task automatic resolve_branch(input logic mispredicted);
        @(negedge CLK);
        check_outputs();     // bundle renamed in the previous cycle (younger than the branch)
        no_bundle(); push1 = 0; push2 = 0; cdb_wakeup1 = 0;
        cdb_branch_resolved = 1; cdb_branch_tag = branch_tag; flush = mispredicted;
        if (mispredicted) begin
            flushes++;
            for (int i = 0; i < 32; i++) map[i] = saved_map[i];
            while (after_branch.size() != 0) in_use[after_branch.pop_back()] = 0;   // back in the free list
            repeat (frees_after_branch) void'(to_free.pop_back());
        end
        after_branch.delete(); frees_after_branch = 0; branch_pending = 0; branch_seen = 0;
        #0.5;
        expect_bundle();
        consumed = 1;
    endtask

    initial begin
        for (int i = 0; i < 64; i++) begin in_use[i] = (i < 32); busy[i] = 0; end
        for (int i = 0; i < 32; i++) map[i] = 6'(i);
        exp_valid1 = 0; exp_valid2 = 0; exp_w1 = 0; exp_w2 = 0; exp_branch = 0;
        frees_after_branch = 0; branch_pending = 0; branch_seen = 0; consumed = 1;
        repeat (3) @(negedge CLK);
        reset = 0;
        @(posedge CLK);

        // 1. random renaming with commits and wakeups (commit is slow at first: the free list runs empty)
        repeat (300)  cycle(0, 2, 0);
        repeat (3000) cycle(0, 7, 0);
        if (stalls == 0) err("free list never ran empty (stall not tested)");

        // 2. branches: rename a branch, some younger bundles, then the branch is resolved (correct or mispredicted)
        repeat (400) begin
            do cycle(1, 7, 0); while (!branch_pending);
            repeat ($urandom_range(6)) cycle(0, 6, 0);
            cycle(0, 6, 1);                      // the branch has left the rename registers
            resolve_branch($urandom_range(1));
            repeat ($urandom_range(3)) cycle(0, 8, 0);
        end
        if (flushes == 0) err("no misprediction tested");

        // 3. all 4 branch tags in use: the 5th branch must wait
        repeat (4) cycle(0, 10, 1);
        begin
            int taken;
            taken = 0;
            for (int i = 0; i < 12; i++) begin
                @(negedge CLK);
                check_outputs();
                branch_seen = 0;                 // (branches of this part are never resolved by the model)
                random_bundle(1); id_valid1 = 0; id_regwrite1 = 0; rd_1 = 0;
                push1 = 0; push2 = 0; cdb_wakeup1 = 0;
                #0.5;
                expect_bundle();
                if (!rn_stall) taken++;
                else if (taken != 4) err($sformatf("stalled with only %0d branch tags in use", taken));
            end
            if (taken != 4) err($sformatf("%0d branches renamed with 4 branch tags", taken));
        end

        if (errors == 0) $display("PASS tb_rename (%0d instructions checked, %0d stall cycles, %0d mispredictions)", checks, stalls, flushes);
        else             $display("FAIL tb_rename: %0d errors", errors);
        $finish;
    end

    // watchdog
    initial begin
        #5000000;
        $display("FAIL tb_rename: timeout");
        $finish;
    end
endmodule
