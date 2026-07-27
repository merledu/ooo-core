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
    logic CLK, reset;

    // DUT Instantiation
    main_datapath #(
        .XLEN(XLEN), 
        .OPCODE_SIZE(OPCODE_SIZE), 
        .PHT_ADDRESS(PHT_ADDRESS), 
        .GHR_SIZE(GHR_SIZE), 
        .RAS_ADDRESS(RAS_ADDRESS), 
        .INIT_IMMEDIATE_SIZE(INIT_IMMEDIATE_SIZE), 
        .BIQ_ADDRESS(BIQ_ADDRESS),
        .PRF_ADDRESS(PRF_ADDRESS), 
        .MAX_BRANCHES(MAX_BRANCHES),
        .ROB_SIZE(ROB_SIZE)
    ) dut (
        .CLK(CLK),
        .reset(reset)
    );

    // Clock Generation
    always #1 CLK = ~CLK;

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_main_datapath);
        
        // Initialization
        CLK = 0; 
        reset = 1; 

        // Hold reset for a few cycles
        #2 reset = 0;

        // Allow the processor core to run
        // You can increase this delay depending on how long your instructions take to fetch/execute
        #500; 

        $finish;
    end
endmodule