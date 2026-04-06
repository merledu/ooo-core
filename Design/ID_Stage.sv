module ID_Stage #(
    parameter OPCODE_SIZE = 7,
    parameter PHT_ADDRESS = 9,
    parameter GHR_SIZE = 9,
    parameter XLEN = 32,
    parameter RAS_ADDRESS = 3
) (
    input logic if_pred_taken1, if_pred_taken2, if_btb_hit1, if_btb_hit2,
    input logic [XLEN-1:0] if_instr1, if_instr2, if_pred_target1, if_pred_target2,
    input logic [XLEN-3:0] if_pc1, if_pc2,
    input logic [PHT_ADDRESS-1:0] if_pht_index1, if_pht_index2,
    input logic [RAS_ADDRESS-1:0] if_sp_snap,
    input logic [2*XLEN-1:0] if_ras_snap,
    input logic [GHR_SIZE-1:0] if_prev_ghr
);
    assign opcode_1 = if_instr1[OPCODE_SIZE-1:0];
    assign opcode_2 = if_instr2[OPCODE_SIZE-1:0];

    assign funct3_1 = if_instr1[14:12];
    assign funct3_2 = if_instr2[14:12];

    assign funct7_1 = if_instr1[31:25];
    assign funct7_2 = if_instr2[31:25];

    assign take_snap_1 = if_btb_hit1 && (Branch_1 || Jump_1);
    assign take_snap_2 = if_btb_hit2 && (Branch_2 || Jump_2);
    
    
    CU cu_instantiation_1 (
        .opcode(opcode_1),
        .ALUOp(ALUOp_1),
        .JumpReg(JumpReg_1),
        .Jump(Jump_1),
        .Branch(Branch_1),
        .RegSrc1(RegSrc1_1),
        .RegSrc2(RegSrc2_1),
        .UpperImm(UpperImm_1),
        .RegWrite(RegWrite_1),
        .MemWrite(MemWrite_1),
        .MemToReg(MemToReg_1),
        .RetAddr(RetAddr_1),
        .imm(imm_1)
    );

    CU cu_instantiation_2 (
        .opcode(opcode_2),
        .ALUOp(ALUOp_2),
        .JumpReg(JumpReg_2),
        .Jump(Jump_2),
        .Branch(Branch_2),
        .RegSrc1(RegSrc1_2),
        .RegSrc2(RegSrc2_2),
        .UpperImm(UpperImm_2),
        .RegWrite(RegWrite_2),
        .MemWrite(MemWrite_2),
        .MemToReg(MemToReg_2),
        .RetAddr(RetAddr_2),
        .imm(imm_2)
    );
    
endmodule