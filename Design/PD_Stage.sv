module PD_Stage #(
    parameter PHT_ADDRESS = 9,
    parameter GHR_SIZE = 9,
    parameter XLEN = 32,
    parameter RAS_ADDRESS = 3
)(
    input logic CLK, reset, stall_frontend, ex_actual_taken, restore_ghr, restore_ras, update_pht, 
    input logic ex_is_jalr, ex_is_ret, ex_is_branch, flush, //flush = flush(from ex)
    input logic [1:0] if_predecode_instr1, if_predecode_instr2,
    input logic [XLEN-1:0] ex_actual_target_address, if_target_address, if_pc, ex_pc,
    input logic [GHR_SIZE-1:0] ghr_snap,
    input logic [PHT_ADDRESS-1:0] rb_pht_index,
    input logic [RAS_ADDRESS-1:0] rb_sp_snap,
    input logic [2*XLEN-1:0] rb_ras_snap,

    output logic pd_pred_taken, pd_btb_hit, pd_valid1, pd_valid2,
    output logic [XLEN-1:0] pd_pc, pd_pred_target,
    output logic [PHT_ADDRESS-1:0] pd_pht_index,
    output logic [RAS_ADDRESS-1:0] pd_sp_snap,
    output logic [2*XLEN-1:0] pd_ras_snap,
    output logic [GHR_SIZE-1:0] pd_prev_ghr
);

    logic [GHR_SIZE-1:0] ghr_out, prev_ghr;
    logic [PHT_ADDRESS-1:0] pht_index;
    logic pred_taken, btb_hit,btb_is_branch, is_return_instr, squash_instruction;
    logic [XLEN-1:0] pred_return_address, pred_target_address;
    logic [RAS_ADDRESS-1:0] sp_snap;
    logic [2*XLEN-1:0] ras_snap;
    logic [XLEN-1:0] next_pc;

    assign pht_index = ghr_out ^ next_pc[PHT_ADDRESS+1:2];
    assign pd_pred_taken = btb_hit && pred_taken && btb_is_branch;
    assign pd_pred_target = (is_return_instr)? pred_return_address : pred_target_address;
    assign pd_pc = next_pc;
    assign pd_btb_hit = btb_hit;
    assign pd_sp_snap = sp_snap;
    assign pd_ras_snap = ras_snap;
    
    always_ff @(posedge CLK) begin 
        if (reset) begin
            pd_valid1 <= 0;
            pd_valid2 <= 0;
        end
        else if (!stall_frontend) begin
            pd_valid1 <= !flush;
            pd_valid2 <= !flush && squash_instruction;
            pd_pht_index <= pht_index;
            pd_prev_ghr <= prev_ghr;
        end
    end
    GHR ghr_instantiation(
        //inputs 
        .CLK                (CLK),
        .reset              (reset),
        .stall_frontend     (stall_frontend),
        .ex_is_branch       (ex_is_branch),
        .restore_ghr        (restore_ghr),
        .ex_actual_taken    (ex_actual_taken),
        .ghr_snap           (ghr_snap),
        //outputs
        .ghr_out            (ghr_out),
        .prev_ghr           (prev_ghr)
    );
    
    PC pc_instantiation (
        //inputs
        .CLK                        (CLK),
        .reset                      (reset),
        .flush                      (flush),
        .stall_frontend             (stall_frontend),
        .ras_target_address         (pred_return_address), 
        .btb_target_address         (pred_target_address),
        .ex_actual_target_address   (ex_actual_target_address),
        .is_return_instr            (is_return_instr),
        .btb_hit                    (btb_hit),
        .pht_pred_taken             (pred_taken), 
        .btb_is_branch              (btb_is_branch),
        //outputs
        .next_pc                    (next_pc)
        
    );

    PHT pht_instantiation (
        //inputs
        .CLK                (CLK),
        .reset              (reset),
        .ex_actual_taken    (ex_actual_taken),
        .update_pht         (update_pht),
        .pht_index          (pht_index),
        .rb_pht_index       (rb_pht_index),
        //outputs
        .pred_taken         (pred_taken)
    );

    BTB btb_instantiation (
        //inputs
        .CLK                     (CLK),
        .reset                   (reset),
        .if_is_jal1              (if_predecode_instr1 == 2'b11),
        .if_is_jal2              (if_predecode_instr2 == 2'b11),

        .ex_is_not_ret           (~ex_is_ret),
        .ex_is_taken_branch      (ex_actual_taken),
        .ex_is_jalr              (ex_is_jalr),

        .pd_pc                   (pd_pc),
        .if_pc                   (if_pc),
        .ex_pc                   (ex_pc),

        .ex_target_address       (ex_actual_target_address),
        .if_target_address       (if_target_address),
        

        //outputs
        .btb_hit                 (btb_hit),
        .btb_is_branch           (btb_is_branch),
        .squash_instruction      (squash_instruction),
        .pred_target_address     (pred_target_address)
    );

    RAS ras_instantiation (
        //inputs
        .CLK                        (CLK),
        .reset                      (reset),
        
        .stall_frontend             (stall_frontend),
        .restore_ras                (restore_ras),

        .rb_sp_snap                 (rb_sp_snap),
        .rb_ras_snap                (rb_ras_snap),

        .if_predecode_instr1        (if_predecode_instr1),
        .if_predecode_instr2        (if_predecode_instr2),

        .if_actual_return_address   (if_target_address),
        //outputs
        .pred_return_address        (pred_return_address),
        .is_return_instr            (is_return_instr),
        .sp_snap                    (sp_snap),
        .ras_snap                   (ras_snap)
    );

endmodule