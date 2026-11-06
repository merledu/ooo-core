// Unit test of CDB_Arbiter: all 32 combinations of requests.
// - an ALU result is always broadcasted on its own lane
// - every acknowledged request is on exactly one lane with its own data, nothing is broadcasted twice
// - LSQ > MUL > DIV priority for the free lanes
// - stall_issue only when a request is left waiting for the 2nd cycle in a row (STALL_DELAY = 1)
module tb_cdb_arbiter;
    logic CLK = 0, reset = 1;
    logic alu1_valid, alu2_valid, lsq_valid, mul_valid, div_valid;
    logic cdb1_valid, cdb2_valid, lsq_ack, mul_ack, div_ack, stall_issue;
    logic [31:0] cdb1_result, cdb2_result;
    logic [5:0] cdb1_prd, cdb2_prd, cdb1_rob_index, cdb2_rob_index;

    // each source has its own recognisable data: result = id, prd = id, rob = id
    CDB_Arbiter dut (
        .CLK(CLK), .reset(reset),
        .alu1_valid(alu1_valid), .alu1_result(32'd1), .alu1_prd(6'd1), .alu1_rob_index(6'd1),
        .alu2_valid(alu2_valid), .alu2_result(32'd2), .alu2_prd(6'd2), .alu2_rob_index(6'd2),
        .lsq_valid(lsq_valid),   .lsq_result(32'd3),  .lsq_prd(6'd3),  .lsq_rob_index(6'd3),
        .mul_valid(mul_valid),   .mul_result(32'd4),  .mul_prd(6'd4),  .mul_rob_index(6'd4),
        .div_valid(div_valid),   .div_result(32'd5),  .div_prd(6'd5),  .div_rob_index(6'd5),
        .cdb1_valid(cdb1_valid), .cdb1_result(cdb1_result), .cdb1_prd(cdb1_prd), .cdb1_rob_index(cdb1_rob_index),
        .cdb2_valid(cdb2_valid), .cdb2_result(cdb2_result), .cdb2_prd(cdb2_prd), .cdb2_rob_index(cdb2_rob_index),
        .lsq_ack(lsq_ack), .mul_ack(mul_ack), .div_ack(div_ack), .stall_issue(stall_issue));

    int errors = 0;
    task automatic fail(input string msg, input int c);
        errors++;
        $display("FAIL requests=%05b: %s", c[4:0], msg);
    endtask

    function automatic int on_lanes(input int id);
        return ((cdb1_valid && cdb1_result == id) ? 1 : 0) + ((cdb2_valid && cdb2_result == id) ? 1 : 0);
    endfunction

    initial begin
        for (int c = 0; c < 32; c++) begin
            int free, served;
            logic left_waiting;
            // nothing was waiting before: the first cycle of a request never stalls
            {alu1_valid, alu2_valid, lsq_valid, mul_valid, div_valid} = '0;
            reset = 1; #1 CLK = 1; #1 CLK = 0; reset = 0;
            {alu1_valid, alu2_valid, lsq_valid, mul_valid, div_valid} = c[4:0];
            #1;
            if (stall_issue) fail("stall_issue in the first cycle of a request", c);
            // same requests in the next cycle: a request left waiting again stops the issue
            left_waiting = (lsq_valid && !lsq_ack) || (mul_valid && !mul_ack) || (div_valid && !div_ack);
            #1 CLK = 1; #1 CLK = 0;
            #1;
            if (cdb1_valid && (cdb1_prd != cdb1_result[5:0] || cdb1_rob_index != cdb1_result[5:0])) fail("lane 1 mixes data of two sources", c);
            if (cdb2_valid && (cdb2_prd != cdb2_result[5:0] || cdb2_rob_index != cdb2_result[5:0])) fail("lane 2 mixes data of two sources", c);
            if (on_lanes(1) != (alu1_valid ? 1 : 0)) fail("ALU1 not broadcasted exactly once", c);
            if (on_lanes(2) != (alu2_valid ? 1 : 0)) fail("ALU2 not broadcasted exactly once", c);
            if (on_lanes(3) != (lsq_ack ? 1 : 0)) fail("LSQ ack does not match the lanes", c);
            if (on_lanes(4) != (mul_ack ? 1 : 0)) fail("MUL ack does not match the lanes", c);
            if (on_lanes(5) != (div_ack ? 1 : 0)) fail("DIV ack does not match the lanes", c);
            if ((lsq_ack && !lsq_valid) || (mul_ack && !mul_valid) || (div_ack && !div_valid)) fail("ack without request", c);
            // free lanes go to LSQ, then MUL, then DIV
            free = 2 - (alu1_valid ? 1 : 0) - (alu2_valid ? 1 : 0);
            served = 0;
            if (lsq_valid) begin if ((served < free) != lsq_ack) fail("LSQ priority", c); if (lsq_ack) served++; end
            if (mul_valid) begin if ((served < free) != mul_ack) fail("MUL priority", c); if (mul_ack) served++; end
            if (div_valid) begin if ((served < free) != div_ack) fail("DIV priority", c); if (div_ack) served++; end
            if (stall_issue != left_waiting) fail("stall_issue in the second cycle", c);
        end
        if (errors == 0) $display("PASS tb_cdb_arbiter (32 request combinations)");
        else             $display("FAIL tb_cdb_arbiter: %0d errors", errors);
        $finish;
    end
endmodule
