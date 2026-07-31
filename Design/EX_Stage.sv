module EX_Stage #(
    parameter XLEN = 32,
    parameter PRF_ADDRESS = 6,
    parameter ROB_PTR_SIZE = 6,
    parameter MAX_BRANCHES = 4,
    parameter BTAG_SIZE = $clog2(MAX_BRANCHES),
    parameter BIQ_ADDRESS = 5
) (
    input logic CLK, reset, rob_global_flush,
    input logic mul_ack, div_ack,
    input logic biq_pred_taken1, biq_pred_taken2,
    input logic [XLEN-1:0] biq_pred_target1, biq_pred_target2,
    input logic [XLEN-1:0] rr_instr1_read_data1, rr_instr1_read_data2,
    input logic [XLEN-1:0] rr_instr2_read_data1, rr_instr2_read_data2,
    input logic [PRF_ADDRESS-1:0] rr_instr1_prs1, rr_instr1_prs2,
    input logic [PRF_ADDRESS-1:0] rr_instr2_prs1, rr_instr2_prs2,

    // Instruction 1 Control
    input logic rr_valid1, rr_is_m_extension1, rr_jump_reg1, rr_jump1, rr_branch1,
    input logic rr_instr1_regsrc1, rr_instr1_regsrc2, rr_isimm1, rr_retaddr1, rr_upperimm1,
    input logic rr_regwrite1, rr_memwrite1, rr_memtoreg1,
    input logic [XLEN-3:0] rr_pc1,
    input logic [PRF_ADDRESS-1:0] rr_prd1,
    input logic [XLEN-1:0] rr_immediate1,
    input logic [4:0] rr_alu_operation1,
    input logic [BTAG_SIZE-1:0] rr_branch_tag1,
    input logic [MAX_BRANCHES-1:0] rr_branch_mask1,
    input logic [BIQ_ADDRESS-1:0] rr_biq_address1,
    input logic [ROB_PTR_SIZE-1:0] rr_rob_index1,
    
    // Instruction 2 Control
    input logic rr_valid2, rr_is_m_extension2, rr_jump_reg2, rr_jump2, rr_branch2,
    input logic rr_instr2_regsrc1, rr_instr2_regsrc2, rr_isimm2, rr_retaddr2, rr_upperimm2,
    input logic rr_regwrite2, rr_memwrite2, rr_memtoreg2,
    input logic [XLEN-3:0] rr_pc2,
    input logic [PRF_ADDRESS-1:0] rr_prd2,
    input logic [XLEN-1:0] rr_immediate2,
    input logic [4:0] rr_alu_operation2,
    input logic [BTAG_SIZE-1:0] rr_branch_tag2,
    input logic [MAX_BRANCHES-1:0] rr_branch_mask2,
    input logic [BIQ_ADDRESS-1:0] rr_biq_address2,
    input logic [ROB_PTR_SIZE-1:0] rr_rob_index2,

    // Branch Resolution Outputs
    output logic flush,
    output logic [BTAG_SIZE-1:0] cdb_branch_tag,
    output logic cdb_branch_resolved, cdb_branch_correct,
    output logic ex_actual_taken, update_pht, ex_is_jalr, ex_is_ret, ex_is_branch,
    output logic [XLEN-1:0] ex_actual_target_address, ex_pc,

    // ARBITER REQUEST PORTS
    output logic ex_alu1_valid, ex_alu1_regwrite,
    output logic [XLEN-1:0] ex_alu1_result,
    output logic [PRF_ADDRESS-1:0] ex_alu1_prd,
    output logic [ROB_PTR_SIZE-1:0] ex_alu1_rob_index,
    output logic ex_alu2_valid, ex_alu2_regwrite,
    output logic [XLEN-1:0] ex_alu2_result,
    output logic [PRF_ADDRESS-1:0] ex_alu2_prd,
    output logic [ROB_PTR_SIZE-1:0] ex_alu2_rob_index,
    output logic ex_mul_valid,
    output logic [XLEN-1:0] ex_mul_result,
    output logic [PRF_ADDRESS-1:0] ex_mul_prd,
    output logic [ROB_PTR_SIZE-1:0] ex_mul_rob_index,
    output logic cdb_mul_busy,
    output logic ex_div_valid,
    output logic [XLEN-1:0] ex_div_result,
    output logic [PRF_ADDRESS-1:0] ex_div_prd,
    output logic [ROB_PTR_SIZE-1:0] ex_div_rob_index,
    output logic cdb_div_busy,
    output logic ex_mem_address1_available, ex_is_load1, ex_is_store1,
    output logic [XLEN-1:0] ex_mem_address1
);

    logic is_mul1, is_div1, is_alu1;
    logic is_mul2, is_div2, is_alu2;
    logic [XLEN-1:0] instr1_rs1_data, instr1_rs2_data;
    logic [XLEN-1:0] instr2_rs1_data, instr2_rs2_data;
    logic [XLEN-1:0] internal_alu_result1, internal_alu_result2;
    logic prev_alu1_valid, prev_alu1_regwrite;
    logic [PRF_ADDRESS-1:0] prev_alu1_prd;
    logic [XLEN-1:0] prev_alu1_result;
    logic prev_alu2_valid, prev_alu2_regwrite;
    logic [PRF_ADDRESS-1:0] prev_alu2_prd;
    logic [XLEN-1:0] prev_alu2_result;

    always_comb begin
        is_mul1 = (rr_is_m_extension1 && rr_alu_operation1[4:2] == 3'b100);
        is_div1 = (rr_is_m_extension1 && (rr_alu_operation1[4:2] == 3'b101 || rr_alu_operation1[4:2] == 3'b110));
        is_alu1 = !(is_mul1 || is_div1);  

        is_mul2 = (rr_is_m_extension2 && rr_alu_operation2[4:2] == 3'b100);
        is_div2 = (rr_is_m_extension2 && (rr_alu_operation2[4:2] == 3'b101 || rr_alu_operation2[4:2] == 3'b110));
        is_alu2 = !(is_mul2 || is_div2);  
    end

    always_ff @(posedge CLK) begin
        if (reset || rob_global_flush) begin
            prev_alu1_valid <= 1'b0;
            prev_alu2_valid <= 1'b0;
            prev_alu1_regwrite <= 1'b0;
            prev_alu2_regwrite <= 1'b0;
            prev_alu1_prd <= '0;
            prev_alu2_prd <= '0;
            prev_alu1_result <= '0;
            prev_alu2_result <= '0;
        end else begin
            prev_alu1_valid    <= rr_valid1 && is_alu1 && rr_regwrite1 && !flush; 
            prev_alu1_regwrite <= rr_regwrite1;
            prev_alu1_prd      <= rr_prd1;
            prev_alu1_result   <= internal_alu_result1;

            prev_alu2_valid    <= rr_valid2 && is_alu2 && rr_regwrite2 && !flush; 
            prev_alu2_regwrite <= rr_regwrite2;
            prev_alu2_prd      <= rr_prd2;
            prev_alu2_result   <= internal_alu_result2;
        end
    end

    logic [1:0] fw_a1, fw_b1, fw_a2, fw_b2;
    ForwardingUnit fu_instantiation (
        .prev_alu1_valid    (prev_alu1_valid), 
        .prev_alu1_regwrite (prev_alu1_regwrite), 
        .prev_alu1_prd      (prev_alu1_prd),
        .prev_alu2_valid    (prev_alu2_valid), 
        .prev_alu2_regwrite (prev_alu2_regwrite), 
        .prev_alu2_prd      (prev_alu2_prd),
        .rr_instr1_prs1     (rr_instr1_prs1), 
        .rr_instr1_prs2     (rr_instr1_prs2),
        .rr_instr2_prs1     (rr_instr2_prs1), 
        .rr_instr2_prs2     (rr_instr2_prs2),
        .rr_valid1          (rr_valid1 && is_alu1), 
        .rr_regwrite1       (rr_regwrite1), 
        .rr_prd1            (rr_prd1),
        .forward_ALU1_A     (fw_a1),
        .forward_ALU1_B     (fw_b1),
        .forward_ALU2_A     (fw_a2), 
        .forward_ALU2_B     (fw_b2)
    );

    logic [XLEN-1:0] fw_read_data1_1, fw_read_data1_2;
    logic [XLEN-1:0] fw_read_data2_1, fw_read_data2_2;
    always_comb begin
        case (fw_a1)
            2'b01: fw_read_data1_1 = prev_alu1_result;       
            2'b10: fw_read_data1_1 = prev_alu2_result;     
            default: fw_read_data1_1 = rr_instr1_read_data1;
        endcase
        case (fw_b1)
            2'b01: fw_read_data1_2 = prev_alu1_result;
            2'b10: fw_read_data1_2 = prev_alu2_result;
            default: fw_read_data1_2 = rr_instr1_read_data2;
        endcase
        case (fw_a2)
            2'b01: fw_read_data2_1 = prev_alu1_result;
            2'b10: fw_read_data2_1 = prev_alu2_result;
            2'b11: fw_read_data2_1 = internal_alu_result1;
            default: fw_read_data2_1 = rr_instr2_read_data1;
        endcase
        case (fw_b2)
            2'b01: fw_read_data2_2 = prev_alu1_result;
            2'b10: fw_read_data2_2 = prev_alu2_result;
            2'b11: fw_read_data2_2 = internal_alu_result1;
            default: fw_read_data2_2 = rr_instr2_read_data2;
        endcase
        
        // VERILATOR FIX: Explicit Width Casting for Constants
        instr1_rs1_data = (rr_upperimm1) ? {XLEN{1'b0}} : ((rr_instr1_regsrc1) ? fw_read_data1_1 : {rr_pc1, 2'b00});
        instr2_rs1_data = (rr_upperimm2) ? {XLEN{1'b0}} : ((rr_instr2_regsrc1) ? fw_read_data2_1 : {rr_pc2, 2'b00});
        instr1_rs2_data = (rr_retaddr1)  ? XLEN'(4)     : ((rr_instr1_regsrc2) ? fw_read_data1_2 : rr_immediate1);  
        instr2_rs2_data = (rr_retaddr2)  ? XLEN'(4)     : ((rr_instr2_regsrc2) ? fw_read_data2_2 : rr_immediate2);
    end

    ALU alu1_instantiation (
        .valid              (rr_valid1), 
        .dataA              (instr1_rs1_data), 
        .dataB              (instr1_rs2_data),
        .rr_alu_operation   (rr_alu_operation1), 
        .alu_result         (internal_alu_result1)        
    );

    ALU alu2_instantiation (
        .valid              (rr_valid2), 
        .dataA              (instr2_rs1_data), 
        .dataB              (instr2_rs2_data),
        .rr_alu_operation   (rr_alu_operation2), 
        .alu_result         (internal_alu_result2)      
    );

    logic branch1_active, branch2_active, branch1_actual_taken, branch2_actual_taken;
    logic [XLEN-1:0] branch1_actual_target, branch2_actual_target;
    logic branch1_mispredicted, branch2_mispredicted;

    always_comb begin
        branch1_active = rr_valid1 && !rob_global_flush && (rr_branch1 || rr_jump1 || rr_jump_reg1);
        branch2_active = rr_valid2 && !rob_global_flush && (rr_branch2 || rr_jump2 || rr_jump_reg2);

        branch1_actual_taken = rr_jump1 || rr_jump_reg1 || (rr_branch1 && internal_alu_result1[0]);
        branch2_actual_taken = rr_jump2 || rr_jump_reg2 || (rr_branch2 && internal_alu_result2[0]);
         
        branch1_actual_target = ((rr_jump_reg1) ? instr1_rs1_data : {rr_pc1, 2'b00}) + rr_immediate1;        
        branch2_actual_target = ((rr_jump_reg2) ? instr2_rs1_data : {rr_pc2, 2'b00}) + rr_immediate2;
         
        branch1_mispredicted = (branch1_actual_taken != biq_pred_taken1) || (branch1_actual_taken && (branch1_actual_target != biq_pred_target1));
        branch2_mispredicted = (branch2_actual_taken != biq_pred_taken2) || (branch2_actual_taken && (branch2_actual_target != biq_pred_target2));

        // VERILATOR FIX: Set explicit widths on all defaults to avoid latch/trunc warnings
        cdb_branch_resolved = 1'b0; 
        cdb_branch_correct = 1'b0; 
        cdb_branch_tag = {BTAG_SIZE{1'b0}}; 
        flush = 1'b0;
        ex_actual_taken = 1'b0; 
        update_pht = 1'b0; 
        ex_is_jalr = 1'b0; 
        ex_is_ret = 1'b0; 
        ex_is_branch = 1'b0;
        ex_actual_target_address = {XLEN{1'b0}}; 
        ex_pc = {XLEN{1'b0}};

        if (branch1_active) begin
            cdb_branch_resolved = 1'b1; 
            cdb_branch_correct = !branch1_mispredicted; 
            cdb_branch_tag = rr_branch_tag1; 
            flush = branch1_mispredicted;  
            ex_actual_taken = branch1_actual_taken; 
            update_pht = rr_branch1; 
            ex_is_jalr = rr_jump_reg1; 
            ex_is_ret = rr_jump_reg1 && !rr_retaddr1; 
            ex_is_branch = rr_branch1;
            ex_actual_target_address = branch1_actual_target; 
            ex_pc = {rr_pc1, 2'b00};
        end
        else if (branch2_active) begin
            cdb_branch_resolved = 1'b1; 
            cdb_branch_correct = !branch2_mispredicted;
            cdb_branch_tag = rr_branch_tag2; 
            flush = branch2_mispredicted;
            ex_actual_taken = branch2_actual_taken; 
            update_pht = rr_branch2; 
            ex_is_jalr = rr_jump_reg2; 
            ex_is_ret = rr_jump_reg2 && !rr_retaddr2; 
            ex_is_branch = rr_branch2;
            ex_actual_target_address = branch2_actual_target; 
            ex_pc = {rr_pc2, 2'b00};
        end
    end

    // MUL & DIV
    MUL_Unit mul_inst (
        .CLK                    (CLK), 
        .reset                  (reset), 
        .flush                  (flush), 
        .rob_global_flush       (rob_global_flush),
        .cdb_branch_tag         (cdb_branch_tag), 
        .cdb_branch_resolved    (cdb_branch_resolved), 
        .cdb_branch_correct     (cdb_branch_correct),
        .mul_ack                (mul_ack), 
        .valid                  ((rr_valid1 && is_mul1) || (rr_valid2 && is_mul2)),
        .rr_branch_mask         ((rr_valid1 && is_mul1) ? rr_branch_mask1 : rr_branch_mask2),
        .rs1_data               ((rr_valid1 && is_mul1) ? instr1_rs1_data : instr2_rs1_data),
        .rs2_data               ((rr_valid1 && is_mul1) ? instr1_rs2_data : instr2_rs2_data),
        .alu_operation          ((rr_valid1 && is_mul1) ? rr_alu_operation1 : rr_alu_operation2),
        .rr_prd                 ((rr_valid1 && is_mul1) ? rr_prd1 : rr_prd2),
        .rr_rob_index           ((rr_valid1 && is_mul1) ? rr_rob_index1 : rr_rob_index2),
        .cdb_mul_busy           (cdb_mul_busy),
        .cdb_write_data         (ex_mul_valid), 
        .cdb_alu_result         (ex_mul_result),
        .cdb_prd                (ex_mul_prd),
        .cdb_rob_index          (ex_mul_rob_index)
    );

    DIV_Unit div_inst (
        .CLK                    (CLK), 
        .reset                  (reset), 
        .flush                  (flush), 
        .rob_global_flush       (rob_global_flush),
        .cdb_branch_tag         (cdb_branch_tag), 
        .cdb_branch_resolved    (cdb_branch_resolved), 
        .cdb_branch_correct     (cdb_branch_correct),
        .div_ack                (div_ack), 
        .valid                  ((rr_valid1 && is_div1) || (rr_valid2 && is_div2)), 
        .rr_branch_mask         ((rr_valid1 && is_div1) ? rr_branch_mask1 : rr_branch_mask2),
        .rs1_data               ((rr_valid1 && is_div1) ? instr1_rs1_data : instr2_rs1_data),
        .rs2_data               ((rr_valid1 && is_div1) ? instr1_rs2_data : instr2_rs2_data),
        .alu_operation          ((rr_valid1 && is_div1) ? rr_alu_operation1 : rr_alu_operation2),
        .rr_prd                 ((rr_valid1 && is_div1) ? rr_prd1 : rr_prd2),
        .rr_rob_index           ((rr_valid1 && is_div1) ? rr_rob_index1 : rr_rob_index2),
        .cdb_div_busy           (cdb_div_busy), 
        .cdb_write_data         (ex_div_valid),
        .cdb_alu_result         (ex_div_result),
        .cdb_prd                (ex_div_prd),
        .cdb_rob_index          (ex_div_rob_index)
    );

    always_comb begin
        ex_alu1_valid = rr_valid1 && !rob_global_flush && is_alu1 && rr_regwrite1;
        ex_alu1_regwrite = rr_regwrite1;
        ex_alu1_result = internal_alu_result1;
        ex_alu1_prd = rr_prd1;
        ex_alu1_rob_index = rr_rob_index1;

        ex_alu2_valid = rr_valid2 && !rob_global_flush && is_alu2 && rr_regwrite2;
        ex_alu2_regwrite = rr_regwrite2;
        ex_alu2_result = internal_alu_result2;
        ex_alu2_prd = rr_prd2;
        ex_alu2_rob_index = rr_rob_index2;
        
        ex_mem_address1_available = rr_valid1 && !rob_global_flush && (rr_memtoreg1 || rr_memwrite1);
        ex_is_load1 = rr_memtoreg1;
        ex_is_store1 = rr_memwrite1;
        ex_mem_address1 = internal_alu_result1;
    end
endmodule