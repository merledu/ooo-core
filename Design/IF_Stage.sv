module IF_Stage #(
    parameter PHT_ADDRESS = 9,
    parameter GHR_SIZE = 9,
    parameter XLEN = 32,
    parameter RAS_ADDRESS = 3
) (
    input logic CLK, reset, flush, pd_valid1, pd_valid2, stall_frontend,
    input logic pd_pred_taken, pd_btb_hit,
    input logic [XLEN-1:0] pd_pc, pd_pred_target,
    input logic [PHT_ADDRESS-1:0] pd_pht_index,
    input logic [RAS_ADDRESS-1:0] pd_sp_snap,
    input logic [2*XLEN-1:0] pd_ras_snap,
    input logic [GHR_SIZE-1:0] pd_prev_ghr,

    output logic if_pred_taken, if_btb_hit, if_valid1, if_valid2,
    output logic [1:0] if_predecode_instr1, if_predecode_instr2,
    output logic [XLEN-1:0] if_instr1, if_instr2, if_pred_target,
    output logic [XLEN-3:0] if_pc,
    output logic [PHT_ADDRESS-1:0] if_pht_index,
    output logic [RAS_ADDRESS-1:0] if_sp_snap,
    output logic [2*XLEN-1:0] if_ras_snap,
    output logic [GHR_SIZE-1:0] if_prev_ghr
);
    logic [XLEN-3:0] instr1_addr, instr2_addr;
    
    assign instr1_addr = pd_pc[XLEN-1:2];
    assign instr2_addr = pd_pc[XLEN-1:2] + 1;

    always_ff @(posedge CLK) begin
        if (reset) begin
            if_valid1 <= 0;
            if_valid2 <= 0;
        end
        else if(!stall_frontend) begin
            if_valid1 <= (!flush && pd_valid1);
            if_valid2 <= (!flush && pd_valid2);  
            if_pred_taken <= pd_pred_taken;
            if_btb_hit <= pd_btb_hit;
            if_pc <= pd_pc[XLEN-1:2];
            if_pred_target <= pd_pred_target;
            if_pht_index <= pd_pht_index;
            if_sp_snap <= pd_sp_snap;
            if_ras_snap <= pd_ras_snap;
            if_prev_ghr <= pd_prev_ghr;
        end
    end

    IM im_instantiation (
        .CLK            (CLK),
        .instr1_addr    ({2'b00, instr1_addr}),
        .instr2_addr    ({2'b00, instr2_addr}),
        .instr_1        (if_instr1),
        .instr_2        (if_instr2)
    );

    PreDecode predecode_instantiation(
        //input
        .opcode1            (if_instr1[6:0]),
        .opcode2            (if_instr2[6:0]),
        .rd1                (if_instr1[11:7]),
        .rd2                (if_instr2[11:7]),
        //output
        .predecode_instr1   (if_predecode_instr1),
        .predecode_instr2   (if_predecode_instr2)
    );

endmodule