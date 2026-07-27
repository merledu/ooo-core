// =================================================================================
// main_datapath.sv
//
// Fully self-contained OOO core datapath. Only CLK and reset are exposed at
// this level -- every other signal (frontend prediction, rename, dispatch,
// register read, execute, memory, and the CDB arbiter that ties writeback
// together) is instantiated and wired internally.
//
// NOTE ON OPEN DESIGN GAPS: a handful of connections here are NOT a direct,
// unambiguous 1:1 port match between existing modules. Each is called out
// with a "GAP:" comment at its point of use, and summarized at the bottom of
// this file. These are not silent guesses baked into module internals --
// they are the *minimum* glue needed to let this module elaborate, and they
// should be reviewed/replaced once the underlying stage(s) are extended.
// =================================================================================

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
    parameter FL_PTR_WIDTH        = FL_INDEX_WIDTH + 1,
    parameter LQ_ENTRIES          = 32,
    parameter LQ_ADDRESS          = $clog2(LQ_ENTRIES),
    parameter SQ_ENTRIES          = 16,
    parameter SQ_ADDRESS          = $clog2(SQ_ENTRIES),
    parameter RAM_DEPTH           = 64,
    parameter RAM_ADDRESS         = $clog2(RAM_DEPTH)
) (
    input logic CLK,
    input logic reset
);

    // ============================================================================
    // GLOBAL FLUSH / STALL WIRES
    // ============================================================================
    // GAP 1: EX_Stage exposes a single "flush" output (asserted on branch
    // misprediction). The old top-level module distinguished a pipeline
    // "flush" (fed to IF/ID/RN/DIS/RR) from a PD-only "mispredict" signal.
    // With only one flush source available now, both roles are served by
    // the same wire.
    logic ex_flush;
    logic rob_global_flush;
    logic [XLEN-3:0] rob_flush_pc;

    logic id_stall_frontend, rn_stall_frontend, dis_stall_frontend;
    logic stall_frontend;
    assign stall_frontend = id_stall_frontend | rn_stall_frontend | dis_stall_frontend;

    // ============================================================================
    // PD / IF SIGNALS
    // ============================================================================
    logic [1:0] if_predecode_instr1, if_predecode_instr2;
    logic [XLEN-1:0] if_target_address;

    logic pd_valid1, pd_valid2, pd_pred_taken, pd_btb_hit;
    logic [XLEN-1:0] pd_pc, pd_pred_target;
    logic [PHT_ADDRESS-1:0] pd_pht_index;
    logic [RAS_ADDRESS-1:0] pd_sp_snap;
    logic [2*XLEN-1:0] pd_ras_snap;
    logic [GHR_SIZE-1:0] pd_prev_ghr;

    logic if_valid1, if_valid2, if_pred_taken, if_btb_hit;
    logic [XLEN-3:0] if_pc;
    logic [XLEN-1:0] if_instr1, if_instr2, if_pred_target;
    logic [PHT_ADDRESS-1:0] if_pht_index;
    logic [RAS_ADDRESS-1:0] if_sp_snap;
    logic [2*XLEN-1:0] if_ras_snap;
    logic [GHR_SIZE-1:0] if_prev_ghr;

    // GAP 2: PD_Stage's "if_target_address" input feeds RAS's call-address
    // push and BTB's fallback target -- but no module currently computes it.
    // Using the straightforward "next sequential PC" (if_pc word-address,
    // converted to byte address, +4) as the actual return address candidate.
    assign if_target_address = ({if_pc, 2'b00} + 32'd4);

    // ============================================================================
    // ID SIGNALS (Decode -> Rename)
    // ============================================================================
    logic id_take_snap, id_valid1, id_valid2;
    logic [XLEN-3:0] id_pc;
    logic [BIQ_ADDRESS-1:0] id_biq_address;
    logic [4:0] id_alu_operation1, id_alu_operation2;
    logic id_is_m_extension1, id_is_m_extension2;
    logic [4:0] id_rs1_1, id_rs2_1, id_rd_1, id_rs1_2, id_rs2_2, id_rd_2;
    logic id_jump_reg1, id_jump1, id_branch1, id_regsrc1_1, id_regsrc2_1, id_immtype1, id_memwrite1, id_regwrite1, id_memtoreg1, id_retaddr1, id_isimm1, id_upperimm1;
    logic id_jump_reg2, id_jump2, id_branch2, id_regsrc1_2, id_regsrc2_2, id_immtype2, id_memwrite2, id_regwrite2, id_memtoreg2, id_retaddr2, id_isimm2, id_upperimm2;
    logic [INIT_IMMEDIATE_SIZE-1:0] id_immout1, id_immout2;
    logic [1:0] id_memory_type1, id_memory_type2;
    logic id_memory_sign_ext1, id_memory_sign_ext2;

    // BIQ metadata (from ID_Stage's internal BIQ, read at address rr_biq_id)
    logic id_biq_valid, id_biq_pred_taken;
    logic [XLEN-1:0] id_biq_pred_target;
    logic [PHT_ADDRESS-1:0] id_biq_pht_index;
    logic [GHR_SIZE-1:0] id_biq_restore_ghr;
    logic [RAS_ADDRESS-1:0] id_biq_sp_snap;
    logic [2*XLEN-1:0] id_biq_ras_snap;

    logic [BIQ_ADDRESS-1:0] rr_biq_id;
    logic dis_biq_dealloc;

    // ============================================================================
    // RN SIGNALS (Rename -> Dispatch)
    // ============================================================================
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
    logic [1:0] rn_memory_type1, rn_memory_type2;
    logic rn_memory_sign_ext1, rn_memory_sign_ext2;
    logic rn_valid1, rn_jump_reg1, rn_jump1, rn_branch1, rn_regsrc1_1, rn_regsrc2_1, rn_immtype1, rn_isimm1, rn_retaddr1, rn_upperimm1, rn_regwrite1, rn_memwrite1, rn_memtoreg1;
    logic rn_valid2, rn_jump_reg2, rn_jump2, rn_branch2, rn_regsrc1_2, rn_regsrc2_2, rn_immtype2, rn_isimm2, rn_retaddr2, rn_upperimm2, rn_regwrite2, rn_memwrite2, rn_memtoreg2;

    // RN_Stage does not export is_load/is_store flags; DIS_Stage/ROB/LSQ need
    // them, so they are derived from the existing memtoreg (load) / memwrite
    // (store) control bits.
    logic rn_is_load1, rn_is_load2, rn_is_store1, rn_is_store2;
    assign rn_is_load1  = rn_memtoreg1;
    assign rn_is_load2  = rn_memtoreg2;
    assign rn_is_store1 = rn_memwrite1;
    assign rn_is_store2 = rn_memwrite2;

    // GAP 3: DIS_Stage exposes rn_rob_index1/2 as *inputs*, even though it
    // instantiates the ROB internally and the ROB's current_rob_index (the
    // real allocation pointer) never leaves the module as an output. There
    // is therefore no way to source these correctly from outside DIS_Stage
    // without either exposing current_rob_index as a DIS_Stage output or
    // removing these ports and wiring LSQ's rn_rob_index* internally to
    // current_rob_index (mirroring how rn_pc2 is derived as rn_pc+1).
    // Tied to 0 here as a placeholder -- this needs a DIS_Stage-side fix.
    logic [ROB_PTR_SIZE-1:0] rn_rob_index1_stub, rn_rob_index2_stub;
    assign rn_rob_index1_stub = '0;
    assign rn_rob_index2_stub = '0;

    // ============================================================================
    // DIS SIGNALS (Dispatch -> Register Read), ROB/IQ/LSQ live inside DIS_Stage
    // ============================================================================
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

    logic commit_instr1, commit_instr2;
    logic [PRF_ADDRESS-1:0] dis_free_old_prd1, dis_free_old_prd2;
    logic [PRF_ADDRESS-1:0] comm_prd1, comm_prd2;
    logic [4:0] comm_rd1, comm_rd2;

    logic lsq_mem_write, lsq_mem_read;
    logic [XLEN-1:0] lsq_memory_address, lsq_mem_write_data;
    logic [1:0] lsq_mem_size;
    logic lsq_mem_sign_ext;
    logic lsq_write_prf;
    logic [XLEN-1:0] lsq_write_prf_data;
    logic [PRF_ADDRESS-1:0] lsq_write_prf_address;
    logic [LQ_ADDRESS-1:0] lsq_lq_index;
    logic [ROB_PTR_SIZE-1:0] lsq_rob_index;

    logic mem_lq_write;
    logic [LQ_ADDRESS-1:0] mem_lq_index;
    logic [XLEN-1:0] mem_read_data;

    // GAP 4: cdb_address_available1/2, cdb_is_load1/2, cdb_lq_index1/2 and
    // cdb_memory_address1/2 appear on both DIS_Stage's top port list and
    // (duplicated, along with a second copy of ex_is_load1/2) inside
    // LSQ.sv's own port list. No module produces these -- they look like a
    // leftover/duplicate set from a merge rather than a real second address
    // path. Tied to 0 here; worth deleting from LSQ.sv's port list if
    // confirmed dead.
    logic cdb_address_available1, cdb_address_available2;
    logic cdb_is_load1, cdb_is_load2;
    logic [LQ_ADDRESS-1:0] cdb_lq_index1, cdb_lq_index2;
    logic [XLEN-1:0] cdb_memory_address1, cdb_memory_address2;
    assign cdb_address_available1 = 1'b0;
    assign cdb_address_available2 = 1'b0;
    assign cdb_is_load1 = 1'b0;
    assign cdb_is_load2 = 1'b0;
    assign cdb_lq_index1 = '0;
    assign cdb_lq_index2 = '0;
    assign cdb_memory_address1 = '0;
    assign cdb_memory_address2 = '0;

    // GAP 5: EX_Stage only produces a single (slot-1) AGU result
    // (ex_mem_address1_available/ex_is_load1/ex_is_store1/ex_mem_address1)
    // and never produces ex_lq_index1/2 or ex_sq_index1/2 at all, even
    // though DIS_Stage/LSQ expect a full pair for dual-issue loads/stores.
    // Slot 2 and the LQ/SQ index tags are tied off here as placeholders
    // until EX_Stage grows a second AGU path and LQ/SQ index tagging.
    logic ex_mem_address2_available, ex_is_load2, ex_is_store2;
    logic [XLEN-1:0] ex_mem_address2;
    logic [LQ_ADDRESS-1:0] ex_lq_index1, ex_lq_index2;
    logic [SQ_ADDRESS-1:0] ex_sq_index1, ex_sq_index2;
    assign ex_mem_address2_available = 1'b0;
    assign ex_is_load2  = 1'b0;
    assign ex_is_store2 = 1'b0;
    assign ex_mem_address2 = '0;
    assign ex_lq_index1 = '0;
    assign ex_lq_index2 = '0;
    assign ex_sq_index1 = '0;
    assign ex_sq_index2 = '0;

    // ============================================================================
    // RR SIGNALS (Register Read; PRF lives inside RR_Stage)
    // ============================================================================
    logic [XLEN-1:0] rr_instr1_read_data1, rr_instr1_read_data2;
    logic [XLEN-1:0] rr_instr2_read_data1, rr_instr2_read_data2;
    logic [PRF_ADDRESS-1:0] rr_instr1_prs1, rr_instr1_prs2;
    logic [PRF_ADDRESS-1:0] rr_instr2_prs1, rr_instr2_prs2;

    logic rr_valid1, rr_is_m_extension1, rr_jump_reg1, rr_jump1, rr_branch1;
    logic rr_instr1_regsrc1, rr_instr1_regsrc2, rr_isimm1, rr_retaddr1, rr_upperimm1;
    logic rr_regwrite1, rr_memwrite1, rr_memtoreg1;
    logic [XLEN-3:0] rr_pc1;
    logic [PRF_ADDRESS-1:0] rr_prd1;
    logic [XLEN-1:0] rr_immediate1;
    logic [4:0] rr_alu_operation1;
    logic [BTAG_SIZE-1:0] rr_branch_tag1;
    logic [MAX_BRANCHES-1:0] rr_branch_mask1;
    logic [BIQ_ADDRESS-1:0] rr_biq_address1;
    logic [ROB_PTR_SIZE-1:0] rr_rob_index1;

    logic rr_valid2, rr_is_m_extension2, rr_jump_reg2, rr_jump2, rr_branch2;
    logic rr_instr2_regsrc1, rr_instr2_regsrc2, rr_isimm2, rr_retaddr2, rr_upperimm2;
    logic rr_regwrite2, rr_memwrite2, rr_memtoreg2;
    logic [XLEN-3:0] rr_pc2;
    logic [PRF_ADDRESS-1:0] rr_prd2;
    logic [XLEN-1:0] rr_immediate2;
    logic [4:0] rr_alu_operation2;
    logic [BTAG_SIZE-1:0] rr_branch_tag2;
    logic [MAX_BRANCHES-1:0] rr_branch_mask2;
    logic [BIQ_ADDRESS-1:0] rr_biq_address2;
    logic [ROB_PTR_SIZE-1:0] rr_rob_index2;

    // GAP 6: EX_Stage needs an independent BIQ read per slot
    // (biq_pred_taken1/2, biq_pred_target1/2), but BIQ (inside ID_Stage)
    // only has a single read port (rr_biq_id -> id_biq_pred_taken/target).
    // This mirrors the documented "single branch resolution per cycle"
    // limitation: the resolving slot's biq_address feeds the one read port,
    // and both EX ports see the same read result (harmless as long as at
    // most one of rr_branch1/rr_branch2 is true per cycle).
    assign rr_biq_id = rr_branch1 ? rr_biq_address1 : rr_biq_address2;

    // GAP 7: ROB only tags entries with is_load/is_store at commit
    // (commit_is_load1/2, commit_is_store1/2) -- there's no commit_is_branch
    // to gate BIQ deallocation precisely. Approximated as "deallocate on any
    // commit"; refine once ROB exposes a commit_is_branch1/2 pair.
    assign dis_biq_dealloc = commit_instr1 || commit_instr2;

    // GAP 8: EX_Stage doesn't expose the ROB index of whichever slot is the
    // resolving branch (needed by ROB/LSQ as cdb_branch_rob_index). Derived
    // the same way as GAP 6, from RR_Stage's own pass-through rob indices.
    logic [ROB_PTR_SIZE-1:0] cdb_branch_rob_index;
    assign cdb_branch_rob_index = rr_branch1 ? rr_rob_index1 : rr_rob_index2;

    // ============================================================================
    // EX SIGNALS
    // ============================================================================
    logic [BTAG_SIZE-1:0] cdb_branch_tag;
    logic cdb_branch_resolved, cdb_branch_correct;
    logic ex_actual_taken, update_pht, ex_is_jalr, ex_is_ret, ex_is_branch;
    logic [XLEN-1:0] ex_actual_target_address, ex_pc;

    logic ex_alu1_valid, ex_alu1_regwrite;
    logic [XLEN-1:0] ex_alu1_result;
    logic [PRF_ADDRESS-1:0] ex_alu1_prd;
    logic [ROB_PTR_SIZE-1:0] ex_alu1_rob_index;
    logic ex_alu2_valid, ex_alu2_regwrite;
    logic [XLEN-1:0] ex_alu2_result;
    logic [PRF_ADDRESS-1:0] ex_alu2_prd;
    logic [ROB_PTR_SIZE-1:0] ex_alu2_rob_index;
    logic ex_mul_valid;
    logic [XLEN-1:0] ex_mul_result;
    logic [PRF_ADDRESS-1:0] ex_mul_prd;
    logic [ROB_PTR_SIZE-1:0] ex_mul_rob_index;
    logic cdb_mul_busy;
    logic ex_div_valid;
    logic [XLEN-1:0] ex_div_result;
    logic [PRF_ADDRESS-1:0] ex_div_prd;
    logic [ROB_PTR_SIZE-1:0] ex_div_rob_index;
    logic cdb_div_busy;
    logic ex_mem_address1_available, ex_is_load1, ex_is_store1;
    logic [XLEN-1:0] ex_mem_address1;

    logic mul_ack, div_ack;

    // ============================================================================
    // CDB ARBITER SIGNALS (single writeback bus feeding PRF/ROB/IQ/LSQ)
    // ============================================================================
    logic cdb1_valid, cdb2_valid;
    logic [XLEN-1:0] cdb1_result, cdb2_result;
    logic [PRF_ADDRESS-1:0] cdb1_prd, cdb2_prd;
    logic [ROB_PTR_SIZE-1:0] cdb1_rob_index, cdb2_rob_index;
    logic lsq_ack, stall_issue;

    logic [31:0][PRF_ADDRESS-1:0] amt_state;
    logic comm_free_push1, comm_free_push2;
    logic [PRF_ADDRESS-1:0] comm_free_reg1, comm_free_reg2;

    // ============================================================================
    // MODULE INSTANTIATIONS
    // ============================================================================

    PD_Stage #(
        .PHT_ADDRESS (PHT_ADDRESS),
        .GHR_SIZE    (GHR_SIZE),
        .XLEN        (XLEN),
        .RAS_ADDRESS (RAS_ADDRESS)
    ) pd_stage_inst (
        .CLK                      (CLK),
        .reset                    (reset),
        .stall_frontend           (stall_frontend),
        .ex_actual_taken          (ex_actual_taken),
        .restore_ghr              (ex_flush), // GAP 1
        .restore_ras              (ex_flush), // GAP 1
        .update_pht               (update_pht),
        .ex_is_jalr               (ex_is_jalr),
        .ex_is_ret                (ex_is_ret),
        .ex_is_branch             (ex_is_branch),
        .flush                    (ex_flush),
        .rob_global_flush         (rob_global_flush),
        .if_predecode_instr1      (if_predecode_instr1),
        .if_predecode_instr2      (if_predecode_instr2),
        .ex_actual_target_address (ex_actual_target_address),
        .if_target_address        (if_target_address),
        .if_pc                    (pd_pc),
        .ex_pc                    (ex_pc),
        .ghr_snap                 (id_biq_restore_ghr),
        .rb_pht_index             (id_biq_pht_index),
        .rb_sp_snap               (id_biq_sp_snap),
        .rb_ras_snap              (id_biq_ras_snap),
        .rob_flush_pc             (rob_flush_pc),

        .pd_pred_taken            (pd_pred_taken),
        .pd_btb_hit               (pd_btb_hit),
        .pd_valid1                (pd_valid1),
        .pd_valid2                (pd_valid2),
        .pd_pc                    (pd_pc),
        .pd_pred_target           (pd_pred_target),
        .pd_pht_index             (pd_pht_index),
        .pd_sp_snap               (pd_sp_snap),
        .pd_ras_snap              (pd_ras_snap),
        .pd_prev_ghr              (pd_prev_ghr)
    );

    IF_Stage #(
        .PHT_ADDRESS (PHT_ADDRESS),
        .GHR_SIZE    (GHR_SIZE),
        .XLEN        (XLEN),
        .RAS_ADDRESS (RAS_ADDRESS)
    ) if_stage_inst (
        .CLK                  (CLK),
        .reset                (reset),
        .flush                (ex_flush),
        .rob_global_flush     (rob_global_flush),
        .pd_valid1            (pd_valid1),
        .pd_valid2            (pd_valid2),
        .stall_frontend       (stall_frontend),
        .pd_pred_taken        (pd_pred_taken),
        .pd_btb_hit           (pd_btb_hit),
        .pd_pc                (pd_pc),
        .pd_pred_target       (pd_pred_target),
        .pd_pht_index         (pd_pht_index),
        .pd_sp_snap           (pd_sp_snap),
        .pd_ras_snap          (pd_ras_snap),
        .pd_prev_ghr          (pd_prev_ghr),

        .if_pred_taken        (if_pred_taken),
        .if_btb_hit           (if_btb_hit),
        .if_valid1            (if_valid1),
        .if_valid2            (if_valid2),
        .if_predecode_instr1  (if_predecode_instr1),
        .if_predecode_instr2  (if_predecode_instr2),
        .if_instr1            (if_instr1),
        .if_instr2            (if_instr2),
        .if_pred_target       (if_pred_target),
        .if_pc                (if_pc),
        .if_pht_index         (if_pht_index),
        .if_sp_snap           (if_sp_snap),
        .if_ras_snap          (if_ras_snap),
        .if_prev_ghr          (if_prev_ghr)
    );

    ID_Stage #(
        .OPCODE_SIZE         (OPCODE_SIZE),
        .PHT_ADDRESS         (PHT_ADDRESS),
        .GHR_SIZE            (GHR_SIZE),
        .XLEN                (XLEN),
        .RAS_ADDRESS         (RAS_ADDRESS),
        .INIT_IMMEDIATE_SIZE (INIT_IMMEDIATE_SIZE),
        .BIQ_ADDRESS         (BIQ_ADDRESS)
    ) id_stage_inst (
        .CLK                 (CLK),
        .reset               (reset),
        .flush               (ex_flush),
        .rob_global_flush    (rob_global_flush),
        .stall_frontend      (stall_frontend),
        .rr_biq_id           (rr_biq_id),
        .dis_biq_dealloc     (dis_biq_dealloc),
        .if_pred_taken       (if_pred_taken),
        .if_valid1           (if_valid1),
        .if_valid2           (if_valid2),
        .if_instr1           (if_instr1),
        .if_instr2           (if_instr2),
        .if_pred_target      (if_pred_target),
        .if_pc               (if_pc),
        .if_pht_index        (if_pht_index),
        .if_sp_snap          (if_sp_snap),
        .if_ras_snap         (if_ras_snap),
        .if_prev_ghr         (if_prev_ghr),

        .id_biq_sp_snap      (id_biq_sp_snap),
        .id_biq_ras_snap     (id_biq_ras_snap),
        .id_stall_frontend   (id_stall_frontend),
        .id_take_snap        (id_take_snap),
        .id_valid1           (id_valid1),
        .id_valid2           (id_valid2),
        .id_rs1_1            (id_rs1_1),
        .id_rs2_1            (id_rs2_1),
        .id_rd_1             (id_rd_1),
        .id_rs1_2            (id_rs1_2),
        .id_rs2_2            (id_rs2_2),
        .id_rd_2             (id_rd_2),
        .id_immout1          (id_immout1),
        .id_immout2          (id_immout2),
        .id_biq_address      (id_biq_address),
        .id_biq_pred_target  (id_biq_pred_target),
        .id_pc               (id_pc),
        .id_biq_restore_ghr  (id_biq_restore_ghr),
        .id_biq_pht_index    (id_biq_pht_index),
        .id_alu_operation1   (id_alu_operation1),
        .id_alu_operation2   (id_alu_operation2),
        .id_is_m_extension1  (id_is_m_extension1),
        .id_is_m_extension2  (id_is_m_extension2),
        .id_jump_reg1        (id_jump_reg1),
        .id_jump_reg2        (id_jump_reg2),
        .id_jump1            (id_jump1),
        .id_jump2            (id_jump2),
        .id_branch1          (id_branch1),
        .id_branch2          (id_branch2),
        .id_regsrc1_1        (id_regsrc1_1),
        .id_immtype1         (id_immtype1),
        .id_memwrite1        (id_memwrite1),
        .id_immtype2         (id_immtype2),
        .id_biq_valid        (id_biq_valid),
        .id_biq_pred_taken   (id_biq_pred_taken),
        .id_regsrc2_1        (id_regsrc2_1),
        .id_regsrc1_2        (id_regsrc1_2),
        .id_regsrc2_2        (id_regsrc2_2),
        .id_upperimm1        (id_upperimm1),
        .id_upperimm2        (id_upperimm2),
        .id_regwrite1        (id_regwrite1),
        .id_regwrite2        (id_regwrite2),
        .id_memwrite2        (id_memwrite2),
        .id_memtoreg1        (id_memtoreg1),
        .id_memtoreg2        (id_memtoreg2),
        .id_retaddr1         (id_retaddr1),
        .id_retaddr2         (id_retaddr2),
        .id_isimm1           (id_isimm1),
        .id_isimm2           (id_isimm2),
        .id_memory_type1     (id_memory_type1),
        .id_memory_type2     (id_memory_type2),
        .id_memory_sign_ext1 (id_memory_sign_ext1),
        .id_memory_sign_ext2 (id_memory_sign_ext2)
    );

    RN_Stage #(
        .PRF_ADDRESS         (PRF_ADDRESS),
        .INIT_IMMEDIATE_SIZE (INIT_IMMEDIATE_SIZE),
        .MAX_BRANCHES        (MAX_BRANCHES),
        .BTAG_SIZE           (BTAG_SIZE),
        .BIQ_ADDRESS         (BIQ_ADDRESS),
        .XLEN                (XLEN),
        .NUM_PHY_REG         (NUM_PHY_REG),
        .FL_ROWS             (FL_ROWS),
        .FL_INDEX_WIDTH      (FL_INDEX_WIDTH),
        .FL_PTR_WIDTH        (FL_PTR_WIDTH)
    ) rn_stage_inst (
        .CLK                 (CLK),
        .reset               (reset),
        .flush               (ex_flush),
        .rob_global_flush    (rob_global_flush),
        .id_take_snap        (id_take_snap),
        .id_valid1           (id_valid1),
        .id_valid2           (id_valid2),
        .cdb_wakeup1         (cdb1_valid),
        .cdb_wakeup2         (cdb2_valid),

        .amt_state           (amt_state),          
        .comm_free_push1     (comm_free_push1),   
        .comm_free_push2     (comm_free_push2),    
        .cdb_branch_resolved (cdb_branch_resolved),
        .comm_free_reg1      (comm_free_reg1),    
        .comm_free_reg2      (comm_free_reg2),   

        .id_is_m_extension1  (id_is_m_extension1), .id_is_m_extension2(id_is_m_extension2),
        .id_jump_reg1        (id_jump_reg1), .id_jump_reg2(id_jump_reg2),
        .id_jump1            (id_jump1), .id_jump2(id_jump2),
        .id_branch1          (id_branch1), .id_branch2(id_branch2),
        .id_regsrc1_1        (id_regsrc1_1), .id_immtype1(id_immtype1), .id_memwrite1(id_memwrite1),
        .id_immtype2         (id_immtype2), .id_regsrc2_1(id_regsrc2_1),
        .id_regsrc1_2        (id_regsrc1_2), .id_regsrc2_2(id_regsrc2_2),
        .id_upperimm1        (id_upperimm1), .id_upperimm2(id_upperimm2),
        .id_regwrite1        (id_regwrite1), .id_regwrite2(id_regwrite2),
        .id_memwrite2        (id_memwrite2), .id_memtoreg1(id_memtoreg1), .id_memtoreg2(id_memtoreg2),
        .id_retaddr1         (id_retaddr1), .id_retaddr2(id_retaddr2),
        .id_isimm1           (id_isimm1), .id_isimm2(id_isimm2),

        .cdb_waked_reg1      (cdb1_prd),
        .cdb_waked_reg2      (cdb2_prd),
        .cdb_branch_tag      (cdb_branch_tag),

        .id_rs1_1            (id_rs1_1), .id_rs2_1(id_rs2_1), .id_rd_1(id_rd_1),
        .id_rs1_2            (id_rs1_2), .id_rs2_2(id_rs2_2), .id_rd_2(id_rd_2),
        .id_immout1          (id_immout1), .id_immout2(id_immout2),
        .id_biq_address      (id_biq_address),
        .id_pc               (id_pc),
        .id_alu_operation1   (id_alu_operation1), .id_alu_operation2(id_alu_operation2),
        .id_memory_type1     (id_memory_type1), .id_memory_type2(id_memory_type2),
        .id_memory_sign_ext1 (id_memory_sign_ext1), .id_memory_sign_ext2(id_memory_sign_ext2),

        .stall_frontend      (stall_frontend),
        .rn_stall_frontend   (rn_stall_frontend),
        .rn_prd1             (rn_prd1), .rn_prs1_1(rn_prs1_1), .rn_prs2_1(rn_prs2_1), .rn_old_prd1(rn_old_prd1),
        .rn_prd2             (rn_prd2), .rn_prs1_2(rn_prs1_2), .rn_prs2_2(rn_prs2_2), .rn_old_prd2(rn_old_prd2),
        .rn_prs1_busy1       (rn_prs1_busy1), .rn_prs2_busy1(rn_prs2_busy1), .rn_prs1_busy2(rn_prs1_busy2), .rn_prs2_busy2(rn_prs2_busy2),
        .rn_branch_tag       (rn_branch_tag),
        .rn_branch_mask      (rn_branch_mask),
        .rn_biq_address      (rn_biq_address),
        .rn_pc               (rn_pc),
        .rn_rd_1             (rn_rd_1), .rn_rd_2(rn_rd_2),
        .rn_immout1          (rn_immout1), .rn_immout2(rn_immout2),
        .rn_is_m_extension1  (rn_is_m_extension1), .rn_is_m_extension2(rn_is_m_extension2),
        .rn_alu_operation1   (rn_alu_operation1), .rn_alu_operation2(rn_alu_operation2),

        .rn_valid1           (rn_valid1), .rn_jump_reg1(rn_jump_reg1), .rn_jump1(rn_jump1), .rn_branch1(rn_branch1),
        .rn_regsrc1_1        (rn_regsrc1_1), .rn_regsrc2_1(rn_regsrc2_1), .rn_immtype1(rn_immtype1), .rn_isimm1(rn_isimm1), .rn_retaddr1(rn_retaddr1),
        .rn_upperimm1        (rn_upperimm1), .rn_regwrite1(rn_regwrite1), .rn_memwrite1(rn_memwrite1), .rn_memtoreg1(rn_memtoreg1),
        .rn_memory_type1     (rn_memory_type1), .rn_memory_sign_ext1(rn_memory_sign_ext1),

        .rn_valid2           (rn_valid2), .rn_jump_reg2(rn_jump_reg2), .rn_jump2(rn_jump2), .rn_branch2(rn_branch2),
        .rn_regsrc1_2        (rn_regsrc1_2), .rn_regsrc2_2(rn_regsrc2_2), .rn_immtype2(rn_immtype2), .rn_isimm2(rn_isimm2), .rn_retaddr2(rn_retaddr2),
        .rn_upperimm2        (rn_upperimm2), .rn_regwrite2(rn_regwrite2), .rn_memwrite2(rn_memwrite2), .rn_memtoreg2(rn_memtoreg2),
        .rn_memory_type2     (rn_memory_type2), .rn_memory_sign_ext2(rn_memory_sign_ext2)
    );

    DIS_Stage #(
        .XLEN                (XLEN),
        .PRF_ADDRESS         (PRF_ADDRESS),
        .BIQ_ADDRESS         (BIQ_ADDRESS),
        .ROB_SIZE            (ROB_SIZE),
        .INIT_IMMEDIATE_SIZE (INIT_IMMEDIATE_SIZE),
        .ROB_PTR_SIZE        (ROB_PTR_SIZE),
        .MAX_BRANCHES        (MAX_BRANCHES),
        .BTAG_SIZE           (BTAG_SIZE),
        .LQ_ENTRIES          (LQ_ENTRIES),
        .LQ_ADDRESS          (LQ_ADDRESS),
        .SQ_ENTRIES          (SQ_ENTRIES),
        .SQ_ADDRESS          (SQ_ADDRESS)
    ) dis_stage_inst (
        .CLK                 (CLK),
        .reset               (reset),
        .flush               (ex_flush),
        .stall_frontend      (stall_frontend),
        .cdb_mul_busy        (cdb_mul_busy),
        .cdb_div_busy        (cdb_div_busy),
        .stall_issue         (stall_issue),
        .dis_stall_frontend  (dis_stall_frontend),
        .cdb_done1           (cdb1_valid), .cdb_done2(cdb2_valid),
        .cdb_wakeup1         (cdb1_valid), .cdb_wakeup2(cdb2_valid),
        .cdb_branch_resolved (cdb_branch_resolved),
        .cdb_waked_reg1      (cdb1_prd), .cdb_waked_reg2(cdb2_prd),
        .cdb_branch_tag      (cdb_branch_tag),
        .cdb_rob_index1      (cdb1_rob_index), .cdb_rob_index2(cdb2_rob_index),

        .rn_prd1             (rn_prd1), .rn_prs1_1(rn_prs1_1), .rn_prs2_1(rn_prs2_1), .rn_old_prd1(rn_old_prd1),
        .rn_prd2             (rn_prd2), .rn_prs1_2(rn_prs1_2), .rn_prs2_2(rn_prs2_2), .rn_old_prd2(rn_old_prd2),
        .rn_prs1_busy1       (rn_prs1_busy1), .rn_prs2_busy1(rn_prs2_busy1), .rn_prs1_busy2(rn_prs1_busy2), .rn_prs2_busy2(rn_prs2_busy2),
        .rn_branch_tag       (rn_branch_tag),
        .rn_branch_mask      (rn_branch_mask),
        .rn_biq_address      (rn_biq_address),
        .rn_pc               (rn_pc),
        .rn_rd_1             (rn_rd_1), .rn_rd_2(rn_rd_2),
        .rn_immout1          (rn_immout1), .rn_immout2(rn_immout2),
        .rn_is_m_extension1  (rn_is_m_extension1), .rn_is_m_extension2(rn_is_m_extension2),
        .rn_memory_type1     (rn_memory_type1), .rn_memory_type2(rn_memory_type2),
        .rn_memory_sign_ext1 (rn_memory_sign_ext1), .rn_memory_sign_ext2(rn_memory_sign_ext2),
        .rn_alu_operation1   (rn_alu_operation1), .rn_alu_operation2(rn_alu_operation2),

        .rn_valid1           (rn_valid1), .rn_jump_reg1(rn_jump_reg1), .rn_jump1(rn_jump1), .rn_branch1(rn_branch1),
        .rn_regsrc1_1        (rn_regsrc1_1), .rn_regsrc2_1(rn_regsrc2_1), .rn_immtype1(rn_immtype1), .rn_isimm1(rn_isimm1), .rn_retaddr1(rn_retaddr1),
        .rn_upperimm1        (rn_upperimm1), .rn_regwrite1(rn_regwrite1), .rn_memwrite1(rn_memwrite1), .rn_memtoreg1(rn_memtoreg1),

        .rn_valid2           (rn_valid2), .rn_jump_reg2(rn_jump_reg2), .rn_jump2(rn_jump2), .rn_branch2(rn_branch2),
        .rn_regsrc1_2        (rn_regsrc1_2), .rn_regsrc2_2(rn_regsrc2_2), .rn_immtype2(rn_immtype2), .rn_isimm2(rn_isimm2), .rn_retaddr2(rn_retaddr2),
        .rn_upperimm2        (rn_upperimm2), .rn_regwrite2(rn_regwrite2), .rn_memwrite2(rn_memwrite2), .rn_memtoreg2(rn_memtoreg2),

        .rn_is_load1         (rn_is_load1), .rn_is_load2(rn_is_load2),
        .rn_is_store1        (rn_is_store1), .rn_is_store2(rn_is_store2),
        .rn_rob_index1       (rn_rob_index1_stub), .rn_rob_index2(rn_rob_index2_stub), // GAP 3

        .cdb_branch_rob_index (cdb_branch_rob_index), // GAP 8

        .cdb_address_available1 (cdb_address_available1), .cdb_is_load1(cdb_is_load1), // GAP 4
        .cdb_lq_index1           (cdb_lq_index1), .cdb_memory_address1(cdb_memory_address1),
        .cdb_address_available2 (cdb_address_available2), .cdb_is_load2(cdb_is_load2),
        .cdb_lq_index2           (cdb_lq_index2), .cdb_memory_address2(cdb_memory_address2),

        .ex_mem_address1_available (ex_mem_address1_available), .ex_is_load1(ex_is_load1), .ex_is_store1(ex_is_store1),
        .ex_mem_address1         (ex_mem_address1), .ex_lq_index1(ex_lq_index1), .ex_sq_index1(ex_sq_index1), // GAP 5
        .ex_mem_address2_available (ex_mem_address2_available), .ex_is_load2(ex_is_load2), .ex_is_store2(ex_is_store2),
        .ex_mem_address2         (ex_mem_address2), .ex_lq_index2(ex_lq_index2), .ex_sq_index2(ex_sq_index2), // GAP 5

        .cdb_result1_available (cdb1_valid), .cdb_result2_available(cdb2_valid),
        .cdb_result1_broadcast (cdb1_result), .cdb_result2_broadcast(cdb2_result),

        .mem_lq_write        (mem_lq_write),
        .mem_lq_index        (mem_lq_index),
        .mem_read_data       (mem_read_data),
        .lsq_ack             (lsq_ack),

        .commit_instr1       (commit_instr1), .commit_instr2(commit_instr2),
        .dis_free_old_prd1   (dis_free_old_prd1), .dis_free_old_prd2(dis_free_old_prd2),
        .comm_prd1           (comm_prd1), .comm_prd2(comm_prd2),
        .comm_rd1            (comm_rd1), .comm_rd2(comm_rd2),

        .iss_valid1          (iss_valid1), .iss_is_m_extension1(iss_is_m_extension1), .iss_jump_reg1(iss_jump_reg1), .iss_jump1(iss_jump1), .iss_branch1(iss_branch1),
        .iss_instr1_regsrc1  (iss_instr1_regsrc1), .iss_instr1_regsrc2(iss_instr1_regsrc2), .iss_immtype1(iss_immtype1), .iss_isimm1(iss_isimm1), .iss_retaddr1(iss_retaddr1),
        .iss_upperimm1       (iss_upperimm1), .iss_regwrite1(iss_regwrite1), .iss_memwrite1(iss_memwrite1), .iss_memtoreg1(iss_memtoreg1),
        .iss_pc1             (iss_pc1),
        .iss_prd1            (iss_prd1), .iss_instr1_prs1(iss_instr1_prs1), .iss_instr1_prs2(iss_instr1_prs2),
        .iss_immediate1      (iss_immediate1),
        .iss_alu_operation1  (iss_alu_operation1),
        .iss_branch_tag1     (iss_branch_tag1),
        .iss_branch_mask1    (iss_branch_mask1),
        .iss_biq_address1    (iss_biq_address1),
        .iss_rob_index1      (iss_rob_index1),

        .iss_valid2          (iss_valid2), .iss_is_m_extension2(iss_is_m_extension2), .iss_jump_reg2(iss_jump_reg2), .iss_jump2(iss_jump2), .iss_branch2(iss_branch2),
        .iss_instr2_regsrc1  (iss_instr2_regsrc1), .iss_instr2_regsrc2(iss_instr2_regsrc2), .iss_immtype2(iss_immtype2), .iss_isimm2(iss_isimm2), .iss_retaddr2(iss_retaddr2),
        .iss_upperimm2       (iss_upperimm2), .iss_regwrite2(iss_regwrite2), .iss_memwrite2(iss_memwrite2), .iss_memtoreg2(iss_memtoreg2),
        .iss_pc2             (iss_pc2),
        .iss_prd2            (iss_prd2), .iss_instr2_prs1(iss_instr2_prs1), .iss_instr2_prs2(iss_instr2_prs2),
        .iss_immediate2      (iss_immediate2),
        .iss_alu_operation2  (iss_alu_operation2),
        .iss_branch_tag2     (iss_branch_tag2),
        .iss_branch_mask2    (iss_branch_mask2),
        .iss_biq_address2    (iss_biq_address2),
        .iss_rob_index2      (iss_rob_index2),

        .lsq_mem_write         (lsq_mem_write),
        .lsq_mem_read          (lsq_mem_read),
        .lsq_memory_address    (lsq_memory_address),
        .lsq_mem_write_data    (lsq_mem_write_data),
        .lsq_mem_size          (lsq_mem_size),
        .lsq_mem_sign_ext      (lsq_mem_sign_ext),
        .lsq_write_prf         (lsq_write_prf),
        .lsq_write_prf_data    (lsq_write_prf_data),
        .lsq_write_prf_address (lsq_write_prf_address),
        .lsq_lq_index          (lsq_lq_index),
        .rob_global_flush      (rob_global_flush),
        .rob_flush_pc          (rob_flush_pc),
        .lsq_rob_index         (lsq_rob_index)
    );

    RR_Stage #(
        .XLEN                (XLEN),
        .MAX_BRANCHES        (MAX_BRANCHES),
        .BTAG_SIZE           (BTAG_SIZE),
        .PRF_ADDRESS         (PRF_ADDRESS),
        .INIT_IMMEDIATE_SIZE (INIT_IMMEDIATE_SIZE),
        .BIQ_ADDRESS         (BIQ_ADDRESS),
        .ROB_SIZE            (ROB_SIZE),
        .ROB_PTR_SIZE        (ROB_PTR_SIZE)
    ) rr_stage_inst (
        .CLK                 (CLK),
        .reset               (reset),
        .flush               (ex_flush),
        .rob_global_flush    (rob_global_flush),

        .cdb_regwrite1       (cdb1_valid),
        .cdb_regwrite2       (cdb2_valid),
        .cdb_branch_tag      (cdb_branch_tag),
        .cdb_write_address1  (cdb1_prd),
        .cdb_write_address2  (cdb2_prd),
        .cdb_write_data1     (cdb1_result),
        .cdb_write_data2     (cdb2_result),

        .iss_valid1          (iss_valid1), .iss_is_m_extension1(iss_is_m_extension1), .iss_jump_reg1(iss_jump_reg1), .iss_jump1(iss_jump1), .iss_branch1(iss_branch1),
        .iss_instr1_regsrc1  (iss_instr1_regsrc1), .iss_instr1_regsrc2(iss_instr1_regsrc2), .iss_immtype1(iss_immtype1), .iss_isimm1(iss_isimm1), .iss_retaddr1(iss_retaddr1),
        .iss_upperimm1       (iss_upperimm1), .iss_regwrite1(iss_regwrite1), .iss_memwrite1(iss_memwrite1), .iss_memtoreg1(iss_memtoreg1),
        .iss_pc1             (iss_pc1),
        .iss_prd1            (iss_prd1), .iss_instr1_prs1(iss_instr1_prs1), .iss_instr1_prs2(iss_instr1_prs2),
        .iss_immediate1      (iss_immediate1),
        .iss_alu_operation1  (iss_alu_operation1),
        .iss_branch_tag1     (iss_branch_tag1),
        .iss_branch_mask1    (iss_branch_mask1),
        .iss_biq_address1    (iss_biq_address1),
        .iss_rob_index1      (iss_rob_index1),

        .iss_valid2          (iss_valid2), .iss_is_m_extension2(iss_is_m_extension2), .iss_jump_reg2(iss_jump_reg2), .iss_jump2(iss_jump2), .iss_branch2(iss_branch2),
        .iss_instr2_regsrc1  (iss_instr2_regsrc1), .iss_instr2_regsrc2(iss_instr2_regsrc2), .iss_immtype2(iss_immtype2), .iss_isimm2(iss_isimm2), .iss_retaddr2(iss_retaddr2),
        .iss_upperimm2       (iss_upperimm2), .iss_regwrite2(iss_regwrite2), .iss_memwrite2(iss_memwrite2), .iss_memtoreg2(iss_memtoreg2),
        .iss_pc2             (iss_pc2),
        .iss_prd2            (iss_prd2), .iss_instr2_prs1(iss_instr2_prs1), .iss_instr2_prs2(iss_instr2_prs2),
        .iss_immediate2      (iss_immediate2),
        .iss_alu_operation2  (iss_alu_operation2),
        .iss_branch_tag2     (iss_branch_tag2),
        .iss_branch_mask2    (iss_branch_mask2),
        .iss_biq_address2    (iss_biq_address2),
        .iss_rob_index2      (iss_rob_index2),

        .rr_instr1_read_data1 (rr_instr1_read_data1), .rr_instr1_read_data2(rr_instr1_read_data2),
        .rr_instr1_prs1       (rr_instr1_prs1), .rr_instr1_prs2(rr_instr1_prs2),
        .rr_valid1            (rr_valid1), .rr_is_m_extension1(rr_is_m_extension1), .rr_jump_reg1(rr_jump_reg1), .rr_jump1(rr_jump1), .rr_branch1(rr_branch1),
        .rr_instr1_regsrc1    (rr_instr1_regsrc1), .rr_instr1_regsrc2(rr_instr1_regsrc2), .rr_isimm1(rr_isimm1), .rr_retaddr1(rr_retaddr1), .rr_upperimm1(rr_upperimm1),
        .rr_regwrite1         (rr_regwrite1), .rr_memwrite1(rr_memwrite1), .rr_memtoreg1(rr_memtoreg1),
        .rr_pc1               (rr_pc1),
        .rr_prd1              (rr_prd1),
        .rr_immediate1        (rr_immediate1),
        .rr_alu_operation1    (rr_alu_operation1),
        .rr_branch_tag1       (rr_branch_tag1),
        .rr_branch_mask1      (rr_branch_mask1),
        .rr_biq_address1      (rr_biq_address1),
        .rr_rob_index1        (rr_rob_index1),

        .rr_instr2_read_data1 (rr_instr2_read_data1), .rr_instr2_read_data2(rr_instr2_read_data2),
        .rr_instr2_prs1       (rr_instr2_prs1), .rr_instr2_prs2(rr_instr2_prs2),
        .rr_valid2            (rr_valid2), .rr_is_m_extension2(rr_is_m_extension2), .rr_jump_reg2(rr_jump_reg2), .rr_jump2(rr_jump2), .rr_branch2(rr_branch2),
        .rr_instr2_regsrc1    (rr_instr2_regsrc1), .rr_instr2_regsrc2(rr_instr2_regsrc2), .rr_isimm2(rr_isimm2), .rr_retaddr2(rr_retaddr2), .rr_upperimm2(rr_upperimm2),
        .rr_regwrite2         (rr_regwrite2), .rr_memwrite2(rr_memwrite2), .rr_memtoreg2(rr_memtoreg2),
        .rr_pc2               (rr_pc2),
        .rr_prd2              (rr_prd2),
        .rr_immediate2        (rr_immediate2),
        .rr_alu_operation2    (rr_alu_operation2),
        .rr_branch_tag2       (rr_branch_tag2),
        .rr_branch_mask2      (rr_branch_mask2),
        .rr_biq_address2      (rr_biq_address2),
        .rr_rob_index2        (rr_rob_index2)
    );

    EX_Stage #(
        .XLEN         (XLEN),
        .PRF_ADDRESS  (PRF_ADDRESS),
        .ROB_PTR_SIZE (ROB_PTR_SIZE),
        .MAX_BRANCHES (MAX_BRANCHES),
        .BTAG_SIZE    (BTAG_SIZE),
        .BIQ_ADDRESS  (BIQ_ADDRESS)
    ) ex_stage_inst (
        .CLK               (CLK),
        .reset             (reset),
        .rob_global_flush  (rob_global_flush),
        .mul_ack           (mul_ack),
        .div_ack           (div_ack),
        .biq_pred_taken1   (id_biq_pred_taken), // GAP 6
        .biq_pred_taken2   (id_biq_pred_taken), // GAP 6
        .biq_pred_target1  (id_biq_pred_target), // GAP 6
        .biq_pred_target2  (id_biq_pred_target), // GAP 6
        .rr_instr1_read_data1 (rr_instr1_read_data1), .rr_instr1_read_data2(rr_instr1_read_data2),
        .rr_instr2_read_data1 (rr_instr2_read_data1), .rr_instr2_read_data2(rr_instr2_read_data2),
        .rr_instr1_prs1    (rr_instr1_prs1), .rr_instr1_prs2(rr_instr1_prs2),
        .rr_instr2_prs1    (rr_instr2_prs1), .rr_instr2_prs2(rr_instr2_prs2),

        .rr_valid1         (rr_valid1), .rr_is_m_extension1(rr_is_m_extension1), .rr_jump_reg1(rr_jump_reg1), .rr_jump1(rr_jump1), .rr_branch1(rr_branch1),
        .rr_instr1_regsrc1 (rr_instr1_regsrc1), .rr_instr1_regsrc2(rr_instr1_regsrc2), .rr_isimm1(rr_isimm1), .rr_retaddr1(rr_retaddr1), .rr_upperimm1(rr_upperimm1),
        .rr_regwrite1      (rr_regwrite1), .rr_memwrite1(rr_memwrite1), .rr_memtoreg1(rr_memtoreg1),
        .rr_pc1            (rr_pc1),
        .rr_prd1           (rr_prd1),
        .rr_immediate1     (rr_immediate1),
        .rr_alu_operation1 (rr_alu_operation1),
        .rr_branch_tag1    (rr_branch_tag1),
        .rr_branch_mask1   (rr_branch_mask1),
        .rr_biq_address1   (rr_biq_address1),
        .rr_rob_index1     (rr_rob_index1),

        .rr_valid2         (rr_valid2), .rr_is_m_extension2(rr_is_m_extension2), .rr_jump_reg2(rr_jump_reg2), .rr_jump2(rr_jump2), .rr_branch2(rr_branch2),
        .rr_instr2_regsrc1 (rr_instr2_regsrc1), .rr_instr2_regsrc2(rr_instr2_regsrc2), .rr_isimm2(rr_isimm2), .rr_retaddr2(rr_retaddr2), .rr_upperimm2(rr_upperimm2),
        .rr_regwrite2      (rr_regwrite2), .rr_memwrite2(rr_memwrite2), .rr_memtoreg2(rr_memtoreg2),
        .rr_pc2            (rr_pc2),
        .rr_prd2           (rr_prd2),
        .rr_immediate2     (rr_immediate2),
        .rr_alu_operation2 (rr_alu_operation2),
        .rr_branch_tag2    (rr_branch_tag2),
        .rr_branch_mask2   (rr_branch_mask2),
        .rr_biq_address2   (rr_biq_address2),
        .rr_rob_index2     (rr_rob_index2),

        .flush                     (ex_flush),
        .cdb_branch_tag             (cdb_branch_tag),
        .cdb_branch_resolved        (cdb_branch_resolved),
        .cdb_branch_correct         (cdb_branch_correct),
        .ex_actual_taken            (ex_actual_taken),
        .update_pht                 (update_pht),
        .ex_is_jalr                 (ex_is_jalr),
        .ex_is_ret                  (ex_is_ret),
        .ex_is_branch               (ex_is_branch),
        .ex_actual_target_address   (ex_actual_target_address),
        .ex_pc                      (ex_pc),

        .ex_alu1_valid     (ex_alu1_valid), .ex_alu1_regwrite(ex_alu1_regwrite),
        .ex_alu1_result    (ex_alu1_result),
        .ex_alu1_prd       (ex_alu1_prd),
        .ex_alu1_rob_index (ex_alu1_rob_index),
        .ex_alu2_valid     (ex_alu2_valid), .ex_alu2_regwrite(ex_alu2_regwrite),
        .ex_alu2_result    (ex_alu2_result),
        .ex_alu2_prd       (ex_alu2_prd),
        .ex_alu2_rob_index (ex_alu2_rob_index),
        .ex_mul_valid      (ex_mul_valid),
        .ex_mul_result     (ex_mul_result),
        .ex_mul_prd        (ex_mul_prd),
        .ex_mul_rob_index  (ex_mul_rob_index),
        .cdb_mul_busy      (cdb_mul_busy),
        .ex_div_valid      (ex_div_valid),
        .ex_div_result     (ex_div_result),
        .ex_div_prd        (ex_div_prd),
        .ex_div_rob_index  (ex_div_rob_index),
        .cdb_div_busy      (cdb_div_busy),
        .ex_mem_address1_available (ex_mem_address1_available), .ex_is_load1(ex_is_load1), .ex_is_store1(ex_is_store1),
        .ex_mem_address1   (ex_mem_address1)
    );

    MEM_Stage #(
        .XLEN       (XLEN),
        .LQ_ADDRESS (LQ_ADDRESS),
        .RAM_DEPTH  (RAM_DEPTH),
        .RAM_ADDRESS(RAM_ADDRESS)
    ) mem_stage_inst (
        .CLK                (CLK),
        .reset              (reset),
        .rob_global_flush   (rob_global_flush),
        .lsq_mem_write      (lsq_mem_write),
        .lsq_mem_read       (lsq_mem_read),
        .lsq_memory_address (lsq_memory_address),
        .lsq_mem_write_data (lsq_mem_write_data),
        .lsq_mem_size       (lsq_mem_size),
        .lsq_mem_sign_ext   (lsq_mem_sign_ext),
        .lsq_lq_index       (lsq_lq_index),

        .mem_lq_write       (mem_lq_write),
        .mem_lq_index       (mem_lq_index),
        .mem_read_data      (mem_read_data)
    );

    CDB_Arbiter #(
        .XLEN         (XLEN),
        .PRF_ADDRESS  (PRF_ADDRESS),
        .ROB_PTR_SIZE (ROB_PTR_SIZE)
    ) cdb_arbiter_inst (
        .alu1_valid     (ex_alu1_valid),
        .alu1_result    (ex_alu1_result),
        .alu1_prd       (ex_alu1_prd),
        .alu1_rob_index (ex_alu1_rob_index),

        .alu2_valid     (ex_alu2_valid),
        .alu2_result    (ex_alu2_result),
        .alu2_prd       (ex_alu2_prd),
        .alu2_rob_index (ex_alu2_rob_index),

        .lsq_valid      (lsq_write_prf),
        .lsq_result     (lsq_write_prf_data),
        .lsq_prd        (lsq_write_prf_address),
        .lsq_rob_index  (lsq_rob_index),

        .mul_valid      (ex_mul_valid),
        .mul_result     (ex_mul_result),
        .mul_prd        (ex_mul_prd),
        .mul_rob_index  (ex_mul_rob_index),

        .div_valid      (ex_div_valid),
        .div_result     (ex_div_result),
        .div_prd        (ex_div_prd),
        .div_rob_index  (ex_div_rob_index),

        .cdb1_valid     (cdb1_valid),
        .cdb1_result    (cdb1_result),
        .cdb1_prd       (cdb1_prd),
        .cdb1_rob_index (cdb1_rob_index),

        .cdb2_valid     (cdb2_valid),
        .cdb2_result    (cdb2_result),
        .cdb2_prd       (cdb2_prd),
        .cdb2_rob_index (cdb2_rob_index),

        .lsq_ack        (lsq_ack),
        .mul_ack        (mul_ack),
        .div_ack        (div_ack),
        .stall_issue    (stall_issue)
    );
    CM_Stage #(
        .XLEN(XLEN),
        .PRF_ADDRESS(PRF_ADDRESS)
    ) cm_stage_inst (
        .CLK(CLK),
        .reset(reset),
        .commit_instr1(commit_instr1),
        .commit_instr2(commit_instr2),
        .comm_rd1(comm_rd1),
        .comm_rd2(comm_rd2),
        .comm_prd1(comm_prd1),
        .comm_prd2(comm_prd2),
        .dis_free_old_prd1(dis_free_old_prd1),
        .dis_free_old_prd2(dis_free_old_prd2),
        
        .comm_free_push1(comm_free_push1),
        .comm_free_push2(comm_free_push2),
        .comm_free_reg1(comm_free_reg1),
        .comm_free_reg2(comm_free_reg2),
        .amt_state(amt_state)
    );
