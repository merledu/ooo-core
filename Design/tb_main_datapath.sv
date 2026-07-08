module tb_main_datapath();

    // Parameters
    localparam XLEN                = 32;
    localparam OPCODE_SIZE         = 7;
    localparam PHT_ADDRESS         = 9;
    localparam GHR_SIZE            = 9;
    localparam RAS_ADDRESS         = 3;
    localparam INIT_IMMEDIATE_SIZE = 21;
    localparam BIQ_ADDRESS         = 5;
    localparam PRF_ADDRESS         = 6;
    localparam MAX_BRANCHES        = 4;
    localparam BTAG_SIZE           = $clog2(MAX_BRANCHES);
    localparam ROB_SIZE            = 64;
    localparam ROB_PTR_SIZE        = $clog2(ROB_SIZE);

    // Clock and Reset
    logic CLK, reset, flush;

    // Backend Predictor Updates
    logic actual_taken, mispredict, restore_ghr, restore_ras, update_pht;
    logic update_btb, update_ras, ex_is_ret, ex_is_branch, ex_is_jalr;
    logic branch_mispredicted; // New signal
    logic [XLEN-1:0] actual_target_address, ex_pc;
    logic [GHR_SIZE-1:0] ghr_snap;
    logic [PHT_ADDRESS-1:0] rb_pht_index;
    logic [RAS_ADDRESS-1:0] rb_sp_snap;
    logic [2*XLEN-1:0] rb_ras_snap;

    // Dispatch/RR
    logic dis_biq_dealloc;
    logic [BIQ_ADDRESS-1:0] rr_biq_id;
    logic rr_slot_id;

    // CDB & Commit Backend Signals
    logic cdb_done1, cdb_done2, cdb_wakeup1, cdb_wakeup2, cdb_branch_resolved, cdb_branch_correct;
    logic comm_free_push1, comm_free_push2;
    logic [PRF_ADDRESS-1:0] cdb_waked_reg1, cdb_waked_reg2, comm_free_reg1, comm_free_reg2;
    logic [BTAG_SIZE-1:0] cdb_branch_tag;
    logic [ROB_PTR_SIZE-1:0] cdb_rob_index1, cdb_rob_index2, cdb_branch_rob_index;

    // Output Signals
    logic stall_frontend;
    
    // BIQ Metadata Outputs
    logic id_biq_valid, id_biq_pred_taken;
    logic [XLEN-1:0] id_biq_pred_target; 
    logic [PHT_ADDRESS-1:0] id_biq_pht_index;
    logic [GHR_SIZE-1:0] id_biq_restore_ghr; 
    logic [RAS_ADDRESS-1:0] id_biq_sp_snap;
    logic [2*XLEN-1:0] id_biq_ras_snap;

    // Commit & Issue Outputs
    logic commit_instr1, commit_instr2;
    logic [PRF_ADDRESS-1:0] dis_free_old_prd1, dis_free_old_prd2, comm_prd1, comm_prd2;
    logic [4:0] comm_rd1, comm_rd2;
    
    // Issue Signals (Instruction 1 & 2)
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

    // DUT Instantiation
    main_datapath #(
        .XLEN(XLEN), .OPCODE_SIZE(OPCODE_SIZE), .PHT_ADDRESS(PHT_ADDRESS), 
        .GHR_SIZE(GHR_SIZE), .RAS_ADDRESS(RAS_ADDRESS), 
        .INIT_IMMEDIATE_SIZE(INIT_IMMEDIATE_SIZE), .BIQ_ADDRESS(BIQ_ADDRESS),
        .PRF_ADDRESS(PRF_ADDRESS), .MAX_BRANCHES(MAX_BRANCHES),
        .ROB_SIZE(ROB_SIZE)
    ) dut (.*);

    // Clock Generation
    always #5 CLK = ~CLK;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_main_datapath);
        
        // Initialization
        CLK = 0; reset = 1; flush = 0;
        {actual_taken, mispredict, restore_ghr, restore_ras, update_pht, update_btb, update_ras, ex_is_ret, ex_is_branch, ex_is_jalr, branch_mispredicted} = '0;
        {dis_biq_dealloc, rr_slot_id} = '0; rr_biq_id = '0;
        {cdb_done1, cdb_done2, cdb_wakeup1, cdb_wakeup2, comm_free_push1, comm_free_push2, cdb_branch_resolved, cdb_branch_correct} = '0;
        {cdb_waked_reg1, cdb_waked_reg2, comm_free_reg1, comm_free_reg2, cdb_branch_tag} = '0;
        {cdb_rob_index1, cdb_rob_index2, cdb_branch_rob_index} = '0;

        #10 reset = 0;
        #60;

        // Example trigger for verification
        cdb_wakeup1 = 1; cdb_waked_reg1 = 6'd1;
        #10;
        cdb_wakeup1 = 0;

        #100 $finish;
    end
endmodule