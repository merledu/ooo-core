// =================================================================================
// tb_core.sv - co-simulation testbench of the whole core
//
// Runs a program (+HEX=<file>, one 32 bit word per line, image starts at RESET_PC)
// and prints every committed instruction and every data memory write:
//
//   C <pc> <rd> <value> <cycle>        instruction committed (value = new value of rd, rd=0: none)
//   M <address> <data> <size> <cycle>  store written to the data memory (size 0:byte 1:half 2:word)
//
// The trace is compared with the commit log of the Spike ISA simulator by run.py.
// The simulation stops when the program writes to the +TOHOST=<hex address> word.
// +SIG=<file> +SIG_BEGIN=<hex> +SIG_END=<hex> writes the data memory between the two addresses
// to the file when the program ends (signature of the RISC-V architectural tests, see ../riscof).
// =================================================================================
module tb_core;
`ifdef TB_MEM_WORDS
    localparam MEM_WORDS = `TB_MEM_WORDS;   // image size in words (power of 2), used for both memories
`else
    localparam MEM_WORDS = 65536;           // 256 KB image, used for both memories
`endif
    localparam RESET_PC  = 32'h8000_0000;

    logic CLK = 0;
    logic reset = 1;

    // +define+SMALL: tiny queues, so that every "full" condition and wrap around happens all the time
`ifdef SMALL
    localparam ROB_SIZE = 16, IQ_ROWS = 8, LQ_ENTRIES = 8, SQ_ENTRIES = 4, BIQ_ADDRESS = 2, MAX_BRANCHES = 2;
`else
    localparam ROB_SIZE = 64, IQ_ROWS = 32, LQ_ENTRIES = 16, SQ_ENTRIES = 32, BIQ_ADDRESS = 5, MAX_BRANCHES = 8;
`endif
    // +define+BOOTH: radix-4 Booth multiplier (ASIC version) instead of the pipelined DSP multiplier
`ifdef BOOTH
    localparam USE_DSP_MUL = 0;
`else
    localparam USE_DSP_MUL = 1;
`endif

    main_datapath #(
        .USE_DSP_MUL  (USE_DSP_MUL),
        .RESET_PC     (RESET_PC),
        .IM_ROWS      (MEM_WORDS),
        .RAM_DEPTH    (MEM_WORDS),
        .ROB_SIZE     (ROB_SIZE),
        .IQ_ROWS      (IQ_ROWS),
        .LQ_ENTRIES   (LQ_ENTRIES),
        .SQ_ENTRIES   (SQ_ENTRIES),
        .BIQ_ADDRESS  (BIQ_ADDRESS),
        .MAX_BRANCHES (MAX_BRANCHES)
    ) dut (
        .CLK(CLK),
        .reset(reset)
    );

    always #1 CLK = ~CLK;

    logic [31:0] image [0:MEM_WORDS-1];
    string hex_file, trace_file, vcd_file, sig_file;
    logic [31:0] sig_begin, sig_end;
    int sig_fd;
    logic [31:0] tohost;
    longint cycles, max_cycles, commits, last_commit_cycle, mispredicts, violations;
    int fd;
    logic done;

    initial begin
        if (!$value$plusargs("HEX=%s", hex_file)) begin
            $display("ERROR: +HEX=<file> is required");
            $finish;
        end
        if (!$value$plusargs("TRACE=%s", trace_file)) trace_file = "trace.log";
        if (!$value$plusargs("TOHOST=%h", tohost)) tohost = 32'hFFFF_FFFC;
        if (!$value$plusargs("MAXCYCLES=%d", max_cycles)) max_cycles = 2000000;
        if ($value$plusargs("VCD=%s", vcd_file)) begin
            $dumpfile(vcd_file);
            $dumpvars(0, tb_core);
        end
        fd = $fopen(trace_file, "w");

        // data memory starts with the same image as the instruction memory (.data / .rodata)
        for (int i = 0; i < MEM_WORDS; i++) image[i] = '0;
        $readmemh(hex_file, image);
        for (int i = 0; i < MEM_WORDS; i++) begin
            for (int b = 0; b < 4; b++) begin
                dut.mem_stage_inst.dm_instantiation.RAM[i][b] = image[i][8*b +: 8];
            end
        end

        cycles = 0; commits = 0; last_commit_cycle = 0; mispredicts = 0; violations = 0; done = 0;
        repeat (4) @(negedge CLK);
        reset = 0;
    end

    // hierarchical names used by the monitors
    `define ROB  dut.dis_stage_inst.rob_instantiation
    `define PRF  dut.rr_stage_inst.prf_instantiation.PRF
    `define IQ   dut.dis_stage_inst.iq_instantiation
    `define LSQ  dut.dis_stage_inst.lsq_instantiation
    `define PD   dut.pd_stage_inst
    `define ID   dut.id_stage_inst
    `define RN   dut.rn_stage_inst
    `define EX   dut.ex_stage_inst
    `define DIS  dut.dis_stage_inst
    // multiplier internals: state (Booth FSM state / valid bits of the 3 DSP stages), operation of the wrong path inside
`ifdef BOOTH
    `define MUL dut.ex_stage_inst.g_mul_booth.mul_inst
    `define MUL_STATE `MUL.state
    `define MUL_FLUSHED (`MUL.state != 0 && `MUL.saved_branch_mask[dut.cdb_branch_tag])