endmodule

// =================================================================================
// SUMMARY OF OPEN GAPS (see inline "GAP N:" comments above for detail):
//
//  1. restore_ghr/restore_ras tied to EX_Stage's single "flush" output --
//     confirm that's the intended restore trigger (vs. a dedicated signal).
//  2. if_target_address (PD_Stage's RAS push / BTB fallback target) is
//     computed here as if_pc+4; no module currently produces this value.
//  3. DIS_Stage's rn_rob_index1/2 input ports can't be sourced correctly
//     from outside DIS_Stage, since the real allocation pointer
//     (current_rob_index) is internal to DIS_Stage's own ROB instance.
//     Tied to 0 -- needs a DIS_Stage-side fix (expose current_rob_index, or
//     wire LSQ's rn_rob_index1/2 internally).
//  4. cdb_address_available1/2, cdb_is_load1/2, cdb_lq_index1/2,
//     cdb_memory_address1/2 on DIS_Stage look like duplicate/dead ports
//     (LSQ.sv declares ex_is_load1 twice) -- tied to 0.
//  5. EX_Stage only computes one AGU result (slot 1); slot 2's
//     ex_mem_address2*/ex_is_load2/ex_is_store2 and all four
//     ex_lq_index/ex_sq_index ports are tied to 0/'0 until EX_Stage grows a
//     second AGU path and LQ/SQ index tagging.
//  6. EX_Stage wants independent biq_pred_taken/target per slot, but BIQ
//     (inside ID_Stage) has one read port. Both slots see the same read
//     result, matching the documented single-branch-per-cycle limitation.
//  7. dis_biq_dealloc approximated as "any commit" since ROB doesn't expose
//     commit_is_branch1/2.
//  8. cdb_branch_rob_index derived from RR_Stage's rr_rob_index1/2 muxed by
//     rr_branch1, since EX_Stage doesn't output it directly.
//
// Also note: tb_main_datapath.sv still targets the OLD (flat) port list and
// will need to be rewritten to instantiate this CLK/reset-only version.
// =================================================================================