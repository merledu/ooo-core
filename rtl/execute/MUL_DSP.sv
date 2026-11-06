// Pipelined multiplier for FPGA (mapped to DSP48 blocks): same ports and protocol as MUL_Unit.
//
//   EX: operands -> s1 (operand registers) -> s2 (product register) -> s3 (output register, waits for the CDB)
//
// The result is on the CDB 3 cycles after the operation arrives (MUL_Unit: ~18 cycles). Every stage moves
// only when the next one is free, so a result waiting for the CDB stops the stages behind it.
// The issue queue sends a new multiplication only when cdb_mul_busy is low and none is on its way
// (2 cycles from issue to this unit), so an arriving operation always finds s1 free when busy = all stages full.
module MUL_DSP #(
    parameter XLEN = 32,
    parameter PRF_ADDRESS = 6,
    parameter ROB_PTR_SIZE = 6,
    parameter MAX_BRANCHES = 4,
    parameter BTAG_SIZE = $clog2(MAX_BRANCHES)
) (
    input  logic CLK, reset, flush, valid, rob_global_flush,
    input  logic [BTAG_SIZE-1:0] cdb_branch_tag,
    input  logic [MAX_BRANCHES-1:0] rr_branch_mask,
    input  logic cdb_branch_resolved,
    input  logic cdb_branch_correct,

    input  logic mul_ack,

    input  logic [XLEN-1:0] rs1_data,
    input  logic [XLEN-1:0] rs2_data,
    input  logic [4:0] alu_operation,      // lower 2 bits: 00 mul, 01 mulh, 10 mulhsu, 11 mulhu
    input  logic [PRF_ADDRESS-1:0]  rr_prd,
    input  logic [ROB_PTR_SIZE-1:0] rr_rob_index,

    output logic cdb_mul_busy,
    output logic cdb_write_data,
    output logic [XLEN-1:0] cdb_alu_result,
    output logic [PRF_ADDRESS-1:0]  cdb_prd,
    output logic [ROB_PTR_SIZE-1:0] cdb_rob_index
);

    typedef struct packed {
        logic                    valid;
        logic                    high;          // result is bits [63:32] of the product
        logic [MAX_BRANCHES-1:0] branch_mask;
        logic [PRF_ADDRESS-1:0]  prd;
        logic [ROB_PTR_SIZE-1:0] rob_index;
    } mul_tag_t;

    mul_tag_t s1, s2, s3;
    logic signed [32:0] s1_a, s1_b;            // operands extended to 33 bits (signed or unsigned)
    logic signed [65:0] s2_p, s3_p;

    logic [MAX_BRANCHES-1:0] resolved_tag_bit;
    assign resolved_tag_bit = (cdb_branch_resolved) ? (MAX_BRANCHES'(1) << cdb_branch_tag) : '0;

    // a stage moves forward when the next one is free or moves forward itself
    logic s3_free, s2_free, s1_free, move2, move3;
    assign s3_free = !s3.valid || mul_ack;
    assign move3   = s2.valid && s3_free;
    assign s2_free = !s2.valid || move3;
    assign move2   = s1.valid && s2_free;
    assign s1_free = !s1.valid || move2;

    // operation of a mispredicted path: dropped wherever it is
    function automatic mul_tag_t update_tag(input mul_tag_t t);
        mul_tag_t r;
        r = t;
        if (flush && t.branch_mask[cdb_branch_tag]) r.valid = 1'b0;
        r.branch_mask = t.branch_mask & ~resolved_tag_bit;
        return r;
    endfunction

    logic rs1_signed, rs2_signed;
    assign rs1_signed = (alu_operation[1:0] != 2'b11);
    assign rs2_signed = (alu_operation[1:0] == 2'b00 || alu_operation[1:0] == 2'b01);

    always_ff @(posedge CLK) begin
        if (reset || rob_global_flush) begin
            s1.valid <= 1'b0;
            s2.valid <= 1'b0;
            s3.valid <= 1'b0;
        end
        else begin
            // s3: output register
            if (move3)        s3 <= update_tag(s2);
            else if (mul_ack) s3.valid <= 1'b0;
            else              s3 <= update_tag(s3);

            // s2: product
            if (move2)        s2 <= update_tag(s1);
            else if (move3)   s2.valid <= 1'b0;
            else              s2 <= update_tag(s2);

            // s1: operands
            if (valid && s1_free) begin
                s1.valid       <= !(flush && rr_branch_mask[cdb_branch_tag]);
                s1.high        <= (alu_operation[1:0] != 2'b00);
                s1.branch_mask <= rr_branch_mask & ~resolved_tag_bit;
                s1.prd         <= rr_prd;
                s1.rob_index   <= rr_rob_index;
            end
            else if (move2)   s1.valid <= 1'b0;
            else              s1 <= update_tag(s1);
        end
    end

    // data path without reset, so that the registers can be placed inside the DSP blocks
    always_ff @(posedge CLK) begin
        if (valid && s1_free) begin
            s1_a <= {rs1_signed & rs1_data[31], rs1_data};
            s1_b <= {rs2_signed & rs2_data[31], rs2_data};
        end
        if (move2) s2_p <= s1_a * s1_b;
        if (move3) s3_p <= s2_p;
    end

    assign cdb_mul_busy   = s1.valid && s2.valid && s3.valid;
    assign cdb_write_data = s3.valid;
    assign cdb_prd        = s3.prd;
    assign cdb_rob_index  = s3.rob_index;
    assign cdb_alu_result = (s3.high) ? s3_p[63:32] : s3_p[31:0];

endmodule