`else
    `define MUL dut.ex_stage_inst.g_mul_dsp.mul_inst
    `define MUL_STATE {`MUL.s1.valid, `MUL.s2.valid, `MUL.s3.valid}
    `define MUL_FLUSHED ((`MUL.s1.valid && `MUL.s1.branch_mask[dut.cdb_branch_tag]) || (`MUL.s2.valid && `MUL.s2.branch_mask[dut.cdb_branch_tag]) || \
                         (`MUL.s3.valid && `MUL.s3.branch_mask[dut.cdb_branch_tag]))
`endif

    // values are sampled right before the clock edge
    // state of the machine when it stops committing
    task automatic dump_state();
        $display("---- HANG: no commit for 5000 cycles ----");
        $display("ROB head=%0d tail=%0d head pc=%08x done=%b load=%b store=%b branch=%b", `ROB.rob_head_ptr, `ROB.rob_tail_ptr,
                 {`ROB.ROB[`ROB.head_idx].pc, 2'b00}, `ROB.ROB[`ROB.head_idx].done, `ROB.ROB[`ROB.head_idx].is_load,
                 `ROB.ROB[`ROB.head_idx].is_store, `ROB.ROB[`ROB.head_idx].is_branch);
        $display("stall: id=%b rn=%b dis=%b issue=%b  mul_busy=%b div_busy=%b  pd_pc=%08x", dut.id_stall_frontend, dut.rn_stall_frontend,
                 dut.dis_stall_frontend, dut.stall_issue, dut.cdb_mul_busy, dut.cdb_div_busy, dut.pd_pc);
        for (int i = 0; i < IQ_ROWS; i++) begin
            if (!`IQ.IQ[i].available)
                $display("IQ[%0d] pc=%08x rob=%0d prs1=%0d busy=%b prs2=%0d busy=%b mask=%b mext=%b op=%b", i, {`IQ.IQ[i].pc, 2'b00}, `IQ.IQ[i].rob_index,
                         `IQ.IQ[i].prs1, `IQ.IQ[i].prs1_busy, `IQ.IQ[i].prs2, `IQ.IQ[i].prs2_busy, `IQ.IQ[i].branch_mask, `IQ.IQ[i].is_m_extension, `IQ.IQ[i].alu_operation);
        end
        $display("LQ head=%0d tail=%0d  SQ head=%0d commit=%0d tail=%0d", `LSQ.lq_head, `LSQ.lq_tail, `LSQ.sq_head, `LSQ.sq_commit, `LSQ.sq_tail);
        for (int i = 0; i < 32; i++) begin
            if (5'(i - `LSQ.lq_head[4:0]) < `LSQ.lq_count)
                $display("LQ[%0d] rob=%0d addr_av=%b addr=%08x fired=%b prd_av=%b spec=%b viol=%b sq_ptr=%0d", i, `LSQ.LQ[i].age, `LSQ.LQ[i].address_available,
                         `LSQ.LQ[i].address, `LSQ.LQ[i].fired, `LSQ.LQ[i].prd_available, `LSQ.LQ[i].speculative_execution, `LSQ.LQ[i].violated, `LSQ.LQ[i].sq_ptr);
        end
        for (int i = 0; i < 16; i++) begin
            if (4'(i - `LSQ.sq_head[3:0]) < `LSQ.sq_count)
                $display("SQ[%0d] addr_av=%b addr=%08x size=%0d lq_ptr=%0d", i, `LSQ.SQ[i].address_available, `LSQ.SQ[i].address, `LSQ.SQ[i].size, `LSQ.SQ[i].lq_ptr);
        end
    endtask

    // ---------------------------------------------------------------------------------
    // Functional coverage: how often the interesting situations happened in this run
    // ---------------------------------------------------------------------------------
    localparam NCOV = 28;
    longint cov [NCOV];
    string cov_name [NCOV] = '{"commit_2_per_cycle", "branch_mispredict", "memory_violation_flush", "btb_predicted_taken",
                               "fetch_stage_redirect", "ras_push", "ras_pop", "bundle_split_2_branches", "stall_biq_full",
                               "stall_no_branch_tag", "stall_free_list_empty", "stall_rob_full", "stall_iq_full", "stall_lq_full",
                               "stall_sq_full", "stall_issue_cdb_busy", "store_to_load_forward", "load_waits_partial_store",
                               "load_speculative", "load_waits_memory_port", "two_mem_ops_in_ex", "mul_issued", "div_issued",
                               "ex_kill_by_same_cycle_branch", "dispatch_slot2_only", "flush_while_stalled", "mul_div_flushed",
                               "muldiv_result_waits_cdb"};
    initial for (int i = 0; i < NCOV; i++) cov[i] = 0;
    always @(posedge CLK) begin
        if (!reset) begin
            if (dut.commit_instr1 && dut.commit_instr2)                              cov[0]++;
            if (dut.ex_flush)                                                         cov[1]++;
            if (dut.rob_global_flush)                                                 cov[2]++;
            if (`PD.if_advance && dut.pd_pred_taken && !dut.if_redirect)              cov[3]++;
            if (`PD.if_advance && dut.if_redirect)                                    cov[4]++;
            if (`PD.if_advance && `PD.ras_push)                                       cov[5]++;
            if (`PD.if_advance && `PD.ras_pop)                                        cov[6]++;
            if (`ID.need_split && !`ID.second_half && !dut.backend_stall)             cov[7]++;
            if (`ID.biq_block)                                                        cov[8]++;
            if ((dut.id_valid1 || dut.id_valid2) && dut.id_take_snap && `RN.bs_full)  cov[9]++;
            if (`RN.fl_empty)                                                         cov[10]++;
            if ((dut.rn_valid1 || dut.rn_valid2) && `DIS.rob_full)                    cov[11]++;
            if ((dut.rn_valid1 || dut.rn_valid2) && `DIS.iq_full)                     cov[12]++;
            if ((dut.rn_valid1 || dut.rn_valid2) && `LSQ.lq_full)                     cov[13]++;
            if ((dut.rn_valid1 || dut.rn_valid2) && `LSQ.sq_full)                     cov[14]++;
            if (dut.stall_issue)                                                      cov[15]++;
            if (`LSQ.fire_forward)                                                    cov[16]++;
            if (`LSQ.fire_found && !`LSQ.store_arriving && `LSQ.fire_hit && !`LSQ.fire_cover) cov[17]++;
            if ((`LSQ.fire_forward || `LSQ.fire_read) && `LSQ.fire_speculative)       cov[18]++;
            if (`LSQ.fire_found && !`LSQ.store_arriving && !`LSQ.fire_hit && dut.lsq_mem_write) cov[19]++;
            if (dut.ex_mem_address1_available && dut.ex_mem_address2_available)       cov[20]++;
            if ((`EX.valid1 && `EX.is_mul1) || (`EX.valid2 && `EX.is_mul2))           cov[21]++;
            if ((`EX.valid1 && `EX.is_div1) || (`EX.valid2 && `EX.is_div2))           cov[22]++;
            if ((dut.rr_valid1 && !`EX.valid1) || (dut.rr_valid2 && !`EX.valid2))     cov[23]++;
            if (`DIS.dis_fire && !dut.rn_valid1 && dut.rn_valid2)                     cov[24]++;
            if (dut.ex_flush && dut.stall_frontend)                                   cov[25]++;
            if (dut.ex_flush && (`MUL_FLUSHED ||
                                 (`EX.div_inst.state != 0 && `EX.div_inst.saved_branch_mask[dut.cdb_branch_tag]))) cov[26]++;
            if ((dut.ex_mul_valid && !dut.mul_ack) || (dut.ex_div_valid && !dut.div_ack)) cov[27]++;
        end
    end

    task automatic finish_sim(input string status);
        for (int i = 0; i < NCOV; i++) $fdisplay(fd, "COV %s %0d", cov_name[i], cov[i]);
        $fdisplay(fd, "END %s cycles=%0d commits=%0d mispredicts=%0d violations=%0d", status, cycles, commits, mispredicts, violations);
        $fclose(fd);
        $display("%s cycles=%0d commits=%0d IPC=%0.3f mispredicts=%0d violations=%0d", status, cycles, commits,
                 (cycles > 0) ? real'(commits) / real'(cycles) : 0.0, mispredicts, violations);
        $finish;
    endtask

    // +DEBUG: one line per pipeline event (dispatch, issue, execute, CDB, flush, commit)
    logic debug;
    initial debug = $test$plusargs("DEBUG");
    always @(posedge CLK) begin
        if (!reset && debug) begin
            if (`DIS.dis_fire && dut.rn_valid1) $display("%0d DIS1 pc=%08x rob=%0d prd=%0d prs1=%0d(%b) prs2=%0d(%b) mask=%b tag=%0d", cycles, {dut.rn_pc, 2'b00}, `DIS.rob_index1, dut.rn_prd1, dut.rn_prs1_1, dut.rn_prs1_busy1, dut.rn_prs2_1, dut.rn_prs2_busy1, dut.rn_branch_mask1, dut.rn_branch_tag);
            if (`DIS.dis_fire && dut.rn_valid2) $display("%0d DIS2 pc=%08x rob=%0d prd=%0d prs1=%0d(%b) prs2=%0d(%b) mask=%b tag=%0d", cycles, {dut.rn_pc + 30'd1, 2'b00}, `DIS.rob_index2, dut.rn_prd2, dut.rn_prs1_2, dut.rn_prs1_busy2, dut.rn_prs2_2, dut.rn_prs2_busy2, dut.rn_branch_mask2, dut.rn_branch_tag);
            if (dut.iss_valid1) $display("%0d ISS1 pc=%08x rob=%0d mask=%b", cycles, {dut.iss_pc1, 2'b00}, dut.iss_rob_index1, dut.iss_branch_mask1);
            if (dut.iss_valid2) $display("%0d ISS2 pc=%08x rob=%0d mask=%b", cycles, {dut.iss_pc2, 2'b00}, dut.iss_rob_index2, dut.iss_branch_mask2);
            if (dut.rr_valid1) $display("%0d EX1  pc=%08x rob=%0d valid=%b a=%08x b=%08x res=%08x mask=%b mul=%b div=%b", cycles, {dut.rr_pc1, 2'b00}, dut.rr_rob_index1, `EX.valid1, `EX.instr1_rs1_data, `EX.instr1_rs2_data, `EX.internal_alu_result1, dut.rr_branch_mask1, `EX.is_mul1, `EX.is_div1);
            if (dut.rr_valid2) $display("%0d EX2  pc=%08x rob=%0d valid=%b a=%08x b=%08x res=%08x mask=%b mul=%b div=%b", cycles, {dut.rr_pc2, 2'b00}, dut.rr_rob_index2, `EX.valid2, `EX.instr2_rs1_data, `EX.instr2_rs2_data, `EX.internal_alu_result2, dut.rr_branch_mask2, `EX.is_mul2, `EX.is_div2);
            if (dut.cdb_branch_resolved) $display("%0d BR   tag=%0d rob=%0d flush=%b taken=%b next=%08x pred_taken=%b pred_target=%08x", cycles, dut.cdb_branch_tag, dut.cdb_branch_rob_index, dut.ex_flush, dut.ex_actual_taken, dut.ex_redirect_pc, dut.id_biq_pred_taken, dut.id_biq_pred_target);
            if (dut.cdb1_valid) $display("%0d CDB1 rob=%0d prd=%0d data=%08x", cycles, dut.cdb1_rob_index, dut.cdb1_prd, dut.cdb1_result);
            if (dut.cdb2_valid) $display("%0d CDB2 rob=%0d prd=%0d data=%08x", cycles, dut.cdb2_rob_index, dut.cdb2_prd, dut.cdb2_result);
            if (dut.rob_global_flush) $display("%0d GLOBAL FLUSH pc=%08x", cycles, {dut.rob_flush_pc, 2'b00});
            if (dut.commit_instr1) $display("%0d COM1 pc=%08x", cycles, {`ROB.ROB[`ROB.head_idx].pc, 2'b00});
            if (dut.commit_instr2) $display("%0d COM2 pc=%08x", cycles, {`ROB.ROB[`ROB.head_plus_1_idx].pc, 2'b00});
            $display("%0d MD   mul: state=%b busy=%b out=%b  div: state=%0d busy=%b out=%b mask=%b  stall_issue=%b", cycles, `MUL_STATE, dut.cdb_mul_busy, dut.ex_mul_valid, `EX.div_inst.state, dut.cdb_div_busy, dut.ex_div_valid, `EX.div_inst.saved_branch_mask, dut.stall_issue);
        end
    end

    always @(posedge CLK) begin
        if (!reset && !done) begin
            cycles <= cycles + 1;

            if (dut.commit_instr1) begin
                $fdisplay(fd, "C %08x %0d %08x %0d", {`ROB.ROB[`ROB.head_idx].pc, 2'b00}, dut.comm_rd1, `PRF[dut.comm_prd1], cycles);
                commits = commits + 1;
                last_commit_cycle = cycles;
            end
            if (dut.commit_instr2) begin
                $fdisplay(fd, "C %08x %0d %08x %0d", {`ROB.ROB[`ROB.head_plus_1_idx].pc, 2'b00}, dut.comm_rd2, `PRF[dut.comm_prd2], cycles);
                commits = commits + 1;
                last_commit_cycle = cycles;
            end
            if (dut.ex_flush)         mispredicts = mispredicts + 1;
            if (dut.rob_global_flush) violations = violations + 1;

            if (dut.lsq_mem_write) begin
                $fdisplay(fd, "M %08x %08x %0d %0d", dut.lsq_memory_address, dut.lsq_mem_write_data, dut.lsq_mem_size, cycles);
                if (dut.lsq_memory_address == tohost) begin
                    done <= 1;
                    // stores leave the store queue in program order, so everything before this one is in memory
                    if ($value$plusargs("SIG=%s", sig_file) && $value$plusargs("SIG_BEGIN=%h", sig_begin) && $value$plusargs("SIG_END=%h", sig_end)) begin
                        sig_fd = $fopen(sig_file, "w");
                        for (logic [31:0] a = sig_begin; a < sig_end; a = a + 4) begin
                            $fdisplay(sig_fd, "%02x%02x%02x%02x",
                                      dut.mem_stage_inst.dm_instantiation.RAM[a[$clog2(MEM_WORDS)+1:2]][3], dut.mem_stage_inst.dm_instantiation.RAM[a[$clog2(MEM_WORDS)+1:2]][2],
                                      dut.mem_stage_inst.dm_instantiation.RAM[a[$clog2(MEM_WORDS)+1:2]][1], dut.mem_stage_inst.dm_instantiation.RAM[a[$clog2(MEM_WORDS)+1:2]][0]);
                        end
                        $fclose(sig_fd);
                    end
                    finish_sim("DONE");
                end
            end

            if (cycles - last_commit_cycle > 5000) begin
                dump_state();
                finish_sim("HANG");
            end
            if (cycles > max_cycles) begin
                finish_sim("TIMEOUT");
            end
        end
    end
endmodule
