module RN_Stage #(
    parameter PRF_ADDRESS = 6,
    parameter INIT_IMMEDIATE_SIZE = 21, 
    parameter MAX_BRANCHES = 4,
    parameter BTAG_SIZE = $clog2(MAX_BRANCHES),
    parameter BIQ_ADDRESS = 5,
    parameter XLEN = 32,
    parameter NUM_PHY_REG = 1 << PRF_ADDRESS,
    parameter FL_ROWS = NUM_PHY_REG - 32,
    parameter FL_INDEX_WIDTH = $clog2(FL_ROWS),
    parameter FL_PTR_WIDTH = FL_INDEX_WIDTH + 1
) (
    input logic CLK, 
    input logic reset, 
    input logic flush, 
    input logic id_take_snap, id_valid1, id_valid2,
    input logic cdb_wakeup1, cdb_wakeup2, comm_free_push1, comm_free_push2, ex_branch_resolved,
    input logic [PRF_ADDRESS-1:0] cdb_waked_reg1, cdb_waked_reg2, comm_free_reg1, comm_free_reg2,
    input logic [BTAG_SIZE-1:0] ex_btag,
    input logic [2:0] id_funct3_1, id_funct3_2,
    input logic [6:0] id_funct7_1, id_funct7_2,
    input logic [4:0] id_rs1_1, id_rs2_1, id_rd_1,
    input logic [4:0] id_rs1_2, id_rs2_2, id_rd_2,
    input logic [INIT_IMMEDIATE_SIZE-1:0] id_immout1, id_immout2,
    input logic [BIQ_ADDRESS-1:0] id_biq_address,
    input logic [XLEN-3:0] id_pc,
    input logic [2:0] id_alu_op1, id_alu_op2,
    input logic id_jump_reg1, id_jump_reg2, id_jump1, id_jump2, id_branch1, id_branch2, id_regsrc1_1,  
    input logic id_immtype1, id_memwrite1,  id_immtype2, id_regsrc2_1,
    input logic id_regsrc1_2, id_regsrc2_2, id_upperimm1, id_upperimm2, id_regwrite1, id_regwrite2, 
    input logic id_memwrite2, id_memtoreg1, id_memtoreg2, id_retaddr1, id_retaddr2, id_isimm1, id_isimm2,
    output logic stall_frontend,
    output logic [PRF_ADDRESS-1:0] rn_prd1, rn_prs1_1, rn_prs2_1, rn_old_prd1, 
    output logic [PRF_ADDRESS-1:0] rn_prd2, rn_prs1_2, rn_prs2_2, rn_old_prd2,             
    output logic rn_prs1_busy1, rn_prs2_busy1, rn_prs1_busy2, rn_prs2_busy2,
    output logic [BTAG_SIZE-1:0] rn_branch_tag,
    output logic [MAX_BRANCHES-1:0] rn_branch_mask,
    output logic [BIQ_ADDRESS-1:0] rn_biq_address,
    output logic [XLEN-3:0] rn_pc,
    output logic [2:0] rn_funct3_1, rn_funct3_2,
    output logic [6:0] rn_funct7_1, rn_funct7_2,
    output logic [INIT_IMMEDIATE_SIZE-1:0] rn_immout1, rn_immout2,
    output logic [2:0] rn_alu_op1, rn_alu_op2,
    output logic rn_valid1, rn_jump_reg1, rn_jump1, rn_branch1, 
    output logic rn_regsrc1_1, rn_regsrc2_1, rn_immtype1, rn_isimm1, rn_retaddr1,
    output logic rn_upperimm1, rn_regwrite1, rn_memwrite1, rn_memtoreg1, 

    output logic rn_valid2, rn_jump_reg2, rn_jump2, rn_branch2, 
    output logic rn_regsrc1_2, rn_regsrc2_2, rn_immtype2, rn_isimm2, rn_retaddr2,
    output logic rn_upperimm2, rn_regwrite2, rn_memwrite2, rn_memtoreg2
);
    logic [PRF_ADDRESS-1:0] fl_freed_reg1, fl_freed_reg2;        
    logic [PRF_ADDRESS-1:0] bs_rmt_snap [0:31];
    logic [PRF_ADDRESS-1:0] rmt_snap [0:31];
    logic [FL_PTR_WIDTH-1:0] fl_head_ptr, bs_head_ptr_snap;
    logic [PRF_ADDRESS-1:0] routed_freed_reg1, routed_freed_reg2;

    logic pop1, pop2, bs_full, fl_empty;

    assign pop1 = id_valid1 && id_regwrite1 && (id_rd_1 != 5'b0);
    assign pop2 = id_valid2 && id_regwrite2 && (id_rd_2 != 5'b0);
   
    assign routed_freed_reg1 = fl_freed_reg1;
    assign routed_freed_reg2 = (pop1) ? fl_freed_reg2 : fl_freed_reg1;
    assign stall_frontend = bs_full || fl_empty;

    always_ff @(posedge CLK) begin 
        rn_biq_address <= id_biq_address;
        rn_pc <= id_pc;
        // Instruction 1 Control Signals
        rn_funct3_1  <= id_funct3_1;
        rn_funct7_1  <= id_funct7_1;
        rn_valid1    <= id_valid1 && !flush && !stall_frontend;
        rn_immout1 <= id_immout1;
        rn_alu_op1 <= id_alu_op1;
        rn_jump_reg1 <= id_jump_reg1;
        rn_jump1     <= id_jump1;
        rn_branch1   <= id_branch1;
        rn_regsrc1_1 <= id_regsrc1_1;
        rn_regsrc2_1 <= id_regsrc2_1;
        rn_immtype1  <= id_immtype1;
        rn_isimm1    <= id_isimm1;
        rn_upperimm1 <= id_upperimm1;
        rn_regwrite1 <= id_regwrite1;
        rn_memwrite1 <= id_memwrite1;
        rn_memtoreg1 <= id_memtoreg1;
        rn_retaddr1  <= id_retaddr1;
        // Instruction 2 Control Signals
        rn_funct3_2  <= id_funct3_2;
        rn_funct7_2  <= id_funct7_2;
        rn_valid2    <= id_valid2 && !flush && !stall_frontend;
        rn_immout2 <= id_immout2;
        rn_alu_op2 <= id_alu_op2;
        rn_jump_reg2 <= id_jump_reg2;
        rn_jump2     <= id_jump2;
        rn_branch2   <= id_branch2;
        rn_regsrc1_2 <= id_regsrc1_2;
        rn_regsrc2_2 <= id_regsrc2_2;
        rn_immtype2  <= id_immtype2;
        rn_isimm2    <= id_isimm2;
        rn_upperimm2 <= id_upperimm2;
        rn_regwrite2 <= id_regwrite2;
        rn_memwrite2 <= id_memwrite2;
        rn_memtoreg2 <= id_memtoreg2;
        rn_retaddr2  <= id_retaddr2;
    end
    RMT rmt_instantiation (
        .CLK                (CLK),
        .reset              (reset),
        .restore_rmt        (flush),
        .stall_frontend     (stall_frontend),
        .reg_write1         (id_regwrite1 && id_valid1), 
        .reg_write2         (id_regwrite2 && id_valid2),
        .id_valid1          (id_valid1),
        .id_valid2          (id_valid2),
        .cdb_wakeup1        (cdb_wakeup1),
        .cdb_wakeup2        (cdb_wakeup2),
        .id_branch1         (id_branch1),
        .id_jump1           (id_jump1),

        .rd1                (id_rd_1),
        .rs1_1              (id_rs1_1),
        .rs2_1              (id_rs2_1),

        .rd2                (id_rd_2),
        .rs1_2              (id_rs1_2),
        .rs2_2              (id_rs2_2),

        .fl_freed_reg1      (routed_freed_reg1),
        .fl_freed_reg2      (routed_freed_reg2),
        .cdb_waked_reg1     (cdb_waked_reg1),
        .cdb_waked_reg2     (cdb_waked_reg2),
        
        .bs_rmt_snap        (bs_rmt_snap),
        
        .prd1               (rn_prd1),
        .old_prd1           (rn_old_prd1),
        .prs1_1             (rn_prs1_1),
        .prs2_1             (rn_prs2_1),
        .prs1_busy1         (rn_prs1_busy1),
        .prs2_busy1         (rn_prs2_busy1),
        
        .prd2               (rn_prd2),
        .old_prd2           (rn_old_prd2),
        .prs1_2             (rn_prs1_2),
        .prs2_2             (rn_prs2_2),
        .prs1_busy2         (rn_prs1_busy2),
        .prs2_busy2         (rn_prs2_busy2),
        
        .rmt_snap           (rmt_snap)
    );

    FL fl_instantiation (
        .CLK                (CLK),
        .reset              (reset),
        .flush              (flush),
        .stall_frontend     (stall_frontend),
        .pop1               (pop1),
        .pop2               (pop2),
        .id_branch1         (id_branch1),
        .id_jump1           (id_jump1),
        .id_valid1          (id_valid1),
        .bs_head_ptr_snap   (bs_head_ptr_snap), 
        
        .push1              (comm_free_push1),
        .push2              (comm_free_push2),
        .comm_free_reg1     (comm_free_reg1),     
        .comm_free_reg2     (comm_free_reg2), 
        //output  
        .fl_head_ptr        (fl_head_ptr),        
        .fl_freed_reg1      (fl_freed_reg1),      
        .fl_freed_reg2      (fl_freed_reg2),      
        .fl_empty           (fl_empty)    //signal for frontend  

    );

    BS bs_instantiation (
        .CLK                    (CLK),
        .reset                  (reset),
        .id_take_snap           (id_take_snap && !stall_frontend && !flush),  //if branch instructions then take snapshot
        .flush                  (flush),
        .rmt_snap               (rmt_snap),           
        .freelist_head_snap     (fl_head_ptr),   
        .id_branch1             (id_branch1),
        .id_jump1               (id_jump1),
        .id_valid1              (id_valid1),
        //from ex stage to reset branch mask register when branch gets resolved
        .ex_branch_resolved     (ex_branch_resolved), 
        .ex_btag                (ex_btag),
        //to store the updated mapping of map table
        .pop1                   (pop1 && !stall_frontend),
        .pop2                   (pop2 && !stall_frontend),

        //output     
        .bs_branch_tag          (rn_branch_tag),      
        .bs_branch_mask         (rn_branch_mask),     
        
        // Restoring the rat and busytable and free list
        .bs_rmt_snap            (bs_rmt_snap),        
        .bs_freelist_head_snap  (bs_head_ptr_snap),
        .bs_full                (bs_full)    
    );

endmodule