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

    // Clock and Reset
    logic CLK;
    logic reset;
    logic flush;

    // Backend Predictor Updates
    logic actual_taken, mispredict, restore_ghr, restore_ras, update_pht;
    logic update_btb, update_ras, ex_is_ret, ex_is_branch, ex_is_jalr;
    logic [XLEN-1:0] actual_target_address, ex_pc;
    logic [GHR_SIZE-1:0] ghr_snap;
    logic [PHT_ADDRESS-1:0] rb_pht_index;
    logic [RAS_ADDRESS-1:0] rb_sp_snap;
    logic [2*XLEN-1:0] rb_ras_snap;

    // Dispatch/RR
    logic dis_biq_dealloc;
    logic [BIQ_ADDRESS-1:0] rr_biq_id;
    logic rr_slot_id;

    // Rename Stage specific
    logic cdb_wakeup1, cdb_wakeup2, comm_free_push1, comm_free_push2, ex_branch_resolved;
    logic [PRF_ADDRESS-1:0] cdb_waked_reg1, cdb_waked_reg2, comm_free_reg1, comm_free_reg2;
    logic [BTAG_SIZE-1:0] ex_btag;

    // Outputs
    logic stall_frontend;
    logic [PRF_ADDRESS-1:0] rn_prd1, rn_prs1_1, rn_prs2_1, rn_old_prd1;
    logic [PRF_ADDRESS-1:0] rn_prd2, rn_prs1_2, rn_prs2_2, rn_old_prd2;             
    logic rn_prs1_busy1, rn_prs2_busy1, rn_prs1_busy2, rn_prs2_busy2;
    logic [BTAG_SIZE-1:0] rn_branch_tag;
    logic [MAX_BRANCHES-1:0] rn_branch_mask;
    logic [BIQ_ADDRESS-1:0] rn_biq_address;
    logic [XLEN-3:0] rn_pc;
    logic rn_valid1, rn_valid2;

    // Output stubs
    logic [2:0] rn_funct3_1, rn_alu_op1, rn_funct3_2, rn_alu_op2;
    logic [6:0] rn_funct7_1, rn_funct7_2;
    logic [INIT_IMMEDIATE_SIZE-1:0] rn_immout1, rn_immout2;
    logic rn_jump_reg1, rn_jump1, rn_branch1, rn_regsrc1_1, rn_regsrc2_1, rn_immtype1, rn_isimm1, rn_retaddr1, rn_upperimm1, rn_regwrite1, rn_memwrite1, rn_memtoreg1;
    logic rn_jump_reg2, rn_jump2, rn_branch2, rn_regsrc1_2, rn_regsrc2_2, rn_immtype2, rn_isimm2, rn_retaddr2, rn_upperimm2, rn_regwrite2, rn_memwrite2, rn_memtoreg2;
    logic id_biq_valid, id_biq_pred_taken;
    logic [XLEN-1:0] id_biq_pred_target;
    logic [PHT_ADDRESS-1:0] id_biq_pht_index;
    logic [GHR_SIZE-1:0] id_biq_restore_ghr;
    logic [RAS_ADDRESS-1:0] id_biq_sp_snap;
    logic [2*XLEN-1:0] id_biq_ras_snap;

    // DUT Instantiation
    main_datapath #(
        .XLEN(XLEN), .OPCODE_SIZE(OPCODE_SIZE), .PHT_ADDRESS(PHT_ADDRESS), 
        .GHR_SIZE(GHR_SIZE), .RAS_ADDRESS(RAS_ADDRESS), 
        .INIT_IMMEDIATE_SIZE(INIT_IMMEDIATE_SIZE), .BIQ_ADDRESS(BIQ_ADDRESS),
        .PRF_ADDRESS(PRF_ADDRESS), .MAX_BRANCHES(MAX_BRANCHES)
    ) dut (.*);

    // Clock Generation
    always #5 CLK = ~CLK;

    // VCD Generation Block
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, main_datapath_tb);
    end

    initial begin
        // Initialize Inputs
        CLK = 0;
        reset = 1;
        flush = 0;
        
        // Zero-out Execution/Backend Feedbacks
        actual_taken = 0; mispredict = 0; restore_ghr = 0; restore_ras = 0;
        update_pht = 0; update_btb = 0; update_ras = 0; ex_is_ret = 0; ex_is_branch = 0;
        ex_is_jalr = 0;
        actual_target_address = '0; ex_pc = '0; ghr_snap = '0;
        rb_pht_index = '0; rb_sp_snap = '0; rb_ras_snap = '0;

        dis_biq_dealloc = 0; rr_biq_id = '0; rr_slot_id = 0;

        // Zero-out CDB & Rename Backend Signals
        cdb_wakeup1 = 0; cdb_wakeup2 = 0;
        comm_free_push1 = 0; comm_free_push2 = 0;
        ex_branch_resolved = 0; ex_btag = '0;
        cdb_waked_reg1 = '0; cdb_waked_reg2 = '0;
        comm_free_reg1 = '0; comm_free_reg2 = '0;

        // Apply Reset
        #10 reset = 0;

        // Wait a few cycles to let PD, IF, and ID stages fill
        #60;

        // Simulate a commit waking up the Free List
        comm_free_push1 = 1;
        comm_free_reg1  = 6'd35;
        #10;
        comm_free_push1 = 0;
        
        // Simulate a CDB broadcast
        cdb_wakeup1 = 1;
        cdb_waked_reg1 = 6'd1;
        #10;
        cdb_wakeup1 = 0;

        // Run until pipeline establishes steady-state valid signals
        #100;
        $finish;
    end

endmodule