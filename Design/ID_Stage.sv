module ID_Stage #(
    parameter OPCODE_SIZE           = 7,
    parameter PHT_ADDRESS           = 9,
    parameter GHR_SIZE              = 9,
    parameter XLEN                  = 32,
    parameter RAS_ADDRESS           = 3,
    parameter INIT_IMMEDIATE_SIZE   = 21,
    parameter BIQ_ADDRESS           = 5
) (
    input logic CLK, reset, flush, rob_global_flush,
    input logic backend_stall,                 //rename or dispatch stage cannot take the decoded bundle
    input logic [1:0] biq_dealloc,             //number of branches committed in this cycle
    input logic if_valid1, if_valid2,
    input logic fin_pred_taken, fin_pred_slot, //final prediction of the bundle in IF stage
    input logic [XLEN-1:0] if_instr1, if_instr2, fin_pred_target, 
    input logic [XLEN-3:0] if_pc,
    input logic [BIQ_ADDRESS-1:0] iss_biq_id, ex_biq_id,
    input logic [PHT_ADDRESS-1:0] if_pht_index,
    input logic [RAS_ADDRESS-1:0] fin_sp_snap1, fin_sp_snap2,
    input logic [2*XLEN-1:0] fin_ras_snap1, fin_ras_snap2,
    input logic [GHR_SIZE-1:0] if_prev_ghr,
    
    output logic [RAS_ADDRESS-1:0] id_biq_sp_snap,
    output logic [2*XLEN-1:0] id_biq_ras_snap,
    output logic id_stall_frontend, id_take_snap, id_valid1, id_valid2,
    output logic [4:0] id_rs1_1, id_rs2_1, id_rd_1,
    output logic [4:0] id_rs1_2, id_rs2_2, id_rd_2,
    output logic [INIT_IMMEDIATE_SIZE-1:0] id_immout1, id_immout2,
    output logic [BIQ_ADDRESS-1:0] id_biq_address,
    output logic [XLEN-1:0] id_biq_pred_target, 
    output logic [XLEN-3:0] id_pc,
    output logic [GHR_SIZE-1:0] id_biq_restore_ghr,
    output logic [PHT_ADDRESS-1:0] id_biq_pht_index,
    output logic [4:0] id_alu_operation1, id_alu_operation2,
    output logic id_is_m_extension1, id_is_m_extension2,
    output logic id_jump_reg1, id_jump_reg2, id_jump1, id_jump2, id_branch1, id_branch2, id_regsrc1_1,  
    output logic id_immtype1, id_memwrite1,  id_immtype2, id_biq_pred_taken, id_biq_slot, id_biq_is_ret, id_regsrc2_1,
    output logic id_regsrc1_2, id_regsrc2_2, id_upperimm1, id_upperimm2, id_regwrite1, id_regwrite2, 
    output logic id_memwrite2, id_memtoreg1, id_memtoreg2, id_retaddr1, id_retaddr2, id_isimm1, id_isimm2,
    output logic [1:0] id_memory_type1, id_memory_type2, 
    output logic id_memory_sign_ext1, id_memory_sign_ext2
);
    logic [OPCODE_SIZE-1:0] opcode_1, opcode_2; 
    logic [2:0] ALUOp_1, ALUOp_2;
    logic [INIT_IMMEDIATE_SIZE-1:0] imm_out1, imm_out2;
    logic [4:0] alu_operation1, alu_operation2;
    logic is_m_extension1, is_m_extension2;
    logic JumpReg_1, JumpReg_2, Jump_1, Jump_2, Branch_1, Branch_2, RegSrc1_1, RegSrc2_1, RegSrc1_2, RegSrc2_2; 
    logic RetAddr_1, UpperImm_1, UpperImm_2, RegWrite_1, RegWrite_2, MemWrite_1, MemWrite_2, MemToReg_1;
    logic MemToReg_2, RetAddr_2, Imm_1, Imm_2, imm_type1, imm_type2, valid_opcode1, valid_opcode2;
    logic UseRs1_1, UseRs2_1, UseRs1_2, UseRs2_2;

    logic cf1, cf2, need_split, second_half, half_has_cf, cf_slot;
    logic [BIQ_ADDRESS-1:0] biq_address;
    logic emit1, emit2, biq_full, biq_block, biq_alloc, is_ret1, is_ret2;
    
    assign opcode_1 = if_instr1[OPCODE_SIZE-1:0];
    assign opcode_2 = if_instr2[OPCODE_SIZE-1:0];

    // Only one control flow instruction (branch/jal/jalr) is decoded per cycle because it needs
    // a BIQ entry, a branch tag and a snapshot. A bundle with two of them is split over two
    // cycles: {instr1, -} first and {-, instr2} in the next cycle.
    always_comb begin
        cf1 = if_valid1 && (Branch_1 || Jump_1);
        cf2 = if_valid2 && (Branch_2 || Jump_2);
        need_split = cf1 && cf2;

        emit1 = if_valid1 && valid_opcode1 && !second_half;
        emit2 = if_valid2 && valid_opcode2 && !(need_split && !second_half);

        half_has_cf = (second_half) ? cf2 : (cf1 || cf2);
        cf_slot     = (second_half) ? 1'b1 : !cf1;

        biq_block = half_has_cf && biq_full;
        biq_alloc = half_has_cf && !biq_full && !backend_stall && !flush && !rob_global_flush;

        //fetch waits for a BIQ entry or for the 2nd half of a split bundle
        id_stall_frontend = biq_block || (need_split && !second_half);

        //ret = jalr with rs1 = x1/x5 and rd != x1/x5 (same definition as PreDecode)
        is_ret1 = JumpReg_1 && !(if_instr1[11:7] == 5'd1 || if_instr1[11:7] == 5'd5) && (if_instr1[19:15] == 5'd1 || if_instr1[19:15] == 5'd5);
        is_ret2 = JumpReg_2 && !(if_instr2[11:7] == 5'd1 || if_instr2[11:7] == 5'd5) && (if_instr2[19:15] == 5'd1 || if_instr2[19:15] == 5'd5);
    end

    always_ff @(posedge CLK) begin 
        if (reset || flush || rob_global_flush) begin
            id_valid1 <= 0;
            id_valid2 <= 0;
            id_take_snap <= 0;
            second_half <= 0;
        end
        else if (!backend_stall) begin
            if (biq_block) begin
                //bubble
                id_valid1 <= 0;
                id_valid2 <= 0;
                id_take_snap <= 0;
            end
            else begin
                id_valid1 <= emit1; 
                id_valid2 <= emit2; 
                id_take_snap <= half_has_cf;
                second_half <= need_split && !second_half;
            end
            id_pc <= if_pc;
            id_biq_address <= biq_address;

            //register fields which are not used by the instruction are replaced with x0 so that
            //rename does not create false dependencies or allocate/free registers for them
            id_rs1_1 <= (UseRs1_1) ? if_instr1[19:15] : 5'b0;
            id_rs2_1 <= (UseRs2_1) ? if_instr1[24:20] : 5'b0;
            id_rd_1  <= (RegWrite_1) ? if_instr1[11:7] : 5'b0;

            id_rs1_2 <= (UseRs1_2) ? if_instr2[19:15] : 5'b0;
            id_rs2_2 <= (UseRs2_2) ? if_instr2[24:20] : 5'b0;
            id_rd_2  <= (RegWrite_2) ? if_instr2[11:7] : 5'b0;

            id_memory_type1 <= if_instr1[13:12];
            id_memory_type2 <= if_instr2[13:12];
            id_memory_sign_ext1 <= ~if_instr1[14];
            id_memory_sign_ext2 <= ~if_instr2[14];

            id_alu_operation1 <= alu_operation1;
            id_alu_operation2 <= alu_operation2;
            id_is_m_extension1 <= is_m_extension1;
            id_is_m_extension2 <= is_m_extension2;
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
        .opcode         (opcode_1),
        .funct7         (if_instr1[31:25]),
        .is_m_extension (is_m_extension1),
        .ALUOp          (ALUOp_1),
        .JumpReg        (JumpReg_1),
        .Jump           (Jump_1),
        .Branch         (Branch_1),
        .RegSrc1        (RegSrc1_1),
        .RegSrc2        (RegSrc2_1),
        .UpperImm       (UpperImm_1),
        .RegWrite       (RegWrite_1),
        .MemWrite       (MemWrite_1),
        .MemToReg       (MemToReg_1),
        .RetAddr        (RetAddr_1),
        .imm            (Imm_1),
        .valid_opcode   (valid_opcode1),
        .UseRs1         (UseRs1_1),
        .UseRs2         (UseRs2_1)
    );

    CU cu_instantiation2 (
        .opcode         (opcode_2),
        .funct7         (if_instr2[31:25]),
        .is_m_extension (is_m_extension2),
        .ALUOp          (ALUOp_2),
        .JumpReg        (JumpReg_2),
        .Jump           (Jump_2),
        .Branch         (Branch_2),
        .RegSrc1        (RegSrc1_2),
        .RegSrc2        (RegSrc2_2),
        .UpperImm       (UpperImm_2),
        .RegWrite       (RegWrite_2),
        .MemWrite       (MemWrite_2),
        .MemToReg       (MemToReg_2),
        .RetAddr        (RetAddr_2),
        .imm            (Imm_2),
        .valid_opcode   (valid_opcode2),
        .UseRs1         (UseRs1_2),
        .UseRs2         (UseRs2_2)
    );
    
    IG21 ig_instantiation1(
        .instruction        (if_instr1),
        .immediate_output   (imm_out1),
        .imm_type           (imm_type1)
    );

    IG21 ig_instantiation2(
        .instruction        (if_instr2),
        .immediate_output   (imm_out2),
        .imm_type           (imm_type2)
    );

    ALUCU alucu_instantiation1(
        .ALUOp(ALUOp_1),
        .func3(if_instr1[14:12]),
        .func7(if_instr1[31:25]),
        .ALUOperation(alu_operation1)
    );

    ALUCU alucu_instantiation2(
        .ALUOp(ALUOp_2),
        .func3(if_instr2[14:12]),
        .func7(if_instr2[31:25]),
        .ALUOperation(alu_operation2)
    );

    BIQ #(
        .BIQ_ADDRESS     (BIQ_ADDRESS),
        .XLEN            (XLEN),
        .PHT_ADDRESS     (PHT_ADDRESS),
        .GHR_SIZE        (GHR_SIZE),
        .RAS_ADDRESS     (RAS_ADDRESS)
    ) biq_instantiation (
        .CLK             (CLK),
        .reset           (reset),
        .flush           (flush),
        .rob_global_flush(rob_global_flush),
        // from commit (ROB)
        .biq_dealloc     (biq_dealloc),
        //from issue stage (read) and execute stage (entry of the mispredicted branch)
        .biq_id          (iss_biq_id),
        .flush_biq_id    (ex_biq_id),
        //Allocation
        .biq_alloc       (biq_alloc),
        .pred_taken      (fin_pred_taken && (fin_pred_slot == cf_slot)),
        .slot            (cf_slot),
        .is_ret          ((cf_slot) ? is_ret2 : is_ret1),
        .pred_target     (fin_pred_target),
        .pht_index       (if_pht_index),
        .prev_ghr        (if_prev_ghr),
        .sp_snap         ((cf_slot) ? fin_sp_snap2 : fin_sp_snap1),
        .ras_snap        ((cf_slot) ? fin_ras_snap2 : fin_ras_snap1),
        
        // Outputs (to rename stage)
        .biq_address     (biq_address),
        .biq_full        (biq_full),
        // Outputs (to Execute for Verification)
        .biq_pred_taken  (id_biq_pred_taken),
        .biq_slot        (id_biq_slot),
        .biq_is_ret      (id_biq_is_ret),
        .biq_pred_target (id_biq_pred_target),
        //for prediction stage
        .biq_restore_ghr (id_biq_restore_ghr),
        .biq_pht_index   (id_biq_pht_index),
        .biq_sp_snap     (id_biq_sp_snap),
        .biq_ras_snap    (id_biq_ras_snap)
    );
    
endmodule
