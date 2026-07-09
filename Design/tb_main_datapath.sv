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
    localparam NUM_PHY_REG         = 1 << PRF_ADDRESS;

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

    // CDB Write/Bypass Inputs for RR_Stage
    logic cdb_regwrite1, cdb_regwrite2;
    logic [PRF_ADDRESS-1:0] cdb_write_address1, cdb_write_address2;
    logic [XLEN-1:0] cdb_write_data1, cdb_write_data2;

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
    
    // RR Stage Outputs (Instruction 1)
    logic [XLEN-1:0] rr_instr1_read_data1, rr_instr1_read_data2;
    logic rr_valid1, rr_is_m_extension1, rr_jump_reg1, rr_jump1, rr_branch1;
    logic rr_instr1_regsrc1, rr_instr1_regsrc2, rr_isimm1, rr_retaddr1, rr_upperimm1;
    logic rr_regwrite1, rr_memwrite1, rr_memtoreg1;
    logic [XLEN-3:0] rr_pc1;
    logic [PRF_ADDRESS-1:0] rr_prd1;
    logic [XLEN-1:0] rr_immediate1; // Changed to XLEN-1:0 to match RR output
    logic [4:0] rr_alu_operation1;
    logic [BTAG_SIZE-1:0] rr_branch_tag1;
    logic [MAX_BRANCHES-1:0] rr_branch_mask1;
    logic [BIQ_ADDRESS-1:0] rr_biq_address1;
    logic [ROB_PTR_SIZE-1:0] rr_rob_index1;

    // RR Stage Outputs (Instruction 2)
    logic [XLEN-1:0] rr_instr2_read_data1, rr_instr2_read_data2;
    logic rr_valid2, rr_is_m_extension2, rr_jump_reg2, rr_jump2, rr_branch2;
    logic rr_instr2_regsrc1, rr_instr2_regsrc2, rr_isimm2, rr_retaddr2, rr_upperimm2;
    logic rr_regwrite2, rr_memwrite2, rr_memtoreg2;
    logic [XLEN-3:0] rr_pc2;
    logic [PRF_ADDRESS-1:0] rr_prd2;
    logic [XLEN-1:0] rr_immediate2; // Changed to XLEN-1:0 to match RR output
    logic [4:0] rr_alu_operation2;
    logic [BTAG_SIZE-1:0] rr_branch_tag2;
    logic [MAX_BRANCHES-1:0] rr_branch_mask2;
    logic [BIQ_ADDRESS-1:0] rr_biq_address2;
    logic [ROB_PTR_SIZE-1:0] rr_rob_index2;


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
        
        // Initialize new RR CDB inputs
        {cdb_regwrite1, cdb_regwrite2} = '0;
        {cdb_write_address1, cdb_write_address2} = '0;
        {cdb_write_data1, cdb_write_data2} = '0;

        #10 reset = 0;
        #60;

        // Example trigger for verification
        cdb_wakeup1 = 1; cdb_waked_reg1 = 6'd1;
        
        // Simulate a writeback that the RR stage might need to bypass
        cdb_regwrite1 = 1;
        cdb_write_address1 = 6'd1;
        cdb_write_data1 = 32'hDEADBEEF;
        #10;
        
        cdb_wakeup1 = 0;
        cdb_regwrite1 = 0;

        #100 $finish;
    end
endmodule