module IF_Stage #(
    parameter PHT_ADDRESS = 9,
    parameter GHR_SIZE = 9,
    parameter XLEN = 32,
    parameter IM_ROWS = 1024,
    parameter HEX_FILE = "instructions.hex"
) (
    input logic CLK, reset, flush, stall_frontend, rob_global_flush, if_redirect,
    input logic pd_pred_taken, pd_pred_slot,
    input logic [XLEN-1:0] pd_pc, pd_pred_target,
    input logic [PHT_ADDRESS-1:0] pd_pht_index,
    input logic [GHR_SIZE-1:0] pd_prev_ghr,

    output logic if_pred_taken, if_pred_slot, if_valid1, if_valid2,
    output logic [1:0] if_predecode_instr1, if_predecode_instr2,
    output logic if_predecode_direct1, if_predecode_direct2,
    output logic [XLEN-1:0] if_instr1, if_instr2, if_pred_target,
    output logic [XLEN-1:0] if_jal_target1, if_jal_target2,
    output logic [XLEN-3:0] if_pc,
    output logic [PHT_ADDRESS-1:0] if_pht_index,
    output logic [GHR_SIZE-1:0] if_prev_ghr
);
    logic [XLEN-3:0] instr1_addr, instr2_addr;
    
    assign instr1_addr = pd_pc[XLEN-1:2];
    assign instr2_addr = pd_pc[XLEN-1:2] + 1;

    always_ff @(posedge CLK) begin
        if (reset || flush || rob_global_flush) begin
            if_valid1 <= 0;
            if_valid2 <= 0;
        end
        else if(!stall_frontend) begin
            //if the bundle in fetch stage redirects the pc, the bundle behind it is on the wrong path
            if_valid1 <= !if_redirect;
            //2nd instruction is squashed when the 1st one is predicted taken
            if_valid2 <= !if_redirect && !(pd_pred_taken && !pd_pred_slot);  
            if_pred_taken <= pd_pred_taken;
            if_pred_slot <= pd_pred_slot;
            if_pc <= pd_pc[XLEN-1:2];
            if_pred_target <= pd_pred_target;
            if_pht_index <= pd_pht_index;
            if_prev_ghr <= pd_prev_ghr;
        end
    end

    //target of jal is known right after fetch
    assign if_jal_target1 = {if_pc, 2'b00} + {{12{if_instr1[31]}}, if_instr1[19:12], if_instr1[20], if_instr1[30:21], 1'b0};
    assign if_jal_target2 = {if_pc, 2'b00} + 32'd4 + {{12{if_instr2[31]}}, if_instr2[19:12], if_instr2[20], if_instr2[30:21], 1'b0};

    IM #(
        .MEM_ROWS       (IM_ROWS),
        .HEX_FILE       (HEX_FILE)
    ) im_instantiation (
        .CLK            (CLK),
        .read_en        (!stall_frontend),
        .instr1_addr    ({2'b00, instr1_addr}),
        .instr2_addr    ({2'b00, instr2_addr}),
        .instr_1        (if_instr1),
        .instr_2        (if_instr2)
    );

    PreDecode predecode_instantiation(
        //input
        .opcode1            (if_instr1[6:0]),
        .opcode2            (if_instr2[6:0]),
        .rd1                (if_instr1[11:7]),
        .rd2                (if_instr2[11:7]),
        .rs1_1              (if_instr1[19:15]),
        .rs1_2              (if_instr2[19:15]),
        //output
        .predecode_instr1   (if_predecode_instr1),
        .predecode_instr2   (if_predecode_instr2),
        .predecode_direct1  (if_predecode_direct1),
        .predecode_direct2  (if_predecode_direct2)
    );

endmodule
