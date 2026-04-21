module tb_main_datapath();

    // -----------------------------------------
    // Parameters (Matching DUT)
    // -----------------------------------------
    parameter XLEN                = 32;
    parameter OPCODE_SIZE         = 7;
    parameter PHT_ADDRESS         = 9;
    parameter GHR_SIZE            = 9;
    parameter RAS_ADDRESS         = 3;
    parameter INIT_IMMEDIATE_SIZE = 21;
    parameter BIQ_ADDRESS         = 5;

    // -----------------------------------------
    // Testbench Signals (Inputs to DUT)
    // -----------------------------------------
    logic CLK;
    logic reset;
    logic flush;
    
    logic actual_taken;
    logic mispredict;
    logic restore_ghr;
    logic restore_ras;
    logic update_pht;
    logic update_btb;
    logic update_ras;
    logic ex_is_ret;
    logic ex_is_branch;
    
    logic [XLEN-1:0] actual_target_address;
    logic [XLEN-1:0] ex_pc;
    logic [GHR_SIZE-1:0] ghr_snap;
    logic [PHT_ADDRESS-1:0] rb_pht_index;
    logic [RAS_ADDRESS-1:0] rb_sp_snap;
    logic [2*XLEN-1:0] rb_ras_snap;

    logic dis_biq_dealloc;
    logic [BIQ_ADDRESS-1:0] rr_biq_id;
    logic rr_slot_id;

    // -----------------------------------------
    // Testbench Signals (Outputs from DUT)
    // -----------------------------------------
    logic stall_frontend;
    logic id_valid1;
    logic id_valid2;
    logic [XLEN-3:0] id_pc;
    logic id_take_snap;
    
    // Slot 1
    logic [2:0] id_funct3_1, id_alu_op1;
    logic [6:0] id_funct7_1;
    logic [4:0] id_rs1_1, id_rs2_1, id_rd_1;
    
    logic [INIT_IMMEDIATE_SIZE-1:0] id_immout1;
    logic id_jump_reg1, id_jump1, id_branch1, id_regsrc1_1, id_regsrc2_1;
    logic id_immtype1, id_memwrite1, id_regwrite1, id_memtoreg1, id_retaddr1, id_isimm1, id_upperimm1;

    // Slot 2
    logic [2:0] id_funct3_2, id_alu_op2;
    logic [4:0] id_rs1_2, id_rs2_2, id_rd_2;
    logic [6:0] id_funct7_2;
    logic [INIT_IMMEDIATE_SIZE-1:0] id_immout2;
    logic id_jump_reg2, id_jump2, id_branch2, id_regsrc1_2, id_regsrc2_2;
    logic id_immtype2, id_memwrite2, id_regwrite2, id_memtoreg2, id_retaddr2, id_isimm2, id_upperimm2;

    // BIQ Metadata Outputs
    logic [BIQ_ADDRESS-1:0] id_biq_address;
    logic id_biq_valid;
    logic id_biq_pred_taken;
    logic [XLEN-1:0] id_biq_pred_target;
    logic [PHT_ADDRESS-1:0] id_biq_pht_index;
    logic [GHR_SIZE-1:0] id_biq_restore_ghr;
    logic [RAS_ADDRESS-1:0] id_biq_sp_snap;
    logic [2*XLEN-1:0] id_biq_ras_snap;

    // -----------------------------------------
    // Instantiate the Device Under Test (DUT)
    // -----------------------------------------
    main_datapath #(
        .XLEN(XLEN),
        .OPCODE_SIZE(OPCODE_SIZE),
        .PHT_ADDRESS(PHT_ADDRESS),
        .GHR_SIZE(GHR_SIZE),
        .RAS_ADDRESS(RAS_ADDRESS),
        .INIT_IMMEDIATE_SIZE(INIT_IMMEDIATE_SIZE),
        .BIQ_ADDRESS(BIQ_ADDRESS)
    ) dut (
        .CLK(CLK),
        .reset(reset),
        .flush(flush),
        
        // Predictor Updates
        .actual_taken(actual_taken),
        .mispredict(mispredict),
        .restore_ghr(restore_ghr),
        .restore_ras(restore_ras),
        .update_pht(update_pht),
        .update_btb(update_btb),
        .update_ras(update_ras),
        .ex_is_ret(ex_is_ret),
        .ex_is_branch(ex_is_branch),
        .actual_target_address(actual_target_address),
        .ex_pc(ex_pc),
        .ghr_snap(ghr_snap),
        .rb_pht_index(rb_pht_index),
        .rb_sp_snap(rb_sp_snap),
        .rb_ras_snap(rb_ras_snap),
        
        // Dispatch Inputs
        .dis_biq_dealloc(dis_biq_dealloc),
        .rr_biq_id(rr_biq_id),
        .rr_slot_id(rr_slot_id),

        // Frontend Control Outputs
        .stall_frontend(stall_frontend),
        .id_valid1(id_valid1),
        .id_valid2(id_valid2),
        .id_pc(id_pc),
        .id_take_snap(id_take_snap),

        // Slot 1 Outputs
        .id_funct3_1(id_funct3_1), .id_alu_op1(id_alu_op1), .id_funct7_1(id_funct7_1),

        .id_rs1_1(id_rs1_1), .id_rs2_1(id_rs2_1), .id_rd_1(id_rd_1),
        .id_rs1_2(id_rs1_2), .id_rs2_2(id_rs2_2), .id_rd_2(id_rd_2),

        .id_immout1(id_immout1), .id_jump_reg1(id_jump_reg1), .id_jump1(id_jump1),
        .id_branch1(id_branch1), .id_regsrc1_1(id_regsrc1_1), .id_regsrc2_1(id_regsrc2_1),
        .id_immtype1(id_immtype1), .id_memwrite1(id_memwrite1), .id_regwrite1(id_regwrite1),
        .id_memtoreg1(id_memtoreg1), .id_retaddr1(id_retaddr1), .id_isimm1(id_isimm1), .id_upperimm1(id_upperimm1),

        // Slot 2 Outputs
        .id_funct3_2(id_funct3_2), .id_alu_op2(id_alu_op2), .id_funct7_2(id_funct7_2), // Typo fixed here
        .id_immout2(id_immout2), .id_jump_reg2(id_jump_reg2), .id_jump2(id_jump2),
        .id_branch2(id_branch2), .id_regsrc1_2(id_regsrc1_2), .id_regsrc2_2(id_regsrc2_2),
        .id_immtype2(id_immtype2), .id_memwrite2(id_memwrite2), .id_regwrite2(id_regwrite2),
        .id_memtoreg2(id_memtoreg2), .id_retaddr2(id_retaddr2), .id_isimm2(id_isimm2), .id_upperimm2(id_upperimm2),

        // BIQ Metadata Outputs
        .id_biq_address(id_biq_address), .id_biq_valid(id_biq_valid),
        .id_biq_pred_taken(id_biq_pred_taken), .id_biq_pred_target(id_biq_pred_target),
        .id_biq_pht_index(id_biq_pht_index), .id_biq_restore_ghr(id_biq_restore_ghr),
        .id_biq_sp_snap(id_biq_sp_snap), .id_biq_ras_snap(id_biq_ras_snap)
    );

    // -----------------------------------------
    // Clock Generation (100 MHz)
    // -----------------------------------------
    initial CLK = 0;
    always #5 CLK = ~CLK;

    // -----------------------------------------
    // Test Sequence
    // -----------------------------------------
    initial begin
        // Waveform Dump for Vivado/GTKWave
        $dumpfile("main_datapath.vcd");
        $dumpvars(0, tb_main_datapath);

        // 1. Initialize all inputs (Zero the Backend)
        reset = 1;
        flush = 0;
        mispredict = 0;
        actual_taken = 0;
        restore_ghr = 0;
        restore_ras = 0;
        update_pht = 0;
        update_btb = 0;
        update_ras = 0;
        ex_is_ret = 0;
        ex_is_branch = 0;
        actual_target_address = 0;
        ex_pc = 0;
        ghr_snap = 0;
        rb_pht_index = 0;
        rb_sp_snap = 0;
        rb_ras_snap = 0;
        dis_biq_dealloc = 0;
        rr_biq_id = 0;
        rr_slot_id = 0;

        // 2. Hold reset for a few cycles
        #20;
        reset = 0;

        // 3. Let the processor freely fetch and decode 
        // (Assuming instructions.hex is loaded into InstructionMemory)
        #50;

        // 4. MOCK: Backend Detects a Branch Misprediction
        // Simulate the Execute stage overriding the PC and restoring the GHR
        @(posedge CLK);
        flush = 1;
        mispredict = 1;
        actual_target_address = 32'h0000_00A4; // The correct path it should have taken
        restore_ghr = 1;
        ghr_snap = 9'b000000010;               // Snapshot from the BIQ
        actual_taken = 1;                      // The branch was actually taken
        
        // Update predictors
        update_btb = 1;
        ex_pc = 32'h0000_0020;                 // Address of the failed branch
        ex_is_branch = 1;
        
        @(posedge CLK);
        // De-assert backend signals; let frontend recover and fetch new path
        flush = 0;
        mispredict = 0;
        restore_ghr = 0;
        update_btb = 0;
        actual_target_address = 0;

        #50;
        
        // 5. MOCK: Backend Dispatch Queue Retires a Branch
        // Free up a slot in the BIQ
        @(posedge CLK);
        dis_biq_dealloc = 1;
        
        @(posedge CLK);
        dis_biq_dealloc = 0;

        #100;

        $display("Simulation Finished Successfully.");
        $finish;
    end

endmodule