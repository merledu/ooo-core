module ID_Stage #(
    parameter OPCODE_SIZE = 7,
    parameter PHT_ADDRESS = 9,
    parameter GHR_SIZE = 9,
    parameter XLEN = 32,
    parameter RAS_ADDRESS = 3,
    parameter INIT_IMMEDIATE_SIZE = 21,
    parameter BIQ_ADDRESS = 5
) (
    input logic CLK, reset, flush, rr_slot_id, dis_biq_dealloc, if_pred_taken1, if_pred_taken2, 
    input logic if_valid1, if_valid2, if_btb_hit1, if_btb_hit2,
    input logic [XLEN-1:0] if_instr1, if_instr2, if_pred_target1, if_pred_target2, 
    input logic [XLEN-3:0] if_pc,
    input logic [BIQ_ADDRESS-1:0] rr_biq_id,
    input logic [PHT_ADDRESS-1:0] if_pht_index1, if_pht_index2,
    input logic [RAS_ADDRESS-1:0] if_sp_snap,
    input logic [2*XLEN-1:0] if_ras_snap,
    input logic [GHR_SIZE-1:0] if_prev_ghr,
    output logic [RAS_ADDRESS-1:0] id_biq_sp_snap,
    output logic [2*XLEN-1:0] id_biq_ras_snap,
    output logic stall_frontend, id_take_snap, id_valid1, id_valid2,
    output logic [2:0] id_funct3_1, id_funct3_2,
    output logic [6:0] id_funct7_1, id_funct7_2,
    output logic [INIT_IMMEDIATE_SIZE-1:0] id_immout1, id_immout2,
    output logic [BIQ_ADDRESS-1:0] id_biq_address,
    output logic [XLEN-1:0] id_biq_pred_target, 
    output logic [XLEN-3:0] id_pc,
    output logic [2:0] id_alu_op1, id_alu_op2,
    output logic [GHR_SIZE-1:0] id_biq_restore_ghr, 
    output logic [PHT_ADDRESS-1:0] id_biq_pht_index,
    output logic id_jump_reg1, id_jump_reg2, id_jump1, id_jump2, id_branch1, id_branch2, id_regsrc1_1,  
    output logic id_immtype1, id_memwrite1,  id_immtype2, id_biq_valid, id_biq_pred_taken, id_regsrc2_1,
    output logic id_regsrc1_2, id_regsrc2_2, id_upperimm1, id_upperimm2, id_regwrite1, id_regwrite2, 
    output logic id_memwrite2, id_memtoreg1, id_memtoreg2, id_retaddr1, id_retaddr2, id_isimm1, id_isimm2
);
    logic [OPCODE_SIZE-1:0] opcode_1, opcode_2; 
    logic [2:0] funct3_1, funct3_2;
    logic [6:0] funct7_1, funct7_2;
    logic [2:0] ALUOp_1, ALUOp_2;
    logic [INIT_IMMEDIATE_SIZE-1:0] imm_out1, imm_out2;
    logic is_control_flow_instr1, is_control_flow_instr2, pred_valid1, pred_valid2;
    logic JumpReg_1, JumpReg_2, Jump_1, Jump_2, Branch_1, Branch_2, RegSrc1_1, RegSrc2_1, RegSrc1_2, RegSrc2_2; 
    logic RetAddr_1, UpperImm_1, UpperImm_2, RegWrite_1, RegWrite_2, MemWrite_1, MemWrite_2, MemToReg_1;
    logic MemToReg_2, RetAddr_2, Imm_1, Imm_2, imm_type1, imm_type2;
    
    assign opcode_1 = if_instr1[OPCODE_SIZE-1:0];
    assign opcode_2 = if_instr2[OPCODE_SIZE-1:0];
    assign is_control_flow_instr1 = (Branch_1 || Jump_1) && if_valid1 && !stall_frontend;
    assign is_control_flow_instr2 = (Branch_2 || Jump_2) && if_valid2 && !stall_frontend;
    assign pred_valid1 = (is_control_flow_instr1 && if_btb_hit1);
    assign pred_valid2 = (is_control_flow_instr2 && if_btb_hit2);

    always_ff @(posedge CLK) begin 
        if (reset) begin
            id_valid1 <= 0;
            id_valid2 <= 0;
            id_take_snap <= 0;
        end
        else if (!stall_frontend) begin
            id_valid1 <= (!flush && if_valid1); 
            id_valid2 <= (!flush && if_valid2); 
            id_take_snap <= (is_control_flow_instr1 || is_control_flow_instr2);
            id_pc <= if_pc;
            id_funct3_1 <= if_instr1[14:12];
            id_funct3_2 <= if_instr2[14:12];
            id_funct7_1 <= if_instr1[31:25];
            id_funct7_2 <= if_instr2[31:25]; 
            id_alu_op1 <= ALUOp_1;
            id_alu_op2 <= ALUOp_2; 
            id_jump_reg1 <= JumpReg_1;
            id_jump_reg2 <= JumpReg_2;
            id_jump1 <= Jump_1;
            id_jump2 <= Jump_2;
            id_branch1 <= Branch_1;
            id_branch2 <= Branch_2;
            id_regsrc1_1 <= RegSrc1_1;
            id_regsrc2_1 <= RegSrc2_1;
            id_regsrc1_2 <= RegSrc1_2;
            id_regsrc2_2 <= RegSrc2_2;
            id_upperimm1 <= UpperImm_1;
            id_upperimm2 <= UpperImm_2;
            id_regwrite1 <= RegWrite_1;
            id_regwrite2 <= RegWrite_2;
            id_memwrite1 <= MemWrite_1;
            id_memwrite2 <= MemWrite_2;
            id_memtoreg1 <= MemToReg_1;
            id_memtoreg2 <= MemToReg_2;
            id_retaddr1 <= RetAddr_1;
            id_retaddr2 <= RetAddr_2;
            id_isimm1 <= Imm_1;
            id_isimm2 <= Imm_2; 
            id_immout1 <= imm_out1;
            id_immout2 <= imm_out2;
            id_immtype1 <= imm_type1;
            id_immtype2 <= imm_type2;
        end
        
    end

    CU cu_instantiation1 (
        .opcode     (opcode_1),
        .ALUOp      (ALUOp_1),
        .JumpReg    (JumpReg_1),
        .Jump       (Jump_1),
        .Branch     (Branch_1),
        .RegSrc1    (RegSrc1_1),
        .RegSrc2    (RegSrc2_1),
        .UpperImm   (UpperImm_1),
        .RegWrite   (RegWrite_1),
        .MemWrite   (MemWrite_1),
        .MemToReg   (MemToReg_1),
        .RetAddr    (RetAddr_1),
        .imm        (Imm_1)
    );

    CU cu_instantiation2 (
        .opcode     (opcode_2),
        .ALUOp      (ALUOp_2),
        .JumpReg    (JumpReg_2),
        .Jump       (Jump_2),
        .Branch     (Branch_2),
        .RegSrc1    (RegSrc1_2),
        .RegSrc2    (RegSrc2_2),
        .UpperImm   (UpperImm_2),
        .RegWrite   (RegWrite_2),
        .MemWrite   (MemWrite_2),
        .MemToReg   (MemToReg_2),
        .RetAddr    (RetAddr_2),
        .imm        (Imm_2)
    );
    
    IG ig_instantiation1(
        .instruction        (if_instr1),
        .immediate_output   (imm_out1),
        .imm_type           (imm_type1)
    );

    IG ig_instantiation2(
        .instruction        (if_instr2),
        .immediate_output   (imm_out2),
        .imm_type           (imm_type2)
    );

    BIQ biq_instantiation (
        .CLK             (CLK),
        .reset           (reset),
        .flush           (flush),
        // from dispatch stage
        .biq_dealloc     (dis_biq_dealloc),

        // Slot 1 Inputs (Allocation)
        .biq_alloc1      (is_control_flow_instr1),
        .pred_valid1     (pred_valid1),
        .pred_taken1     (if_pred_taken1),
        .pred_target1    (if_pred_target1),
        .pht_index1      (if_pht_index1),
        // Slot 2 Inputs (Allocation)
        .biq_alloc2      (is_control_flow_instr2),
        .pred_valid2     (pred_valid2),
        .pred_taken2     (if_pred_taken2),
        .pred_target2    (if_pred_target2),
        .pht_index2      (if_pht_index2),
        
        // Shared Input
        .prev_ghr        (if_prev_ghr),
        .sp_snap         (if_sp_snap),
        .ras_snap        (if_ras_snap),
        // Read Port Input (register read Stage)
        .biq_id          ({rr_biq_id, rr_slot_id}),
        
        // Outputs (to ROB)
        .biq_address     (id_biq_address),
        .stall_frontend  (stall_frontend), //signal generated instantly
        // Outputs (to Execute for Verification)
        .biq_valid       (id_biq_valid),
        .biq_pred_taken  (id_biq_pred_taken),
        .biq_pred_target (id_biq_pred_target),
        .biq_restore_ghr (id_biq_restore_ghr),
        .biq_pht_index   (id_biq_pht_index),
        .biq_sp_snap     (id_biq_sp_snap),
        .biq_ras_snap    (id_biq_ras_snap)
    );
    
endmodule