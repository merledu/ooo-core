module main_datapath #(
    parameter XLEN                = 32,
    parameter OPCODE_SIZE         = 7,
    parameter PHT_ADDRESS         = 9,
    parameter GHR_SIZE            = 9,
    parameter RAS_ADDRESS         = 3,
    parameter INIT_IMMEDIATE_SIZE = 21,
    parameter BIQ_ADDRESS         = 5,
    parameter PRF_ADDRESS         = 6,
    parameter MAX_BRANCHES        = 4,
    parameter BTAG_SIZE           = $clog2(MAX_BRANCHES)
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
    input  logic actual_taken, mispredict, restore_ghr, restore_ras, update_pht, 
    input  logic update_btb, update_ras, ex_is_ret, ex_is_branch,
    input  logic [XLEN-1:0] actual_target_address, ex_pc,
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
    // Backend/Execution Signals for Rename Stage
    // -----------------------------------------
    input  logic cdb_wakeup1, cdb_wakeup2, comm_free_push1, comm_free_push2, ex_branch_resolved,
    input  logic [PRF_ADDRESS-1:0] cdb_waked_reg1, cdb_waked_reg2, comm_free_reg1, comm_free_reg2,
    input  logic [BTAG_SIZE-1:0] ex_btag,

    // -----------------------------------------
    // Outputs to Dispatch / Issue Stages
    // -----------------------------------------
    output logic stall_frontend,     // Tells the rest of the CPU the Frontend is full
    
    // Physical Register Mappings
    output logic [PRF_ADDRESS-1:0] rn_prd1, rn_prs1_1, rn_prs2_1, rn_old_prd1, 
    output logic [PRF_ADDRESS-1:0] rn_prd2, rn_prs1_2, rn_prs2_2, rn_old_prd2,             
    output logic rn_prs1_busy1, rn_prs2_busy1, rn_prs1_busy2, rn_prs2_busy2,
    
    // Branch Tracking
    output logic [BTAG_SIZE-1:0] rn_branch_tag,
    output logic [MAX_BRANCHES-1:0] rn_branch_mask,

    // Slot 1 Renamed Outputs
    output logic rn_valid1, rn_jump_reg1, rn_jump1, rn_branch1, 
    output logic rn_regsrc1_1, rn_regsrc2_1, rn_immtype1, rn_isimm1, rn_retaddr1,
    output logic rn_upperimm1, rn_regwrite1, rn_memwrite1, rn_memtoreg1, 
    output logic [2:0] rn_funct3_1, rn_alu_op1,
    output logic [6:0] rn_funct7_1,
    output logic [INIT_IMMEDIATE_SIZE-1:0] rn_immout1,
    
    // Slot 2 Renamed Outputs
    output logic rn_valid2, rn_jump_reg2, rn_jump2, rn_branch2, 
    output logic rn_regsrc1_2, rn_regsrc2_2, rn_immtype2, rn_isimm2, rn_retaddr2,
    output logic rn_upperimm2, rn_regwrite2, rn_memwrite2, rn_memtoreg2,
    output logic [2:0] rn_funct3_2, rn_alu_op2,
    output logic [6:0] rn_funct7_2,
    output logic [INIT_IMMEDIATE_SIZE-1:0] rn_immout2,

    // Shared / Metadata
    output logic [BIQ_ADDRESS-1:0] rn_biq_address,
    output logic [XLEN-3:0] rn_pc,

    // -----------------------------------------
    // Outputs to ROB / Execute Stage (BIQ Metadata)
    // -----------------------------------------
    output logic id_biq_valid,
    output logic id_biq_pred_taken,
    output logic [XLEN-1:0] id_biq_pred_target, 
    output logic [PHT_ADDRESS-1:0] id_biq_pht_index,
    output logic [GHR_SIZE-1:0] id_biq_restore_ghr, 
    output logic [RAS_ADDRESS-1:0] id_biq_sp_snap,
    output logic [2*XLEN-1:0] id_biq_ras_snap
);

    // ============================================================================
    // INTERNAL WIRES
    // ============================================================================
    logic id_stall_frontend, rn_stall_frontend;
    assign stall_frontend = id_stall_frontend | rn_stall_frontend;

    logic [XLEN-1:0] spec_return_address;
    
    // PD/IF Signals... (Omitted declarations for brevity, assuming they match your previous code)
    logic pd_valid1, pd_valid2;
    logic [XLEN-1:0] pd_pc, pd_pred_target1, pd_pred_target2;
    logic pd_pred_taken1, pd_pred_taken2, pd_btb_hit1, pd_btb_hit2;
    logic [PHT_ADDRESS-1:0] pd_pht_index1, pd_pht_index2;
    logic [RAS_ADDRESS-1:0] pd_sp_snap;
    logic [2*XLEN-1:0] pd_ras_snap;
    logic [GHR_SIZE-1:0] pd_prev_ghr;

    logic if_valid1, if_valid2;
    logic [XLEN-3:0] if_pc;
    logic [XLEN-1:0] if_instr1, if_instr2, if_pred_target1, if_pred_target2;
    logic if_pred_taken1, if_pred_taken2, if_btb_hit1, if_btb_hit2;
    logic [PHT_ADDRESS-1:0] if_pht_index1, if_pht_index2;
    logic [RAS_ADDRESS-1:0] if_sp_snap;
    logic [2*XLEN-1:0] if_ras_snap;
    logic [GHR_SIZE-1:0] if_prev_ghr;

    // Decode -> Rename Wires
    logic id_take_snap, id_valid1, id_valid2;
    logic [XLEN-3:0] id_pc;
    logic [BIQ_ADDRESS-1:0] id_biq_address;
    
    logic [2:0] id_funct3_1, id_alu_op1; logic [6:0] id_funct7_1; logic [4:0] id_rs1_1, id_rs2_1, id_rd_1;
    logic id_jump_reg1, id_jump1, id_branch1, id_regsrc1_1, id_regsrc2_1, id_immtype1, id_memwrite1, id_regwrite1, id_memtoreg1, id_retaddr1, id_isimm1, id_upperimm1;
    logic [INIT_IMMEDIATE_SIZE-1:0] id_immout1;

    logic [2:0] id_funct3_2, id_alu_op2; logic [6:0] id_funct7_2; logic [4:0] id_rs1_2, id_rs2_2, id_rd_2;
    logic id_jump_reg2, id_jump2, id_branch2, id_regsrc1_2, id_regsrc2_2, id_immtype2, id_memwrite2, id_regwrite2, id_memtoreg2, id_retaddr2, id_isimm2, id_upperimm2;
    logic [INIT_IMMEDIATE_SIZE-1:0] id_immout2;

    assign spec_return_address = (id_jump1) ? ({id_pc,2'b00} + 32'd4) : ({id_pc,2'b00} + 32'd8);

    // ============================================================================
    // MODULE INSTANTIATIONS
    // ============================================================================

    PD_Stage #(
        .PHT_ADDRESS            (9),
        .GHR_SIZE               (9),
        .XLEN                   (32),
        .RAS_ADDRESS            (3)
    ) pd_stage_inst (
        // Inputs
        .CLK                     (CLK),
        .reset                   (reset),
        .stall_frontend          (stall_frontend),
        .ex_actual_taken         (actual_taken),
        .restore_ghr             (restore_ghr),
        .restore_ras             (restore_ras),
        .update_pht              (update_pht),
        .ex_is_jalr              (/* connect to top-level ex_is_jalr */), 
        .ex_is_ret               (ex_is_ret),
        .ex_is_branch            (ex_is_branch),
        .mispredict              (mispredict),
        .if_predecode_instr1     (/* connect to top-level if_predecode_instr1 */),
        .if_predecode_instr2     (/* connect to top-level if_predecode_instr2 */),
        .ex_actual_target_address(actual_target_address),
        .if_target_address       (/* connect to top-level if_target_address */),
        .if_pc                   (pd_pc), // Assuming pd_pc maps to if_pc, adjust if needed
        .ex_pc                   (ex_pc),
        .ghr_snap                (ghr_snap),
        .rb_pht_index            (rb_pht_index),
        .rb_sp_snap              (rb_sp_snap),
        .rb_ras_snap             (rb_ras_snap),

        // Outputs
        .pd_pred_taken           (pd_pred_taken1), // Verify if this maps to channel 1 or combined
        .pd_btb_hit              (pd_btb_hit1),    // Verify if this maps to channel 1 or combined
        .pd_valid1               (pd_valid1),
        .pd_valid2               (pd_valid2),
        .pd_pc                   (pd_pc),
        .pd_pred_target          (pd_pred_target1), // Verify if this maps to channel 1 or combined
        .pd_pht_index            (pd_pht_index1),   // Verify if this maps to channel 1 or combined
        .pd_sp_snap              (pd_sp_snap),
        .pd_ras_snap             (pd_ras_snap),
        .pd_prev_ghr             (pd_prev_ghr)
    );
    
    IF_Stage #( /* ... Parameters ... */ ) if_stage_inst (
        .CLK                     (CLK),
        .reset                   (reset),
        .flush                   (flush),
        .stall_frontend          (stall_frontend), // Uses COMBINED stall
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

    ID_Stage #( /* ... Parameters ... */ ) id_stage_inst (
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
        .stall_frontend          (id_stall_frontend), // Dedicated ID stall
        .id_take_snap            (id_take_snap),
        .id_valid1               (id_valid1),
        .id_valid2               (id_valid2),
        .id_pc                   (id_pc),
        .id_funct3_1             (id_funct3_1), .id_funct7_1(id_funct7_1), .id_rs1_1(id_rs1_1), .id_rs2_1(id_rs2_1), .id_rd_1(id_rd_1),
        .id_immout1              (id_immout1), .id_alu_op1(id_alu_op1), .id_jump_reg1(id_jump_reg1), .id_jump1(id_jump1), .id_branch1(id_branch1),
        .id_regsrc1_1            (id_regsrc1_1), .id_regsrc2_1(id_regsrc2_1), .id_immtype1(id_immtype1), .id_memwrite1(id_memwrite1), .id_regwrite1(id_regwrite1),
        .id_memtoreg1            (id_memtoreg1), .id_retaddr1(id_retaddr1), .id_isimm1(id_isimm1), .id_upperimm1(id_upperimm1),
        .id_funct3_2             (id_funct3_2), .id_funct7_2(id_funct7_2), .id_rs1_2(id_rs1_2), .id_rs2_2(id_rs2_2), .id_rd_2(id_rd_2),
        .id_immout2              (id_immout2), .id_alu_op2(id_alu_op2), .id_jump_reg2(id_jump_reg2), .id_jump2(id_jump2), .id_branch2(id_branch2),
        .id_regsrc1_2            (id_regsrc1_2), .id_regsrc2_2(id_regsrc2_2), .id_immtype2(id_immtype2), .id_memwrite2(id_memwrite2), .id_regwrite2(id_regwrite2),
        .id_memtoreg2            (id_memtoreg2), .id_retaddr2(id_retaddr2), .id_isimm2(id_isimm2), .id_upperimm2(id_upperimm2),
        .id_biq_address          (id_biq_address), .id_biq_valid(id_biq_valid), .id_biq_pred_taken(id_biq_pred_taken), .id_biq_pred_target(id_biq_pred_target),
        .id_biq_pht_index        (id_biq_pht_index), .id_biq_restore_ghr(id_biq_restore_ghr), .id_biq_sp_snap(id_biq_sp_snap), .id_biq_ras_snap(id_biq_ras_snap)
    );

    RN_Stage #(
        .PRF_ADDRESS             (PRF_ADDRESS),
        .INIT_IMMEDIATE_SIZE     (INIT_IMMEDIATE_SIZE),
        .MAX_BRANCHES            (MAX_BRANCHES),
        .BIQ_ADDRESS             (BIQ_ADDRESS),
        .XLEN                    (XLEN)
    ) rn_stage_inst (
        .CLK                     (CLK),
        .reset                   (reset),
        .flush                   (flush),
        
        .id_take_snap            (id_take_snap), 
        .id_valid1               (id_valid1), 
        .id_valid2               (id_valid2),
        
        .cdb_wakeup1             (cdb_wakeup1), 
        .cdb_wakeup2             (cdb_wakeup2), 
        .comm_free_push1         (comm_free_push1), 
        .comm_free_push2         (comm_free_push2), 
        .ex_branch_resolved      (ex_branch_resolved),
        .cdb_waked_reg1          (cdb_waked_reg1), 
        .cdb_waked_reg2          (cdb_waked_reg2), 
        .comm_free_reg1          (comm_free_reg1), 
        .comm_free_reg2          (comm_free_reg2),
        .ex_btag                 (ex_btag),
        
        // Decode logic inputs
        .id_funct3_1             (id_funct3_1), .id_funct3_2(id_funct3_2),
        .id_funct7_1             (id_funct7_1), .id_funct7_2(id_funct7_2),
        .id_rs1_1                (id_rs1_1), .id_rs2_1(id_rs2_1), .id_rd_1(id_rd_1),
        .id_rs1_2                (id_rs1_2), .id_rs2_2(id_rs2_2), .id_rd_2(id_rd_2),
        .id_immout1              (id_immout1), .id_immout2(id_immout2),
        .id_biq_address          (id_biq_address),
        .id_pc                   (id_pc),
        .id_alu_op1              (id_alu_op1), .id_alu_op2(id_alu_op2),
        .id_jump_reg1            (id_jump_reg1), .id_jump_reg2(id_jump_reg2), 
        .id_jump1                (id_jump1), .id_jump2(id_jump2), 
        .id_branch1              (id_branch1), .id_branch2(id_branch2), 
        .id_regsrc1_1            (id_regsrc1_1), .id_immtype1(id_immtype1), .id_memwrite1(id_memwrite1),  
        .id_immtype2             (id_immtype2), .id_regsrc2_1(id_regsrc2_1),
        .id_regsrc1_2            (id_regsrc1_2), .id_regsrc2_2(id_regsrc2_2), 
        .id_upperimm1            (id_upperimm1), .id_upperimm2(id_upperimm2), 
        .id_regwrite1            (id_regwrite1), .id_regwrite2(id_regwrite2), 
        .id_memwrite2            (id_memwrite2), .id_memtoreg1(id_memtoreg1), .id_memtoreg2(id_memtoreg2), 
        .id_retaddr1             (id_retaddr1), .id_retaddr2(id_retaddr2), 
        .id_isimm1               (id_isimm1), .id_isimm2(id_isimm2),
        
        .stall_frontend          (rn_stall_frontend), // Dedicated RN stall

        // Renamed outputs mapped directly to main_datapath outputs
        .rn_prd1                 (rn_prd1), .rn_prs1_1(rn_prs1_1), .rn_prs2_1(rn_prs2_1), .rn_old_prd1(rn_old_prd1),
        .rn_prd2                 (rn_prd2), .rn_prs1_2(rn_prs1_2), .rn_prs2_2(rn_prs2_2), .rn_old_prd2(rn_old_prd2),             
        .rn_prs1_busy1           (rn_prs1_busy1), .rn_prs2_busy1(rn_prs2_busy1), .rn_prs1_busy2(rn_prs1_busy2), .rn_prs2_busy2(rn_prs2_busy2),
        .rn_branch_tag           (rn_branch_tag),
        .rn_branch_mask          (rn_branch_mask),
        .rn_biq_address          (rn_biq_address),
        .rn_pc                   (rn_pc),
        .rn_funct3_1             (rn_funct3_1), .rn_funct3_2(rn_funct3_2),
        .rn_funct7_1             (rn_funct7_1), .rn_funct7_2(rn_funct7_2),
        .rn_immout1              (rn_immout1), .rn_immout2(rn_immout2),
        .rn_alu_op1              (rn_alu_op1), .rn_alu_op2(rn_alu_op2),
        
        .rn_valid1               (rn_valid1), .rn_jump_reg1(rn_jump_reg1), .rn_jump1(rn_jump1), .rn_branch1(rn_branch1), 
        .rn_regsrc1_1            (rn_regsrc1_1), .rn_regsrc2_1(rn_regsrc2_1), .rn_immtype1(rn_immtype1), .rn_isimm1(rn_isimm1), .rn_retaddr1(rn_retaddr1),
        .rn_upperimm1            (rn_upperimm1), .rn_regwrite1(rn_regwrite1), .rn_memwrite1(rn_memwrite1), .rn_memtoreg1(rn_memtoreg1), 

        .rn_valid2               (rn_valid2), .rn_jump_reg2(rn_jump_reg2), .rn_jump2(rn_jump2), .rn_branch2(rn_branch2), 
        .rn_regsrc1_2            (rn_regsrc1_2), .rn_regsrc2_2(rn_regsrc2_2), .rn_immtype2(rn_immtype2), .rn_isimm2(rn_isimm2), .rn_retaddr2(rn_retaddr2),
        .rn_upperimm2            (rn_upperimm2), .rn_regwrite2(rn_regwrite2), .rn_memwrite2(rn_memwrite2), .rn_memtoreg2(rn_memtoreg2)
    );

endmodule