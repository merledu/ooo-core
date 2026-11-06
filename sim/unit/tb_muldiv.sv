// Unit test of MUL_Unit, MUL_DSP and DIV_Unit: random and corner case operands for all 8 RV32M operations,
// results compared with a 64 bit reference model. Also checks the flush of a wrong path operation.
// The whole test runs twice: with the radix-4 Booth multiplier (MUL_Unit) and with the pipelined one (MUL_DSP).
module tb_muldiv;
    logic CLK = 0, reset = 1;
    always #1 CLK = ~CLK;

    logic flush = 0, rob_global_flush = 0, cdb_branch_resolved = 0, cdb_branch_correct = 0;
    logic [1:0] cdb_branch_tag = 0;
    logic [3:0] branch_mask = 0;
    logic [31:0] rs1, rs2;
    logic [4:0] op;
    logic [5:0] prd, rob;

    logic mul_valid = 0, mul_ack, mul_busy, mul_done;
    logic [31:0] mul_result;
    logic [5:0] mul_prd, mul_rob;
    logic div_valid = 0, div_ack, div_busy, div_done;
    logic [31:0] div_result;
    logic [5:0] div_prd, div_rob;

    // phase 1: results are taken immediately, phase 2: the CDB is randomly busy
    logic backpressure = 0, cdb_free = 1;
    always @(negedge CLK) cdb_free = !backpressure || ($urandom_range(3) == 0);
    assign mul_ack = mul_done && cdb_free;
    assign div_ack = div_done && cdb_free;

    // the multiplier under test (use_dsp) gets the operations, its outputs drive the checks
    logic use_dsp = 0;
    logic booth_busy, booth_done, dsp_busy, dsp_done;
    logic [31:0] booth_result, dsp_result;
    logic [5:0] booth_prd, booth_rob, dsp_prd, dsp_rob;
    assign mul_busy   = use_dsp ? dsp_busy   : booth_busy;
    assign mul_done   = use_dsp ? dsp_done   : booth_done;
    assign mul_result = use_dsp ? dsp_result : booth_result;
    assign mul_prd    = use_dsp ? dsp_prd    : booth_prd;
    assign mul_rob    = use_dsp ? dsp_rob    : booth_rob;

    MUL_Unit mul (.CLK(CLK), .reset(reset), .flush(flush), .valid(mul_valid && !use_dsp), .rob_global_flush(rob_global_flush),
                  .cdb_branch_tag(cdb_branch_tag), .rr_branch_mask(branch_mask), .cdb_branch_resolved(cdb_branch_resolved),
                  .cdb_branch_correct(cdb_branch_correct), .mul_ack(mul_ack && !use_dsp), .rs1_data(rs1), .rs2_data(rs2),
                  .alu_operation(op), .rr_prd(prd), .rr_rob_index(rob), .cdb_mul_busy(booth_busy),
                  .cdb_write_data(booth_done), .cdb_alu_result(booth_result), .cdb_prd(booth_prd), .cdb_rob_index(booth_rob));

    MUL_DSP mul_dsp (.CLK(CLK), .reset(reset), .flush(flush), .valid(mul_valid && use_dsp), .rob_global_flush(rob_global_flush),
                  .cdb_branch_tag(cdb_branch_tag), .rr_branch_mask(branch_mask), .cdb_branch_resolved(cdb_branch_resolved),
                  .cdb_branch_correct(cdb_branch_correct), .mul_ack(mul_ack && use_dsp), .rs1_data(rs1), .rs2_data(rs2),
                  .alu_operation(op), .rr_prd(prd), .rr_rob_index(rob), .cdb_mul_busy(dsp_busy),
                  .cdb_write_data(dsp_done), .cdb_alu_result(dsp_result), .cdb_prd(dsp_prd), .cdb_rob_index(dsp_rob));

    DIV_Unit div (.CLK(CLK), .reset(reset), .flush(flush), .valid(div_valid), .rob_global_flush(rob_global_flush),
                  .cdb_branch_tag(cdb_branch_tag), .rr_branch_mask(branch_mask), .cdb_branch_resolved(cdb_branch_resolved),
                  .cdb_branch_correct(cdb_branch_correct), .div_ack(div_ack), .rs1_data(rs1), .rs2_data(rs2),
                  .alu_operation(op), .rr_prd(prd), .rr_rob_index(rob), .cdb_div_busy(div_busy),
                  .cdb_write_data(div_done), .cdb_alu_result(div_result), .cdb_prd(div_prd), .cdb_rob_index(div_rob));

    // alu_operation encodings produced by ALUCU
    localparam logic [4:0] MUL = 5'b10000, MULH = 5'b10001, MULHSU = 5'b10010, MULHU = 5'b10011,
                           DIV = 5'b10100, DIVU = 5'b10101, REM = 5'b11010, REMU = 5'b11011;

    function automatic logic [31:0] model(input logic [4:0] o, input logic [31:0] a, input logic [31:0] b);
        logic signed [63:0] sa, sb;
        logic [63:0] ua, ub, p;
        sa = {{32{a[31]}}, a}; sb = {{32{b[31]}}, b};
        ua = {32'b0, a};       ub = {32'b0, b};
        case (o)
            MUL:    begin p = sa * sb; return p[31:0]; end
            MULH:   begin p = sa * sb; return p[63:32]; end
            MULHSU: begin p = sa * $signed(ub); return p[63:32]; end
            MULHU:  begin p = ua * ub; return p[63:32]; end
            DIV:    if (b == 0) return 32'hFFFFFFFF;
                    else if (a == 32'h80000000 && b == 32'hFFFFFFFF) return 32'h80000000;
                    else return $signed(a) / $signed(b);
            DIVU:   return (b == 0) ? 32'hFFFFFFFF : a / b;
            REM:    if (b == 0) return a;
                    else if (a == 32'h80000000 && b == 32'hFFFFFFFF) return 32'h0;
                    else return $signed(a) % $signed(b);
            default: return (b == 0) ? a : a % b;
        endcase
    endfunction

    int errors = 0, tests = 0;
    logic [31:0] corner [12] = '{32'h0, 32'h1, 32'hFFFFFFFF, 32'h80000000, 32'h7FFFFFFF, 32'h2, 32'hFFFFFFFE,
                                 32'h55555555, 32'hAAAAAAAA, 32'h0000FFFF, 32'h00010000, 32'h80000001};
    logic [4:0] ops [8] = '{MUL, MULH, MULHSU, MULHU, DIV, DIVU, REM, REMU};

    task automatic run_op(input logic [4:0] o, input logic [31:0] a, input logic [31:0] b);
        logic is_mul;
        logic [31:0] got, expected;
        int timeout;
        is_mul = (o[4:2] == 3'b100);
        @(negedge CLK);
        rs1 = a; rs2 = b; op = o; prd = $urandom; rob = $urandom; branch_mask = 0;
        if (is_mul) mul_valid = 1; else div_valid = 1;
        @(negedge CLK);
        mul_valid = 0; div_valid = 0;
        rs1 = $urandom; rs2 = $urandom; op = $urandom;   // inputs are only valid for one cycle
        timeout = 0;
        while (!(is_mul ? mul_done : div_done) && timeout < 100) begin
            @(negedge CLK);
            timeout++;
        end
        got = is_mul ? mul_result : div_result;
        expected = model(o, a, b);
        tests++;
        if (timeout >= 100 || got !== expected) begin
            errors++;
            if (errors < 20) $display("FAIL op=%b a=%h b=%h got=%h expected=%h%s", o, a, b, got, expected, (timeout >= 100) ? " (timeout)" : "");
        end
        @(negedge CLK);   // result is acknowledged
    endtask

    task automatic stress(input logic is_mul, input int count);
        logic [31:0] expected [$];
        logic [5:0] expected_prd [$];
        logic [1:0] inflight;
        logic [4:0] o, o_d;
        logic [31:0] a, b, a_d, b_d;
        logic [5:0] p, p_d;
        int issued, received, idle;
        issued = 0; received = 0; inflight = 0; idle = 0;
        while (received < count && idle < 2000) begin
            @(negedge CLK);
            // result taken by the CDB in the previous cycle is checked here (sampled before the edge below)
            mul_valid = 0; div_valid = 0;
            // operation issued 2 cycles ago arrives at the unit
            if (inflight[1]) begin
                rs1 = a_d; rs2 = b_d; op = o_d; prd = p_d; rob = p_d; branch_mask = 0;
                if (is_mul) mul_valid = 1; else div_valid = 1;
            end
            a_d = a; b_d = b; o_d = o; p_d = p;
            if (issued < count && !(is_mul ? mul_busy : div_busy) && inflight == 0) begin
                o = is_mul ? ops[$urandom_range(3)] : ops[4 + $urandom_range(3)];
                a = ($urandom_range(3) == 0) ? corner[$urandom_range(11)] : $urandom;
                b = ($urandom_range(2) == 0) ? corner[$urandom_range(11)] : $urandom;   // many divisions by zero (fast path)
                p = issued[5:0];
                expected.push_back(model(o, a, b));
                expected_prd.push_back(p);
                inflight = 2'b01;
                issued++;
            end
            else begin
                inflight = {inflight[0], 1'b0};
            end
            @(posedge CLK);
            idle++;
            if (is_mul ? mul_ack : div_ack) begin
                idle = 0;
                received++;
                tests++;
                if (expected.size() == 0 || (is_mul ? mul_result : div_result) !== expected[0] || (is_mul ? mul_prd : div_prd) !== expected_prd[0]) begin
                    errors++;
                    if (errors < 20) $display("FAIL back pressure (%s): result %0d got=%h prd=%0d expected=%h prd=%0d", is_mul ? "mul" : "div", received,
                                              is_mul ? mul_result : div_result, is_mul ? mul_prd : div_prd, expected[0], expected_prd[0]);
                end
                if (expected.size() != 0) begin
                    void'(expected.pop_front());
                    void'(expected_prd.pop_front());
                end
            end
        end
        if (received < count) begin
            errors++;
            $display("FAIL back pressure (%s): only %0d of %0d results", is_mul ? "mul" : "div", received, count);
        end
    endtask

    task automatic run_all();
        foreach (ops[o]) foreach (corner[i]) foreach (corner[j]) run_op(ops[o], corner[i], corner[j]);
        repeat (4000) run_op(ops[$urandom_range(7)], $urandom, $urandom);
        repeat (1000) run_op(ops[$urandom_range(7)], $urandom >> $urandom_range(31), $urandom >> $urandom_range(31));

        // an operation of a mispredicted path is dropped and the unit is free again
        @(negedge CLK);
        rs1 = 32'd100; rs2 = 32'd7; op = DIV; prd = 6'd9; rob = 6'd9; branch_mask = 4'b0100;
        div_valid = 1; mul_valid = 1;
        @(negedge CLK);
        div_valid = 0; mul_valid = 0;
        // the pipelined multiplier is done after 3 cycles: flush it while the operation is inside
        repeat (use_dsp ? 1 : 3) @(negedge CLK);
        flush = 1; cdb_branch_resolved = 1; cdb_branch_tag = 2'd2;
        @(negedge CLK);
        flush = 0; cdb_branch_resolved = 0;
        repeat (40) begin
            @(negedge CLK);
            if (mul_done || div_done) begin
                errors++;
                $display("FAIL flushed operation produced a result");
            end
        end
        tests++;
        if (mul_busy || div_busy) begin
            errors++;
            $display("FAIL unit still busy after flush");
        end
        run_op(MUL, 32'd6, 32'd7);
        run_op(REM, 32'd100, 32'd7);

        // back pressure: operations are issued like the issue queue does it (2 cycles from issue to the unit,
        // nothing is issued while the unit is busy or an operation is on its way) and the CDB is busy most of the time.
        // No result may be lost or overwritten.
        backpressure = 1;
        stress(1, 1500);
        stress(0, 1500);
        backpressure = 0;

    endtask

    initial begin
        repeat (3) @(negedge CLK);
        reset = 0;
        run_all();
        use_dsp = 1;
        run_all();

        if (errors == 0) $display("PASS tb_muldiv (%0d operations)", tests);
        else             $display("FAIL tb_muldiv: %0d errors in %0d operations", errors, tests);
        $finish;
    end

    // watchdog
    initial begin
        #5000000;
        $display("FAIL tb_muldiv: timeout");
        $finish;
    end
endmodule
