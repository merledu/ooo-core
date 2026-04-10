module IF_Stage #(
    parameter PHT_ADDRESS = 9,
    parameter GHR_SIZE = 9,
    parameter XLEN = 32,
    parameter RAS_ADDRESS = 3
) (
    input logic CLK, reset,
    input logic pd_pred_taken1, pd_pred_taken2, pd_btb_hit1, pd_btb_hit2,
    input logic [XLEN-1:0] pd_pc, pd_pred_target1, pd_pred_target2,
    input logic [PHT_ADDRESS-1:0] pd_pht_index1, pd_pht_index2,
    input logic [RAS_ADDRESS-1:0] pd_sp_snap,
    input logic [2*XLEN-1:0] pd_ras_snap,
    input logic [GHR_SIZE-1:0] pd_prev_ghr,

    output logic if_pred_taken1, if_pred_taken2, if_btb_hit1, if_btb_hit2,
    output logic [XLEN-1:0] if_instr1, if_instr2, if_pred_target1, if_pred_target2,
    output logic [XLEN-3:0] if_pc,
    output logic [PHT_ADDRESS-1:0] if_pht_index1, if_pht_index2,
    output logic [RAS_ADDRESS-1:0] if_sp_snap,
    output logic [2*XLEN-1:0] if_ras_snap,
    output logic [GHR_SIZE-1:0] if_prev_ghr
);
    logic [XLEN-3:0] instr1_addr, instr2_addr;
    
    assign instr1_addr = pd_pc[XLEN-1:2];
    assign instr2_addr = pd_pc[XLEN-1:2] + 4;

    always_ff @(posedge CLK) begin
        if_pred_taken1 <= pd_pred_taken1;
        if_pred_taken2 <= pd_pred_taken2;
        if_btb_hit1 <= pd_btb_hit1;
        if_btb_hit2 <= pd_btb_hit2;
        if_pc <= instr1_addr;
        if_pred_target1 <= pd_pred_target1;
        if_pred_target2 <= pd_pred_target2;
        if_pht_index1 <= pd_pht_index1;
        if_pht_index2 <= pd_pht_index2;
        if_sp_snap <= pd_sp_snap;
        if_ras_snap <= pd_ras_snap;
        if_prev_ghr <= pd_prev_ghr;
    end

    InstructionMemory im_instantiation (
        .instr1_addr    (instr1_addr),
        .instr2_addr    (instr2_addr),
        .instr_1        (if_instr1),
        .instr_2        (if_instr2)
    );
endmodule