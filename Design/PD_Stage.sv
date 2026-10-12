module PD_Stage #(
    parameter PHT_ADDRESS = 9,
    parameter GHR_SIZE = 9,
    parameter XLEN = 32,
    parameter RAS_ADDRESS = 3,
    parameter RESET_PC = 32'h0
)(
    input logic CLK, reset, stall_frontend, flush, rob_global_flush,
    //branch resolution from EX stage
    input logic ex_actual_taken, update_pht, ex_is_branch, ex_btb_update, ex_btb_slot,
    input logic [XLEN-1:0] ex_actual_target_address, ex_redirect_pc, ex_fetch_pc,
    input logic [GHR_SIZE-1:0] ghr_snap,
    input logic [PHT_ADDRESS-1:0] rb_pht_index,
    input logic [RAS_ADDRESS-1:0] rb_sp_snap,
    input logic [2*XLEN-1:0] rb_ras_snap,
    input logic [XLEN-3:0] rob_flush_pc,
    //bundle currently in IF stage
    input logic if_valid1, if_valid2, if_pred_taken, if_pred_slot,
    input logic [1:0] if_predecode_instr1, if_predecode_instr2,
    input logic if_predecode_direct1, if_predecode_direct2,
    input logic [XLEN-1:0] if_jal_target1, if_jal_target2, if_pred_target,
    input logic [XLEN-3:0] if_pc,

    //prediction of the bundle in PD stage (BTB + PHT)
    output logic pd_pred_taken, pd_pred_slot, if_redirect,
    output logic [XLEN-1:0] pd_pc, pd_pred_target,
    output logic [PHT_ADDRESS-1:0] pd_pht_index,
    output logic [GHR_SIZE-1:0] pd_prev_ghr,
    //final prediction of the bundle in IF stage (BTB + PHT + jal target + RAS)
    output logic fin_pred_taken, fin_pred_slot, fin_valid2,
    output logic [XLEN-1:0] fin_pred_target,
    //RAS state to restore if the 1st / 2nd instruction of the bundle is mispredicted
    output logic [RAS_ADDRESS-1:0] fin_sp_snap1, fin_sp_snap2,
    output logic [2*XLEN-1:0] fin_ras_snap1, fin_ras_snap2
);

    logic [GHR_SIZE-1:0] ghr_out, prev_ghr;
    logic [PHT_ADDRESS-1:0] pht_index;
    logic pred_taken, btb_hit, btb_is_branch, btb_slot;
    logic [XLEN-1:0] pred_return_address, pred_target_address;
    logic [RAS_ADDRESS-1:0] sp_snap_pre, sp_snap_post;
    logic [2*XLEN-1:0] ras_snap_pre, ras_snap_post;
    logic [XLEN-1:0] next_pc;
    logic read_en, if_advance;

    //a flush redirects the pc even when the frontend is stalled
    assign read_en    = !stall_frontend || flush || rob_global_flush;
    //the bundle in IF stage moves to ID stage
    assign if_advance = !stall_frontend && !flush && !rob_global_flush;

    // ---------------------------------------------------------------------
    // Prediction of the bundle in PD stage: BTB and PHT are read with next_pc,
    // so their outputs belong to the bundle whose pc is pd_pc.
    // ---------------------------------------------------------------------
    assign pht_index      = ghr_out ^ next_pc[PHT_ADDRESS+1:2];
    assign pd_pred_taken  = btb_hit && (!btb_is_branch || pred_taken);
    assign pd_pred_slot   = btb_slot;
    assign pd_pred_target = pred_target_address;

    always_ff @(posedge CLK) begin
        if (read_en) begin
            pd_pht_index <= pht_index;
            pd_prev_ghr  <= prev_ghr;
        end
    end

    // ---------------------------------------------------------------------
    // Prediction of the bundle in IF stage: the instructions are known now, so
    // jal (target computed in IF stage) and ret (target from RAS) which were
    // not predicted by the BTB redirect the pc from here.
    // ---------------------------------------------------------------------
    logic if_is_ret1, if_is_ret2, if_is_call1, if_is_call2;
    logic pd_taken1, pd_taken2, late_taken1, late_taken2, slot2_live;
    logic [XLEN-1:0] late_target1, late_target2;
    logic ras_op, ras_op_slot, ras_push, ras_pop;

    assign if_is_ret1  = (if_predecode_instr1 == 2'b01);
    assign if_is_ret2  = (if_predecode_instr2 == 2'b01);
    assign if_is_call1 = (if_predecode_instr1 == 2'b10);
    assign if_is_call2 = (if_predecode_instr2 == 2'b10);

    always_comb begin
        pd_taken1 = if_pred_taken && !if_pred_slot;
        pd_taken2 = if_pred_taken && if_pred_slot;

        //1st instruction of bundle
        late_taken1  = if_valid1 && !pd_taken1 && (if_predecode_direct1 || if_is_ret1);
        late_target1 = (if_predecode_direct1) ? if_jal_target1 : pred_return_address;

        //2nd instruction of bundle is only executed if the 1st one is not taken
        slot2_live   = if_valid2 && !pd_taken1 && !late_taken1;
        late_taken2  = slot2_live && !pd_taken2 && (if_predecode_direct2 || if_is_ret2);
        late_target2 = (if_predecode_direct2) ? if_jal_target2 : pred_return_address;

        if_redirect  = late_taken1 || late_taken2;

        fin_pred_taken = if_pred_taken || late_taken1 || late_taken2;
        fin_pred_slot  = !(pd_taken1 || late_taken1);
        fin_valid2     = if_valid2 && !late_taken1;
        if (pd_taken1)        fin_pred_target = if_pred_target;
        else if (late_taken1) fin_pred_target = late_target1;
        else if (pd_taken2)   fin_pred_target = if_pred_target;
        else                  fin_pred_target = late_target2;

        //only one push/pop per bundle, 1st instruction has the priority
        if (if_valid1 && (if_is_call1 || if_is_ret1)) begin
            ras_op      = 1;
            ras_op_slot = 0;
            ras_push    = if_is_call1;
            ras_pop     = if_is_ret1;
        end
        else if (slot2_live && (if_is_call2 || if_is_ret2)) begin
            ras_op      = 1;
            ras_op_slot = 1;
            ras_push    = if_is_call2;
            ras_pop     = if_is_ret2;
        end
        else begin
            ras_op      = 0;
            ras_op_slot = 0;
            ras_push    = 0;
            ras_pop     = 0;
        end

    end

    //a mispredicted 1st instruction must not keep the push/pop done by the 2nd instruction
    assign fin_sp_snap1  = (ras_op && !ras_op_slot) ? sp_snap_post  : sp_snap_pre;
    assign fin_ras_snap1 = (ras_op && !ras_op_slot) ? ras_snap_post : ras_snap_pre;
    assign fin_sp_snap2  = sp_snap_post;
    assign fin_ras_snap2 = ras_snap_post;

    GHR #(
        .GHR_SIZE           (GHR_SIZE)
    ) ghr_instantiation(
        //inputs
        .CLK                (CLK),
        .reset              (reset),
        .ex_is_branch       (ex_is_branch),
        .restore_ghr        (flush),
        .ex_actual_taken    (ex_actual_taken),
        .ghr_snap           (ghr_snap),
        //conditional branch predicted by the BTB/PHT in PD stage
        .spec_update        (if_advance && !if_redirect && btb_hit && btb_is_branch),
        .spec_taken         (pd_pred_taken),
        //outputs
        .ghr_out            (ghr_out),
        .prev_ghr           (prev_ghr)
    );

    PC #(
        .XLEN                       (XLEN),
        .RESET_PC                   (RESET_PC)
    ) pc_instantiation (
        //inputs
        .CLK                        (CLK),
        .reset                      (reset),
        .flush                      (flush),
        .rob_global_flush           (rob_global_flush),
        .stall_frontend             (stall_frontend),
        .if_redirect                (if_redirect),
        .if_redirect_target         (fin_pred_target),
        .pd_pred_taken              (pd_pred_taken),
        .pd_pred_target             (pd_pred_target),
        .ex_redirect_pc             (ex_redirect_pc),
        .rob_flush_pc               (rob_flush_pc),
        //outputs
        .next_pc                    (next_pc),
        .pc                         (pd_pc)
    );

    PHT #(
        .PHT_ADDRESS        (PHT_ADDRESS)
    ) pht_instantiation (
        //inputs
        .CLK                (CLK),
        .reset              (reset),
        .read_en            (read_en),
        .ex_actual_taken    (ex_actual_taken),
        .update_pht         (update_pht),
        .pht_index          (pht_index),
        .rb_pht_index       (rb_pht_index),
        //outputs
        .pred_taken         (pred_taken)
    );

    BTB #(
        .XLEN                    (XLEN)
    ) btb_instantiation (
        //inputs
        .CLK                     (CLK),
        .reset                   (reset),
        .read_en                 (read_en),
        .read_pc                 (next_pc),

        //jal found in fetch stage which the BTB did not know
        .if_write                (if_advance && ((late_taken1 && if_predecode_direct1) || (late_taken2 && if_predecode_direct2))),
        .if_slot                 (!late_taken1),
        .if_pc                   ({if_pc, 2'b00}),
        .if_target_address       (fin_pred_target[XLEN-1:2]),

        .ex_write                (ex_btb_update),
        .ex_slot                 (ex_btb_slot),
        .ex_is_branch            (ex_is_branch),
        .ex_pc                   (ex_fetch_pc),
        .ex_target_address       (ex_actual_target_address[XLEN-1:2]),

        //outputs
        .btb_hit                 (btb_hit),
        .btb_is_branch           (btb_is_branch),
        .btb_slot                (btb_slot),
        .pred_target_address     (pred_target_address)
    );

    RAS #(
        .RAS_ADDRESS                (RAS_ADDRESS),
        .XLEN                       (XLEN)
    ) ras_instantiation (
        //inputs
        .CLK                        (CLK),
        .reset                      (reset),
        .restore_ras                (flush),
        .rb_sp_snap                 (rb_sp_snap),
        .rb_ras_snap                (rb_ras_snap),
        .push                       (ras_push),
        .pop                        (ras_pop),
        .update_en                  (if_advance),
        //return address = pc of the call + 4
        .if_actual_return_address   ({if_pc, 2'b00} + ((ras_op_slot) ? 32'd8 : 32'd4)),
        //outputs
        .pred_return_address        (pred_return_address),
        .sp_snap_pre                (sp_snap_pre),
        .sp_snap_post               (sp_snap_post),
        .ras_snap_pre               (ras_snap_pre),
        .ras_snap_post              (ras_snap_post)
    );

endmodule
