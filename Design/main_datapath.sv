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
    parameter BTAG_SIZE           = $clog2(MAX_BRANCHES),
    parameter ROB_SIZE            = 64,
    parameter ROB_PTR_SIZE        = $clog2(ROB_SIZE),
    parameter NUM_PHY_REG         = 1 << PRF_ADDRESS,
    parameter FL_ROWS             = NUM_PHY_REG - 32,
    parameter FL_INDEX_WIDTH      = $clog2(FL_ROWS),
    parameter FL_PTR_WIDTH        = FL_INDEX_WIDTH + 1
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
    input  logic update_btb, update_ras, ex_is_ret, ex_is_branch, ex_is_jalr,
    input  logic branch_mispredicted,
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
    // Backend/Execution Signals for Rename, Dispatch & RR Stages
    // -----------------------------------------
    input  logic cdb_done1, cdb_done2, cdb_wakeup1, cdb_wakeup2, 
    input  logic comm_free_push1, comm_free_push2, 
    input  logic cdb_branch_resolved, cdb_branch_correct,
    input  logic [PRF_ADDRESS-1:0] cdb_waked_reg1, cdb_waked_reg2, comm_free_reg1, comm_free_reg2,
    input  logic [BTAG_SIZE-1:0] cdb_branch_tag,
    input  logic [ROB_PTR_SIZE-1:0] cdb_rob_index1, cdb_rob_index2, cdb_branch_rob_index,
    
    // CDB Write/Bypass Inputs for RR_Stage
    input logic cdb_regwrite1, cdb_regwrite2,
    input logic [PRF_ADDRESS-1:0] cdb_write_address1, cdb_write_address2,
    input logic [XLEN-1:0] cdb_write_data1, cdb_write_data2,

    // -----------------------------------------
    // Outputs to Frontend / System
    // -----------------------------------------
    output logic stall_frontend,
    
    // -----------------------------------------
    // Outputs to ROB / Execute Stage (BIQ Metadata)
    // -----------------------------------------
    output logic id_biq_valid,
    output logic id_biq_pred_taken,
    output logic [XLEN-1:0] id_biq_pred_target, 
    output logic [PHT_ADDRESS-1:0] id_biq_pht_index,
    output logic [GHR_SIZE-1:0] id_biq_restore_ghr, 
    output logic [RAS_ADDRESS-1:0] id_biq_sp_snap,
    output logic [2*XLEN-1:0] id_biq_ras_snap,

    // -----------------------------------------
    // Commit Outputs (From Dispatch)
    // -----------------------------------------
    output logic commit_instr1, commit_instr2,
    output logic [PRF_ADDRESS-1:0] dis_free_old_prd1, dis_free_old_prd2,
    output logic [PRF_ADDRESS-1:0] comm_prd1, comm_prd2,
    output logic [4:0] comm_rd1, comm_rd2,

    // -----------------------------------------
    // Register Read Stage Outputs - Instruction 1
    // -----------------------------------------
    output logic [XLEN-1:0]                rr_instr1_read_data1, rr_instr1_read_data2,
    output logic                           rr_valid1, rr_is_m_extension1, rr_jump_reg1, rr_jump1, rr_branch1,
    output logic                           rr_instr1_regsrc1, rr_instr1_regsrc2, rr_isimm1, rr_retaddr1, rr_upperimm1,
    output logic                           rr_regwrite1, rr_memwrite1, rr_memtoreg1,
    output logic [XLEN-3:0]                rr_pc1,
    output logic [PRF_ADDRESS-1:0]         rr_prd1,
    output logic [XLEN-1:0]                rr_immediate1,
    output logic [4:0]                     rr_alu_operation1,
    output logic [BTAG_SIZE-1:0]           rr_branch_tag1,
    output logic [MAX_BRANCHES-1:0]        rr_branch_mask1,
    output logic [BIQ_ADDRESS-1:0]         rr_biq_address1,
    output logic [ROB_PTR_SIZE-1:0]        rr_rob_index1,

    // -----------------------------------------
    // Register Read Stage Outputs - Instruction 2
    // -----------------------------------------
    output logic [XLEN-1:0]                rr_instr2_read_data1, rr_instr2_read_data2,
    output logic                           rr_valid2, rr_is_m_extension2, rr_jump_reg2, rr_jump2, rr_branch2,
    output logic                           rr_instr2_regsrc1, rr_instr2_regsrc2, rr_isimm2, rr_retaddr2, rr_upperimm2,
    output logic                           rr_regwrite2, rr_memwrite2, rr_memtoreg2,
    output logic [XLEN-3:0]                rr_pc2,
    output logic [PRF_ADDRESS-1:0]         rr_prd2,
    output logic [XLEN-1:0]                rr_immediate2,
    output logic [4:0]                     rr_alu_operation2,
    output logic [BTAG_SIZE-1:0]           rr_branch_tag2,
    output logic [MAX_BRANCHES-1:0]        rr_branch_mask2,
    output logic [BIQ_ADDRESS-1:0]         rr_biq_address2,
    output logic [ROB_PTR_SIZE-1:0]        rr_rob_index2
);

    // ============================================================================
    // INTERNAL WIRES
    // ============================================================================
    logic id_stall_frontend, rn_stall_frontend, dis_stall_frontend;
    assign stall_frontend = id_stall_frontend | rn_stall_frontend | dis_stall_frontend;
    logic [1:0] if_predecode_instr1, if_predecode_instr2;
    logic [XLEN-1:0] if_target_address;
    logic [XLEN-1:0] spec_return_address;
    
    // PD/IF Signals
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
    
    logic [4:0] id_alu_operation1, id_alu_operation2;
    logic id_is_m_extension1, id_is_m_extension2;
    logic [4:0] id_rs1_1, id_rs2_1, id_rd_1, id_rs1_2, id_rs2_2, id_rd_2;
    
    logic id_jump_reg1, id_jump1, id_branch1, id_regsrc1_1, id_regsrc2_1, id_immtype1, id_memwrite1, id_regwrite1, id_memtoreg1, id_retaddr1, id_isimm1, id_upperimm1;
    logic id_jump_reg2, id_jump2, id_branch2, id_regsrc1_2, id_regsrc2_2, id_immtype2, id_memwrite2, id_regwrite2, id_memtoreg2, id_retaddr2, id_isimm2, id_upperimm2;
    logic [INIT_IMMEDIATE_SIZE-1:0] id_immout1, id_immout2;

    assign spec_return_address = (id_jump1) ? ({id_pc,2'b00} + 32'd4) : ({id_pc,2'b00} + 32'd8);

    // Rename -> Dispatch Wires
    logic [PRF_ADDRESS-1:0] rn_prd1, rn_prs1_1, rn_prs2_1, rn_old_prd1;
    logic [PRF_ADDRESS-1:0] rn_prd2, rn_prs1_2, rn_prs2_2, rn_old_prd2;             
    logic rn_prs1_busy1, rn_prs2_busy1, rn_prs1_busy2, rn_prs2_busy2;
    logic [BTAG_SIZE-1:0] rn_branch_tag;
    logic [MAX_BRANCHES-1:0] rn_branch_mask;
    logic [BIQ_ADDRESS-1:0] rn_biq_address;
    logic [XLEN-3:0] rn_pc;
    logic [4:0] rn_rd_1, rn_rd_2;
    logic [INIT_IMMEDIATE_SIZE-1:0] rn_immout1, rn_immout2;
    logic rn_is_m_extension1, rn_is_m_extension2;
    logic [4:0] rn_alu_operation1, rn_alu_operation2;
    
    logic rn_valid1, rn_jump_reg1, rn_jump1, rn_branch1, rn_regsrc1_1, rn_regsrc2_1, rn_immtype1, rn_isimm1, rn_retaddr1, rn_upperimm1, rn_regwrite1, rn_memwrite1, rn_memtoreg1;
    logic rn_valid2, rn_jump_reg2, rn_jump2, rn_branch2, rn_regsrc1_2, rn_regsrc2_2, rn_immtype2, rn_isimm2, rn_retaddr2, rn_upperimm2, rn_regwrite2, rn_memwrite2, rn_memtoreg2;

    // Dispatch -> Register Read Wires (Formerly Issue Outputs)
    logic iss_valid1, iss_is_m_extension1, iss_jump_reg1, iss_jump1, iss_branch1;
    logic iss_instr1_regsrc1, iss_instr1_regsrc2, iss_immtype1, iss_isimm1, iss_retaddr1;
    logic iss_upperimm1, iss_regwrite1, iss_memwrite1, iss_memtoreg1;
    logic [XLEN-3:0] iss_pc1;
    logic [PRF_ADDRESS-1:0] iss_prd1, iss_instr1_prs1, iss_instr1_prs2;
    logic [INIT_IMMEDIATE_SIZE-1:0] iss_immediate1;
    logic [4:0] iss_alu_operation1;
    logic [BTAG_SIZE-1:0] iss_branch_tag1;
    logic [MAX_BRANCHES-1:0] iss_branch_mask1;
    logic [BIQ_ADDRESS-1:0] iss_biq_address1;
    logic [ROB_PTR_SIZE-1:0] iss_rob_index1;

    logic iss_valid2, iss_is_m_extension2, iss_jump_reg2, iss_jump2, iss_branch2; 
    logic iss_instr2_regsrc1, iss_instr2_regsrc2, iss_immtype2, iss_isimm2, iss_retaddr2;
    logic iss_upperimm2, iss_regwrite2, iss_memwrite2, iss_memtoreg2;
    logic [XLEN-3:0] iss_pc2;
    logic [PRF_ADDRESS-1:0] iss_prd2, iss_instr2_prs1, iss_instr2_prs2;
    logic [INIT_IMMEDIATE_SIZE-1:0] iss_immediate2;
    logic [4:0] iss_alu_operation2;
    logic [BTAG_SIZE-1:0] iss_branch_tag2;
    logic [MAX_BRANCHES-1:0] iss_branch_mask2;
    logic [BIQ_ADDRESS-1:0] iss_biq_address2;
    logic [ROB_PTR_SIZE-1:0] iss_rob_index2;

    // ============================================================================
    // MODULE INSTANTIATIONS
    // ============================================================================

    PD_Stage #(
        .PHT_ADDRESS            (9),
        .GHR_SIZE               (9),
        .XLEN                   (32),
        .RAS_ADDRESS            (3)
    ) pd_stage_inst (
        .CLK                     (CLK),
        .reset                   (reset),
        .stall_frontend          (stall_frontend),
        .ex_actual_taken         (actual_taken),
        .restore_ghr             (restore_ghr),
        .restore_ras             (restore_ras),
        .update_pht              (update_pht),
        .ex_is_jalr              (ex_is_jalr), 
        .ex_is_ret               (ex_is_ret),
        .ex_is_branch            (ex_is_branch),
        .flush                   (mispredict), 
        .if_predecode_instr1     (if_predecode_instr1), 
        .if_predecode_instr2     (if_predecode_instr2), 
        .ex_actual_target_address(actual_target_address), 
        .if_target_address       (if_target_address),
        .if_pc                   (pd_pc), 
        .ex_pc                   (ex_pc),
        .ghr_snap                (ghr_snap),
        .rb_pht_index            (rb_pht_index),
        .rb_sp_snap              (rb_sp_snap),
        .rb_ras_snap             (rb_ras_snap),

        .pd_pred_taken           (pd_pred_taken1), 
        .pd_btb_hit              (pd_btb_hit1),    
        .pd_valid1               (pd_valid1),
        .pd_valid2               (pd_valid2),
        .pd_pc                   (pd_pc),
        .pd_pred_target          (pd_pred_target1), 
        .pd_pht_index            (pd_pht_index1),   
        .pd_sp_snap              (pd_sp_snap),
        .pd_ras_snap             (pd_ras_snap),
        .pd_prev_ghr             (pd_prev_ghr)
    );

    IF_Stage #( 
        .PHT_ADDRESS            (9),
        .GHR_SIZE               (9),
        .XLEN                   (32),
        .RAS_ADDRESS            (3)
    ) if_stage_inst (
        .CLK                     (CLK),
        .reset                   (reset),
        .flush                   (flush),
        .pd_valid1               (pd_valid1),
        .pd_valid2               (pd_valid2),
        .stall_frontend          (stall_frontend), 
        .pd_pred_taken           (pd_pred_taken1), 
        .pd_btb_hit              (pd_btb_hit1),    
        .pd_pc                   (pd_pc),
        .pd_pred_target          (pd_pred_target1), 
        .pd_pht_index            (pd_pht_index1),   
        .pd_sp_snap              (pd_sp_snap),
        .pd_ras_snap             (pd_ras_snap),
        .pd_prev_ghr             (pd_prev_ghr),

        .if_pred_taken           (if_pred_taken1), 
        .if_btb_hit              (if_btb_hit1),    
        .if_valid1               (if_valid1),
        .if_valid2               (if_valid2),
        .if_predecode_instr1     (if_predecode_instr1), 
        .if_predecode_instr2     (if_predecode_instr2), 
        .if_instr1               (if_instr1),
        .if_instr2               (if_instr2),
        .if_pred_target          (if_pred_target1), 
        .if_pc                   (if_pc),           
        .if_pht_index            (if_pht_index1),   
        .if_sp_snap              (if_sp_snap),
        .if_ras_snap             (if_ras_snap),
        .if_prev_ghr             (if_prev_ghr)
    );

    ID_Stage #( 
        .OPCODE_SIZE            (OPCODE_SIZE),
        .PHT_ADDRESS            (PHT_ADDRESS),
        .GHR_SIZE               (GHR_SIZE),
        .XLEN                   (XLEN),
        .RAS_ADDRESS            (RAS_ADDRESS),
        .INIT_IMMEDIATE_SIZE    (INIT_IMMEDIATE_SIZE),
        .BIQ_ADDRESS            (BIQ_ADDRESS)
    ) id_stage_inst (
        .CLK                     (CLK),
        .reset                   (reset),
        .flush                   (flush),
        .stall_frontend          (stall_frontend), 
        .rr_biq_id               (rr_biq_id),
        .dis_biq_dealloc         (dis_biq_dealloc),
        .if_pred_taken           (if_pred_taken1),
        .if_valid1               (if_valid1),
        .if_valid2               (if_valid2),
        .if_instr1               (if_instr1),
        .if_instr2               (if_instr2),
        .if_pred_target          (if_pred_target1), 
        .if_pc                   (if_pc),           
        .if_pht_index            (if_pht_index1),   
        .if_sp_snap              (if_sp_snap),
        .if_ras_snap             (if_ras_snap),
        .if_prev_ghr             (if_prev_ghr),
        
        .id_biq_sp_snap          (id_biq_sp_snap),
        .id_biq_ras_snap         (id_biq_ras_snap),
        .id_stall_frontend       (id_stall_frontend), 
        .id_take_snap            (id_take_snap),
        .id_valid1               (id_valid1),
        .id_valid2               (id_valid2),
        .id_rs1_1                (id_rs1_1), 
        .id_rs2_1                (id_rs2_1), 
        .id_rd_1                 (id_rd_1),
        .id_rs1_2                (id_rs1_2), 
        .id_rs2_2                (id_rs2_2), 
        .id_rd_2                 (id_rd_2),
        .id_immout1              (id_immout1), 
        .id_immout2              (id_immout2),
        .id_biq_address          (id_biq_address),
        .id_biq_pred_target      (id_biq_pred_target), 
        .id_pc                   (id_pc),           
        .id_biq_restore_ghr      (id_biq_restore_ghr),
        .id_biq_pht_index        (id_biq_pht_index),
        .id_alu_operation1       (id_alu_operation1), 
        .id_alu_operation2       (id_alu_operation2),
        .id_is_m_extension1      (id_is_m_extension1),
        .id_is_m_extension2      (id_is_m_extension2),
        .id_jump_reg1            (id_jump_reg1), 
        .id_jump_reg2            (id_jump_reg2), 
        .id_jump1                (id_jump1), 
        .id_jump2                (id_jump2), 
        .id_branch1              (id_branch1), 
        .id_branch2              (id_branch2), 
        .id_regsrc1_1            (id_regsrc1_1),  
        .id_immtype1             (id_immtype1), 
        .id_memwrite1            (id_memwrite1),  
        .id_immtype2             (id_immtype2), 
        .id_biq_valid            (id_biq_valid), 
        .id_biq_pred_taken       (id_biq_pred_taken), 
        .id_regsrc2_1            (id_regsrc2_1),
        .id_regsrc1_2            (id_regsrc1_2), 
        .id_regsrc2_2            (id_regsrc2_2), 
        .id_upperimm1            (id_upperimm1), 
        .id_upperimm2            (id_upperimm2), 
        .id_regwrite1            (id_regwrite1), 
        .id_regwrite2            (id_regwrite2), 
        .id_memwrite2            (id_memwrite2), 
        .id_memtoreg1            (id_memtoreg1), 
        .id_memtoreg2            (id_memtoreg2), 
        .id_retaddr1             (id_retaddr1), 
        .id_retaddr2             (id_retaddr2), 
        .id_isimm1               (id_isimm1), 
        .id_isimm2               (id_isimm2)
    );

    RN_Stage #(
        .PRF_ADDRESS             (PRF_ADDRESS),
        .INIT_IMMEDIATE_SIZE     (INIT_IMMEDIATE_SIZE),
        .MAX_BRANCHES            (MAX_BRANCHES),
        .BTAG_SIZE               (BTAG_SIZE),
        .BIQ_ADDRESS             (BIQ_ADDRESS),
        .XLEN                    (XLEN),
        .NUM_PHY_REG             (NUM_PHY_REG),
        .FL_ROWS                 (FL_ROWS),
        .FL_INDEX_WIDTH          (FL_INDEX_WIDTH),
        .FL_PTR_WIDTH            (FL_PTR_WIDTH)
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
        .cdb_branch_resolved     (cdb_branch_resolved),
        
        .id_is_m_extension1      (id_is_m_extension1), .id_is_m_extension2(id_is_m_extension2),
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

        .cdb_waked_reg1          (cdb_waked_reg1), 
        .cdb_waked_reg2          (cdb_waked_reg2), 
        .comm_free_reg1          (comm_free_reg1), 
        .comm_free_reg2          (comm_free_reg2),
        .cdb_branch_tag          (cdb_branch_tag),
        
        .id_rs1_1                (id_rs1_1), .id_rs2_1(id_rs2_1), .id_rd_1(id_rd_1),
        .id_rs1_2                (id_rs1_2), .id_rs2_2(id_rs2_2), .id_rd_2(id_rd_2),
        .id_immout1              (id_immout1), .id_immout2(id_immout2),
        .id_biq_address          (id_biq_address),
        .id_pc                   (id_pc),
        .id_alu_operation1       (id_alu_operation1), .id_alu_operation2(id_alu_operation2),
        
        .stall_frontend          (stall_frontend),
        .rn_stall_frontend       (rn_stall_frontend), 
        .rn_prd1                 (rn_prd1), .rn_prs1_1(rn_prs1_1), .rn_prs2_1(rn_prs2_1), .rn_old_prd1(rn_old_prd1),
        .rn_prd2                 (rn_prd2), .rn_prs1_2(rn_prs1_2), .rn_prs2_2(rn_prs2_2), .rn_old_prd2(rn_old_prd2),             
        .rn_prs1_busy1           (rn_prs1_busy1), .rn_prs2_busy1(rn_prs2_busy1), .rn_prs1_busy2(rn_prs1_busy2), .rn_prs2_busy2(rn_prs2_busy2),
        .rn_branch_tag           (rn_branch_tag),
        .rn_branch_mask          (rn_branch_mask),
        .rn_biq_address          (rn_biq_address),
        .rn_pc                   (rn_pc),
        .rn_rd_1                 (rn_rd_1), .rn_rd_2(rn_rd_2),
        .rn_immout1              (rn_immout1), .rn_immout2(rn_immout2),
        .rn_is_m_extension1      (rn_is_m_extension1), .rn_is_m_extension2(rn_is_m_extension2),
        .rn_alu_operation1       (rn_alu_operation1), .rn_alu_operation2(rn_alu_operation2),
        
        .rn_valid1               (rn_valid1), .rn_jump_reg1(rn_jump_reg1), .rn_jump1(rn_jump1), .rn_branch1(rn_branch1), 
        .rn_regsrc1_1            (rn_regsrc1_1), .rn_regsrc2_1(rn_regsrc2_1), .rn_immtype1(rn_immtype1), .rn_isimm1(rn_isimm1), .rn_retaddr1(rn_retaddr1),
        .rn_upperimm1            (rn_upperimm1), .rn_regwrite1(rn_regwrite1), .rn_memwrite1(rn_memwrite1), .rn_memtoreg1(rn_memtoreg1), 

        .rn_valid2               (rn_valid2), .rn_jump_reg2(rn_jump_reg2), .rn_jump2(rn_jump2), .rn_branch2(rn_branch2), 
        .rn_regsrc1_2            (rn_regsrc1_2), .rn_regsrc2_2(rn_regsrc2_2), .rn_immtype2(rn_immtype2), .rn_isimm2(rn_isimm2), .rn_retaddr2(rn_retaddr2),
        .rn_upperimm2            (rn_upperimm2), .rn_regwrite2(rn_regwrite2), .rn_memwrite2(rn_memwrite2), .rn_memtoreg2(rn_memtoreg2)
    );

    DIS_Stage #(
        .XLEN                    (XLEN),
        .PRF_ADDRESS             (PRF_ADDRESS),
        .BIQ_ADDRESS             (BIQ_ADDRESS),
        .ROB_SIZE                (ROB_SIZE),
        .INIT_IMMEDIATE_SIZE     (INIT_IMMEDIATE_SIZE),
        .ROB_PTR_SIZE            (ROB_PTR_SIZE),
        .MAX_BRANCHES            (MAX_BRANCHES),
        .BTAG_SIZE               (BTAG_SIZE)
    ) dis_stage_inst (
        .CLK                     (CLK), 
        .reset                   (reset), 
        .flush                   (flush), 
        .stall_frontend          (stall_frontend), 
        .branch_mispredicted     (branch_mispredicted),
        .dis_stall_frontend      (dis_stall_frontend), 
        .cdb_done1               (cdb_done1), .cdb_done2(cdb_done2),
        .cdb_wakeup1             (cdb_wakeup1), .cdb_wakeup2(cdb_wakeup2),
        .cdb_branch_resolved     (cdb_branch_resolved), .cdb_branch_correct(cdb_branch_correct),
        .cdb_waked_reg1          (cdb_waked_reg1), .cdb_waked_reg2(cdb_waked_reg2),
        .cdb_branch_tag          (cdb_branch_tag),
        .cdb_rob_index1          (cdb_rob_index1), .cdb_rob_index2(cdb_rob_index2),
        
        // Connect intermediate RN outputs
        .rn_prd1                 (rn_prd1), .rn_prs1_1(rn_prs1_1), .rn_prs2_1(rn_prs2_1), .rn_old_prd1(rn_old_prd1), 
        .rn_prd2                 (rn_prd2), .rn_prs1_2(rn_prs1_2), .rn_prs2_2(rn_prs2_2), .rn_old_prd2(rn_old_prd2),             
        .rn_prs1_busy1           (rn_prs1_busy1), .rn_prs2_busy1(rn_prs2_busy1), .rn_prs1_busy2(rn_prs1_busy2), .rn_prs2_busy2(rn_prs2_busy2),
        .rn_branch_tag           (rn_branch_tag),
        .rn_branch_mask          (rn_branch_mask),
        .rn_biq_address          (rn_biq_address),
        .rn_pc                   (rn_pc),
        .rn_rd_1                 (rn_rd_1), .rn_rd_2(rn_rd_2),
        .rn_immout1              (rn_immout1), .rn_immout2(rn_immout2),
        .rn_is_m_extension1      (rn_is_m_extension1), .rn_is_m_extension2(rn_is_m_extension2),
        .rn_alu_operation1       (rn_alu_operation1), .rn_alu_operation2(rn_alu_operation2),
        
        .rn_valid1               (rn_valid1), .rn_jump_reg1(rn_jump_reg1), .rn_jump1(rn_jump1), .rn_branch1(rn_branch1), 
        .rn_regsrc1_1            (rn_regsrc1_1), .rn_regsrc2_1(rn_regsrc2_1), .rn_immtype1(rn_immtype1), .rn_isimm1(rn_isimm1), .rn_retaddr1(rn_retaddr1),
        .rn_upperimm1            (rn_upperimm1), .rn_regwrite1(rn_regwrite1), .rn_memwrite1(rn_memwrite1), .rn_memtoreg1(rn_memtoreg1), 
        
        .rn_valid2               (rn_valid2), .rn_jump_reg2(rn_jump_reg2), .rn_jump2(rn_jump2), .rn_branch2(rn_branch2), 
        .rn_regsrc1_2            (rn_regsrc1_2), .rn_regsrc2_2(rn_regsrc2_2), .rn_immtype2(rn_immtype2), .rn_isimm2(rn_isimm2), .rn_retaddr2(rn_retaddr2),
        .rn_upperimm2            (rn_upperimm2), .rn_regwrite2(rn_regwrite2), .rn_memwrite2(rn_memwrite2), .rn_memtoreg2(rn_memtoreg2),
        
        .cdb_branch_rob_index    (cdb_branch_rob_index),
        
        // Exported Commit Outputs
        .commit_instr1           (commit_instr1), .commit_instr2(commit_instr2),
        .dis_free_old_prd1       (dis_free_old_prd1), .dis_free_old_prd2(dis_free_old_prd2),
        .comm_prd1               (comm_prd1), .comm_prd2(comm_prd2),
        .comm_rd1                (comm_rd1), .comm_rd2(comm_rd2),
        
        // Internal Dispatch to RR Issue Connectors
        .iss_valid1              (iss_valid1), .iss_is_m_extension1(iss_is_m_extension1), .iss_jump_reg1(iss_jump_reg1), .iss_jump1(iss_jump1), .iss_branch1(iss_branch1), 
        .iss_instr1_regsrc1      (iss_instr1_regsrc1), .iss_instr1_regsrc2(iss_instr1_regsrc2), .iss_immtype1(iss_immtype1), .iss_isimm1(iss_isimm1), .iss_retaddr1(iss_retaddr1),
        .iss_upperimm1           (iss_upperimm1), .iss_regwrite1(iss_regwrite1), .iss_memwrite1(iss_memwrite1), .iss_memtoreg1(iss_memtoreg1),
        .iss_pc1                 (iss_pc1),
        .iss_prd1                (iss_prd1), .iss_instr1_prs1(iss_instr1_prs1), .iss_instr1_prs2(iss_instr1_prs2),
        .iss_immediate1          (iss_immediate1),
        .iss_alu_operation1      (iss_alu_operation1),
        .iss_branch_tag1         (iss_branch_tag1),
        .iss_branch_mask1        (iss_branch_mask1),
        .iss_biq_address1        (iss_biq_address1),
        .iss_rob_index1          (iss_rob_index1),

        .iss_valid2              (iss_valid2), .iss_is_m_extension2(iss_is_m_extension2), .iss_jump_reg2(iss_jump_reg2), .iss_jump2(iss_jump2), .iss_branch2(iss_branch2), 
        .iss_instr2_regsrc1      (iss_instr2_regsrc1), .iss_instr2_regsrc2(iss_instr2_regsrc2), .iss_immtype2(iss_immtype2), .iss_isimm2(iss_isimm2), .iss_retaddr2(iss_retaddr2),
        .iss_upperimm2           (iss_upperimm2), .iss_regwrite2(iss_regwrite2), .iss_memwrite2(iss_memwrite2), .iss_memtoreg2(iss_memtoreg2),
        .iss_pc2                 (iss_pc2),
        .iss_prd2                (iss_prd2), .iss_instr2_prs1(iss_instr2_prs1), .iss_instr2_prs2(iss_instr2_prs2),
        .iss_immediate2          (iss_immediate2),
        .iss_alu_operation2      (iss_alu_operation2),
        .iss_branch_tag2         (iss_branch_tag2),
        .iss_branch_mask2        (iss_branch_mask2),
        .iss_biq_address2        (iss_biq_address2),
        .iss_rob_index2          (iss_rob_index2)
    );

    RR_Stage #(
        .XLEN                    (XLEN),
        .MAX_BRANCHES            (MAX_BRANCHES),
        .BTAG_SIZE               (BTAG_SIZE),
        .PRF_ADDRESS             (PRF_ADDRESS),
        .INIT_IMMEDIATE_SIZE     (INIT_IMMEDIATE_SIZE),
        .BIQ_ADDRESS             (BIQ_ADDRESS),
        .ROB_SIZE                (ROB_SIZE),
        .ROB_PTR_SIZE            (ROB_PTR_SIZE)
    ) rr_stage_inst (
        .CLK                     (CLK), 
        .reset                   (reset), 
        .flush                   (flush), 
        
        // CDB Bypass/Write Inputs
        .cdb_regwrite1           (cdb_regwrite1), 
        .cdb_regwrite2           (cdb_regwrite2),
        .cdb_branch_tag          (cdb_branch_tag),
        .cdb_write_address1      (cdb_write_address1), 
        .cdb_write_address2      (cdb_write_address2),
        .cdb_write_data1         (cdb_write_data1), 
        .cdb_write_data2         (cdb_write_data2),
        
        // Issued Instruction 1 (From DIS)
        .iss_valid1              (iss_valid1), .iss_is_m_extension1(iss_is_m_extension1), .iss_jump_reg1(iss_jump_reg1), .iss_jump1(iss_jump1), .iss_branch1(iss_branch1), 
        .iss_instr1_regsrc1      (iss_instr1_regsrc1), .iss_instr1_regsrc2(iss_instr1_regsrc2), .iss_immtype1(iss_immtype1), .iss_isimm1(iss_isimm1), .iss_retaddr1(iss_retaddr1),
        .iss_upperimm1           (iss_upperimm1), .iss_regwrite1(iss_regwrite1), .iss_memwrite1(iss_memwrite1), .iss_memtoreg1(iss_memtoreg1),
        .iss_pc1                 (iss_pc1),
        .iss_prd1                (iss_prd1), .iss_instr1_prs1(iss_instr1_prs1), .iss_instr1_prs2(iss_instr1_prs2),
        .iss_immediate1          (iss_immediate1),
        .iss_alu_operation1      (iss_alu_operation1),
        .iss_branch_tag1         (iss_branch_tag1),
        .iss_branch_mask1        (iss_branch_mask1),
        .iss_biq_address1        (iss_biq_address1),
        .iss_rob_index1          (iss_rob_index1),

        // Issued Instruction 2 (From DIS)
        .iss_valid2              (iss_valid2), .iss_is_m_extension2(iss_is_m_extension2), .iss_jump_reg2(iss_jump_reg2), .iss_jump2(iss_jump2), .iss_branch2(iss_branch2), 
        .iss_instr2_regsrc1      (iss_instr2_regsrc1), .iss_instr2_regsrc2(iss_instr2_regsrc2), .iss_immtype2(iss_immtype2), .iss_isimm2(iss_isimm2), .iss_retaddr2(iss_retaddr2),
        .iss_upperimm2           (iss_upperimm2), .iss_regwrite2(iss_regwrite2), .iss_memwrite2(iss_memwrite2), .iss_memtoreg2(iss_memtoreg2),
        .iss_pc2                 (iss_pc2),
        .iss_prd2                (iss_prd2), .iss_instr2_prs1(iss_instr2_prs1), .iss_instr2_prs2(iss_instr2_prs2),
        .iss_immediate2          (iss_immediate2),
        .iss_alu_operation2      (iss_alu_operation2),
        .iss_branch_tag2         (iss_branch_tag2),
        .iss_branch_mask2        (iss_branch_mask2),
        .iss_biq_address2        (iss_biq_address2),
        .iss_rob_index2          (iss_rob_index2),

        // RR Outputs 1
        .rr_instr1_read_data1    (rr_instr1_read_data1), .rr_instr1_read_data2(rr_instr1_read_data2),
        .rr_valid1               (rr_valid1), .rr_is_m_extension1(rr_is_m_extension1), .rr_jump_reg1(rr_jump_reg1), .rr_jump1(rr_jump1), .rr_branch1(rr_branch1),
        .rr_instr1_regsrc1       (rr_instr1_regsrc1), .rr_instr1_regsrc2(rr_instr1_regsrc2), .rr_isimm1(rr_isimm1), .rr_retaddr1(rr_retaddr1), .rr_upperimm1(rr_upperimm1),
        .rr_regwrite1            (rr_regwrite1), .rr_memwrite1(rr_memwrite1), .rr_memtoreg1(rr_memtoreg1),
        .rr_pc1                  (rr_pc1),
        .rr_prd1                 (rr_prd1),
        .rr_immediate1           (rr_immediate1),
        .rr_alu_operation1       (rr_alu_operation1),
        .rr_branch_tag1          (rr_branch_tag1),
        .rr_branch_mask1         (rr_branch_mask1),
        .rr_biq_address1         (rr_biq_address1),
        .rr_rob_index1           (rr_rob_index1),
        
        // RR Outputs 2
        .rr_instr2_read_data1    (rr_instr2_read_data1), .rr_instr2_read_data2(rr_instr2_read_data2),
        .rr_valid2               (rr_valid2), .rr_is_m_extension2(rr_is_m_extension2), .rr_jump_reg2(rr_jump_reg2), .rr_jump2(rr_jump2), .rr_branch2(rr_branch2),
        .rr_instr2_regsrc1       (rr_instr2_regsrc1), .rr_instr2_regsrc2(rr_instr2_regsrc2), .rr_isimm2(rr_isimm2), .rr_retaddr2(rr_retaddr2), .rr_upperimm2(rr_upperimm2),
        .rr_regwrite2            (rr_regwrite2), .rr_memwrite2(rr_memwrite2), .rr_memtoreg2(rr_memtoreg2),
        .rr_pc2                  (rr_pc2),
        .rr_prd2                 (rr_prd2),
        .rr_immediate2           (rr_immediate2),
        .rr_alu_operation2       (rr_alu_operation2),
        .rr_branch_tag2          (rr_branch_tag2),
        .rr_branch_mask2         (rr_branch_mask2),
        .rr_biq_address2         (rr_biq_address2),
        .rr_rob_index2           (rr_rob_index2)
    );

endmodule
