module main_datapath #(
    parameter XLEN                = 32,
    parameter OPCODE_SIZE         = 7,
    parameter PHT_ADDRESS         = 9,
    parameter GHR_SIZE            = 9,
    parameter RAS_ADDRESS         = 3,
    parameter INIT_IMMEDIATE_SIZE = 21,
    parameter BIQ_ADDRESS         = 5
) (
    // -----------------------------------------
    // Global Control Signals
    // -----------------------------------------
    input  logic CLK, 
    input  logic reset, 
    input  logic flush,
    
    // -----------------------------------------
    // Backend Predictor Updates (From Execute/Commit)
    // -----------------------------------------
    input  logic actual_taken, 
    input  logic mispredict, 
    input  logic restore_ghr, 
    input  logic restore_ras, 
    input  logic update_pht, 
    input  logic update_btb, 
    input  logic update_ras, 
    input  logic ex_is_ret, 
    input  logic ex_is_branch,
    input  logic [XLEN-1:0] actual_target_address, 
    input  logic [XLEN-1:0] ex_pc,
    input  logic [GHR_SIZE-1:0] ghr_snap,
    input  logic [PHT_ADDRESS-1:0] rb_pht_index,
    input  logic [RAS_ADDRESS-1:0] rb_sp_snap,
    input  logic [2*XLEN-1:0] rb_ras_snap,

    // -----------------------------------------
    // Dispatch & Register Read Inputs
    // -----------------------------------------
    input  logic dis_biq_dealloc,
    input  logic [BIQ_ADDRESS-1:0] rr_biq_id,
    input  logic rr_slot_id,

    // -----------------------------------------
    // Outputs to Rename / Dispatch Stage
    // -----------------------------------------
    output logic stall_frontend,     // Tells the rest of the CPU the Frontend is full
    output logic id_valid1, 
    output logic id_valid2,
    output logic [XLEN-3:0] id_pc,   // Note: Word-aligned PC
    output logic id_take_snap,
    
    // Slot 1 Decoded Outputs
    output logic [2:0] id_funct3_1, id_alu_op1,
    output logic [6:0] id_funct7_1,
    output logic [4:0] id_rs1_1, id_rs2_1, id_rd_1,
    
    output logic [INIT_IMMEDIATE_SIZE-1:0] id_immout1,
    output logic id_jump_reg1, id_jump1, id_branch1, id_regsrc1_1, id_regsrc2_1, 
    output logic id_immtype1, id_memwrite1, id_regwrite1, id_memtoreg1, id_retaddr1, id_isimm1, id_upperimm1,

    // Slot 2 Decoded Outputs
    output logic [2:0] id_funct3_2, id_alu_op2,
    output logic [6:0] id_funct7_2,
    output logic [4:0] id_rs1_2, id_rs2_2, id_rd_2,
    
    output logic [INIT_IMMEDIATE_SIZE-1:0] id_immout2,
    output logic id_jump_reg2, id_jump2, id_branch2, id_regsrc1_2, id_regsrc2_2, 
    output logic id_immtype2, id_memwrite2, id_regwrite2, id_memtoreg2, id_retaddr2, id_isimm2, id_upperimm2,

    // -----------------------------------------
    // Outputs to ROB / Execute Stage (BIQ Metadata)
    // -----------------------------------------
    output logic [BIQ_ADDRESS-1:0] id_biq_address,
    output logic id_biq_valid,
    output logic id_biq_pred_taken,
    output logic [XLEN-1:0] id_biq_pred_target, 
    output logic [PHT_ADDRESS-1:0] id_biq_pht_index,
    output logic [GHR_SIZE-1:0] id_biq_restore_ghr, 
    output logic [RAS_ADDRESS-1:0] id_biq_sp_snap,
    output logic [2*XLEN-1:0] id_biq_ras_snap
);

    // ============================================================================
    // INTERNAL WIRES (PIPELINE CONNECTIONS)
    // ============================================================================
    
    // Wire: Speculative Return Address Logic
    logic [XLEN-1:0] spec_return_address;
    // Wires: PD_Stage -> IF_Stage
    logic pd_valid1, pd_valid2;
    logic [XLEN-1:0] pd_pc, pd_pred_target1, pd_pred_target2;
    logic pd_pred_taken1, pd_pred_taken2, pd_btb_hit1, pd_btb_hit2;
    logic [PHT_ADDRESS-1:0] pd_pht_index1, pd_pht_index2;
    logic [RAS_ADDRESS-1:0] pd_sp_snap;
    logic [2*XLEN-1:0] pd_ras_snap;
    logic [GHR_SIZE-1:0] pd_prev_ghr;

    // Wires: IF_Stage -> ID_Stage
    logic if_valid1, if_valid2;
    logic [XLEN-3:0] if_pc;
    logic [XLEN-1:0] if_instr1, if_instr2, if_pred_target1, if_pred_target2;
    logic if_pred_taken1, if_pred_taken2, if_btb_hit1, if_btb_hit2;
    logic [PHT_ADDRESS-1:0] if_pht_index1, if_pht_index2;
    logic [RAS_ADDRESS-1:0] if_sp_snap;
    logic [2*XLEN-1:0] if_ras_snap;
    logic [GHR_SIZE-1:0] if_prev_ghr;

    // ============================================================================
    // COMBINATIONAL LOGIC: SPECULATIVE RAS RETURN ADDRESS
    // ============================================================================
    // Convert word-aligned PC back to full 32-bit address
    
    // If the jump is in Slot 1, return to PC+4. If in Slot 2, return to PC+8.
    // (We prioritize Slot 1. If Slot 1 jumps, Slot 2 is dead anyway).
    assign spec_return_address = (id_jump1) ? ({id_pc,2'b00} + 32'd4) : ({id_pc,2'b00} + 32'd8);


    // ============================================================================
    // MODULE INSTANTIATIONS
    // ============================================================================

    PD_Stage #(
        .PHT_ADDRESS             (PHT_ADDRESS),
        .GHR_SIZE                (GHR_SIZE),
        .XLEN                    (XLEN),
        .RAS_ADDRESS             (RAS_ADDRESS)
    ) pd_stage_inst (
        .CLK                     (CLK),
        .reset                   (reset),
        .stall_frontend          (stall_frontend), // Sourced from ID_Stage output
        
        .actual_taken            (actual_taken),
        .update_pht              (update_pht),
        .update_btb              (update_btb),
        .update_ras              (update_ras),
        .ex_is_ret               (ex_is_ret),
        .ex_is_branch            (ex_is_branch),
        .ex_pc                   (ex_pc),
        .actual_target_address   (actual_target_address),
        .actual_return_address   (spec_return_address), // CONNECTED: Speculative ID logic!
        
        .mispredict              (mispredict),
        .restore_ghr             (restore_ghr),
        .restore_ras             (restore_ras),
        .ghr_snap                (ghr_snap),
        .rb_pht_index            (rb_pht_index),
        .rb_sp_snap              (rb_sp_snap),
        .rb_ras_snap             (rb_ras_snap),

        .pd_valid1               (pd_valid1),
        .pd_valid2               (pd_valid2),
        .pd_pc                   (pd_pc),
        .pd_pred_taken1          (pd_pred_taken1),
        .pd_pred_taken2          (pd_pred_taken2),
        .pd_btb_hit1             (pd_btb_hit1),
        .pd_btb_hit2             (pd_btb_hit2),
        .pd_pred_target1         (pd_pred_target1),
        .pd_pred_target2         (pd_pred_target2),
        .pd_pht_index1           (pd_pht_index1),
        .pd_pht_index2           (pd_pht_index2),
        .pd_sp_snap              (pd_sp_snap),
        .pd_ras_snap             (pd_ras_snap),
        .pd_prev_ghr             (pd_prev_ghr)
    );
    
    IF_Stage #(
        .PHT_ADDRESS             (PHT_ADDRESS),
        .GHR_SIZE                (GHR_SIZE),
        .XLEN                    (XLEN),
        .RAS_ADDRESS             (RAS_ADDRESS)
    ) if_stage_inst (
        .CLK                     (CLK),
        .reset                   (reset),
        .flush                   (flush),
        .stall_frontend          (stall_frontend), // Sourced from ID_Stage output
        
        .pd_valid1               (pd_valid1),
        .pd_valid2               (pd_valid2),
        .pd_pc                   (pd_pc),
        .pd_pred_taken1          (pd_pred_taken1),
        .pd_pred_taken2          (pd_pred_taken2),
        .pd_btb_hit1             (pd_btb_hit1),
        .pd_btb_hit2             (pd_btb_hit2),
        .pd_pred_target1         (pd_pred_target1),
        .pd_pred_target2         (pd_pred_target2),
        .pd_pht_index1           (pd_pht_index1),
        .pd_pht_index2           (pd_pht_index2),
        .pd_sp_snap              (pd_sp_snap),
        .pd_ras_snap             (pd_ras_snap),
        .pd_prev_ghr             (pd_prev_ghr),

        .if_valid1               (if_valid1),
        .if_valid2               (if_valid2),
        .if_pc                   (if_pc),
        .if_instr1               (if_instr1),
        .if_instr2               (if_instr2),
        .if_pred_taken1          (if_pred_taken1),
        .if_pred_taken2          (if_pred_taken2),
        .if_btb_hit1             (if_btb_hit1),
        .if_btb_hit2             (if_btb_hit2),
        .if_pred_target1         (if_pred_target1),
        .if_pred_target2         (if_pred_target2),
        .if_pht_index1           (if_pht_index1),
        .if_pht_index2           (if_pht_index2),
        .if_sp_snap              (if_sp_snap),
        .if_ras_snap             (if_ras_snap),
        .if_prev_ghr             (if_prev_ghr)
    );

    ID_Stage #(
        .OPCODE_SIZE             (OPCODE_SIZE),
        .PHT_ADDRESS             (PHT_ADDRESS),
        .GHR_SIZE                (GHR_SIZE),
        .XLEN                    (XLEN),
        .RAS_ADDRESS             (RAS_ADDRESS),
        .INIT_IMMEDIATE_SIZE     (INIT_IMMEDIATE_SIZE),
        .BIQ_ADDRESS             (BIQ_ADDRESS)
    ) id_stage_inst (
        .CLK                     (CLK),
        .reset                   (reset),
        .flush                   (flush),
        
        .if_valid1               (if_valid1),
        .if_valid2               (if_valid2),
        .if_instr1               (if_instr1),
        .if_instr2               (if_instr2),
        .if_pc                   (if_pc),
        .if_pred_taken1          (if_pred_taken1),
        .if_pred_taken2          (if_pred_taken2),
        .if_btb_hit1             (if_btb_hit1),
        .if_btb_hit2             (if_btb_hit2),
        .if_pred_target1         (if_pred_target1),
        .if_pred_target2         (if_pred_target2),
        .if_pht_index1           (if_pht_index1),
        .if_pht_index2           (if_pht_index2),
        .if_sp_snap              (if_sp_snap),
        .if_ras_snap             (if_ras_snap),
        .if_prev_ghr             (if_prev_ghr),

        .dis_biq_dealloc         (dis_biq_dealloc),
        .rr_biq_id               (rr_biq_id),
        .rr_slot_id              (rr_slot_id),

        .stall_frontend          (stall_frontend), // Loops back to PD and IF stages
        .id_take_snap            (id_take_snap),

        .id_valid1               (id_valid1),
        .id_valid2               (id_valid2),
        .id_pc                   (id_pc),
        
        .id_funct3_1             (id_funct3_1),
        .id_funct7_1             (id_funct7_1),
        .id_rs1_1                (id_rs1_1), 
        .id_rs2_1                (id_rs2_1), 
        .id_rd_1                 (id_rd_1),
        .id_immout1              (id_immout1),
        .id_alu_op1              (id_alu_op1),
        .id_jump_reg1            (id_jump_reg1),
        .id_jump1                (id_jump1),
        .id_branch1              (id_branch1),
        .id_regsrc1_1            (id_regsrc1_1),
        .id_regsrc2_1            (id_regsrc2_1),
        .id_immtype1             (id_immtype1),
        .id_memwrite1            (id_memwrite1),
        .id_regwrite1            (id_regwrite1),
        .id_memtoreg1            (id_memtoreg1),
        .id_retaddr1             (id_retaddr1),
        .id_isimm1               (id_isimm1),
        .id_upperimm1            (id_upperimm1),
        
        .id_funct3_2             (id_funct3_2),
        .id_funct7_2             (id_funct7_2),

        .id_rs1_2                (id_rs1_2), 
        .id_rs2_2                (id_rs2_2), 
        .id_rd_2                 (id_rd_2),

        .id_immout2              (id_immout2),
        .id_alu_op2              (id_alu_op2),
        .id_jump_reg2            (id_jump_reg2),
        .id_jump2                (id_jump2),
        .id_branch2              (id_branch2),
        .id_regsrc1_2            (id_regsrc1_2),
        .id_regsrc2_2            (id_regsrc2_2),
        .id_immtype2             (id_immtype2),
        .id_memwrite2            (id_memwrite2),
        .id_regwrite2            (id_regwrite2),
        .id_memtoreg2            (id_memtoreg2),
        .id_retaddr2             (id_retaddr2),
        .id_isimm2               (id_isimm2),
        .id_upperimm2            (id_upperimm2),

        .id_biq_address          (id_biq_address),
        .id_biq_valid            (id_biq_valid),
        .id_biq_pred_taken       (id_biq_pred_taken),
        .id_biq_pred_target      (id_biq_pred_target),
        .id_biq_pht_index        (id_biq_pht_index),
        .id_biq_restore_ghr      (id_biq_restore_ghr),
        .id_biq_sp_snap          (id_biq_sp_snap),
        .id_biq_ras_snap         (id_biq_ras_snap)
    );

endmodule