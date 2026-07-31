module CDB_Arbiter #(
    parameter XLEN = 32,
    parameter PRF_ADDRESS = 6,
    parameter ROB_PTR_SIZE = 6
) (
    // Priority 1: ALU 1
    input logic alu1_valid,
    input logic [XLEN-1:0] alu1_result,
    input logic [PRF_ADDRESS-1:0] alu1_prd,
    input logic [ROB_PTR_SIZE-1:0] alu1_rob_index,

    // Priority 2: ALU 2
    input logic alu2_valid,
    input logic [XLEN-1:0] alu2_result,
    input logic [PRF_ADDRESS-1:0] alu2_prd,
    input logic [ROB_PTR_SIZE-1:0] alu2_rob_index,

    // Priority 3: LSQ (Loads)
    input logic lsq_valid,
    input logic [XLEN-1:0] lsq_result,
    input logic [PRF_ADDRESS-1:0] lsq_prd,
    input logic [ROB_PTR_SIZE-1:0] lsq_rob_index,

    // Priority 4: Multiplier
    input logic mul_valid,
    input logic [XLEN-1:0] mul_result,
    input logic [PRF_ADDRESS-1:0] mul_prd,
    input logic [ROB_PTR_SIZE-1:0] mul_rob_index,

    // Priority 5: Divider
    input logic div_valid,
    input logic [XLEN-1:0] div_result,
    input logic [PRF_ADDRESS-1:0] div_prd,
    input logic [ROB_PTR_SIZE-1:0] div_rob_index,

    // CDB Lane 1 Outputs
    output logic cdb1_valid,
    output logic [XLEN-1:0] cdb1_result,
    output logic [PRF_ADDRESS-1:0] cdb1_prd,
    output logic [ROB_PTR_SIZE-1:0] cdb1_rob_index,

    // CDB Lane 2 Outputs
    output logic cdb2_valid,
    output logic [XLEN-1:0] cdb2_result,
    output logic [PRF_ADDRESS-1:0] cdb2_prd,
    output logic [ROB_PTR_SIZE-1:0] cdb2_rob_index,

    // Control Signals (Handshakes & Backpressure)
    output logic lsq_ack,
    output logic mul_ack,
    output logic div_ack,
    output logic stall_issue
);

    always_comb begin
        cdb1_valid = 0; cdb1_result = '0; cdb1_prd = '0; cdb1_rob_index = '0;
        cdb2_valid = 0; cdb2_result = '0; cdb2_prd = '0; cdb2_rob_index = '0;
        lsq_ack = 0; mul_ack = 0; div_ack = 0; stall_issue = 0;
        
        // LANE 1
        if (alu1_valid) begin
            cdb1_valid = 1; cdb1_result = alu1_result; cdb1_prd = alu1_prd; cdb1_rob_index = alu1_rob_index;
        end 
        else if (lsq_valid) begin
            cdb1_valid = 1; cdb1_result = lsq_result; cdb1_prd = lsq_prd; cdb1_rob_index = lsq_rob_index;
            lsq_ack = 1; 
        end
        else if (mul_valid) begin
            cdb1_valid = 1; cdb1_result = mul_result; cdb1_prd = mul_prd; cdb1_rob_index = mul_rob_index;
            mul_ack = 1; 
        end
        else if (div_valid) begin
            cdb1_valid = 1; cdb1_result = div_result; cdb1_prd = div_prd; cdb1_rob_index = div_rob_index;
            div_ack = 1;
        end

        // LANE 2
        if (alu2_valid) begin
            cdb2_valid = 1; cdb2_result = alu2_result; cdb2_prd = alu2_prd; cdb2_rob_index = alu2_rob_index;
        end 
        else if (lsq_valid && !lsq_ack) begin 
            cdb2_valid = 1; cdb2_result = lsq_result; cdb2_prd = lsq_prd; cdb2_rob_index = lsq_rob_index;
            lsq_ack = 1;
        end
        else if (mul_valid && !mul_ack) begin
            cdb2_valid = 1; cdb2_result = mul_result; cdb2_prd = mul_prd; cdb2_rob_index = mul_rob_index;
            mul_ack = 1;
        end
        else if (div_valid && !div_ack) begin
            cdb2_valid = 1; cdb2_result = div_result; cdb2_prd = div_prd; cdb2_rob_index = div_rob_index;
            div_ack = 1;
        end
        
        // STALL LOGIC
        stall_issue = (lsq_valid && !lsq_ack) || (mul_valid && !mul_ack) || (div_valid && !div_ack);
    end
endmodule