module IQ #(
    parameter XLEN = 32,
    parameter PRF_ADDRESS = 6,
    parameter INIT_IMMEDIATE_SIZE = 21,
    parameter MAX_BRANCHES = 4,
    parameter BTAG_SIZE = $clog2(MAX_BRANCHES),
    parameter BIQ_ADDRESS = 5,
    parameter IQ_ROWS = 64,
    parameter IQ_ADDRESS = $clog2(IQ_ROWS)
) (
    input logic CLK, reset, stall_frontend, flush,
    input logic [PRF_ADDRESS-1:0] rn_prd1, rn_prs1_1, rn_prs2_1, 
    input logic [PRF_ADDRESS-1:0] rn_prd2, rn_prs1_2, rn_prs2_2,       
    input logic rn_prs1_busy1, rn_prs2_busy1, rn_prs1_busy2, rn_prs2_busy2,
    input logic [BTAG_SIZE-1:0] rn_branch_tag, cdb_branch_tag,
    input logic [MAX_BRANCHES-1:0] rn_branch_mask,
    input logic [BIQ_ADDRESS-1:0] rn_biq_address,
    input logic [XLEN-3:0] rn_pc,
    input logic [4:0] rn_rd_1, rn_rd_2,
    input logic [INIT_IMMEDIATE_SIZE-1:0] rn_immout1, rn_immout2,
    input logic [3:0] rn_alu_operation1, rn_alu_operation2,
    input logic rn_valid1, rn_jump_reg1, rn_jump1, rn_branch1, 
    input logic rn_regsrc1_1, rn_regsrc2_1, rn_immtype1, rn_isimm1, rn_retaddr1,
    input logic rn_upperimm1, rn_regwrite1, rn_memwrite1, rn_memtoreg1, 
    input logic rn_valid2, rn_jump_reg2, rn_jump2, rn_branch2, 
    input logic rn_regsrc1_2, rn_regsrc2_2, rn_immtype2, rn_isimm2, rn_retaddr2,
    input logic rn_upperimm2, rn_regwrite2, rn_memwrite2, rn_memtoreg2,
);
    typedef struct packed {
        logic available;
        logic [XLEN-3:0] pc;
        logic [PRF_ADDRESS-1:0] prd; 
        logic [PRF_ADDRESS-1:0] prs1;
        logic prs1_busy;
        logic [PRF_ADDRESS-1:0] prs2; 
        logic [INIT_IMMEDIATE_SIZE-1:0] immediate;
        logic prs2_busy;
        logic [3:0] alu_operation;
        logic jump_reg;
        logic jump;
        logic branch;
        logic regsrc1;
        logic regsrc2;
        logic immtype;
        logic isimm;
        logic retaddr;
        logic upperimm;
        logic regwrite;
        logic memwrite;
        logic memtoreg;
        logic [BTAG_SIZE-1:0] branch_tag;
        logic [MAX_BRANCHES-1:0] branch_mask;
        logic [BIQ_ADDRESS-1:0] biq_address;
    } IQ_organization;
    
    IQ_organization IQ [0:IQ_ROWS-1];

        // 1. Declare signals to hold the found indices
    logic [IQ_ADDRESS-1:0] alloc_idx1, alloc_idx2;
    logic alloc1_found, alloc2_found;

    // 2. Combinational block to find the first two available slots
    always_comb begin
        alloc_idx1   = '0;
        alloc_idx2   = '0;
        alloc1_found = 1'b0;
        alloc2_found = 1'b0;

        for (int i = 0; i < IQ_ROWS; i++) begin
            if (IQ[i].available && !alloc1_found) begin
                alloc_idx1 = i;
                alloc1_found = 1'b1;
            end 
            else if (IQ[i].available && alloc1_found && !alloc2_found) begin
                alloc_idx2 = i;
                alloc2_found = 1'b1;
            end
        end
    end
    always_ff @(posedge CLK) begin 
        if(!stall_frontend) begin
            for (i = 0; i < IQ_ROWS; i++) begin
                if (IQ[i].available && rn_valid1) begin
                    IQ[i].available     <= 0;
                    IQ[i].pc            <= rn_pc;
                    IQ[i].prd           <= rn_prd1; 
                    IQ[i].prs1          <= rn_prs1_1;
                    IQ[i].prs1_busy     <= rn_prs1_busy1;
                    IQ[i].prs2          <= rn_prs2_1;
                    IQ[i].immediate     <= rn_immout1; 
                    IQ[i].prs2_busy     <= rn_prs2_busy1;
                    IQ[i].alu_operation <= rn_alu_operation1;
                    IQ[i].jump_reg      <= rn_jump_reg1;
                    IQ[i].jump          <= rn_jump1; 
                    IQ[i].branch        <= rn_branch1;
                    IQ[i].regsrc1       <= rn_regsrc1_1;
                    IQ[i].regsrc2       <= rn_regsrc2_1;
                    IQ[i].immtype       <= rn_immtype1;
                    IQ[i].isimm         <= rn_isimm1; 
                    IQ[i].retaddr       <= rn_retaddr1;
                    IQ[i].upperimm      <= rn_upperimm1;
                    IQ[i].regwrite      <= rn_regwrite1;
                    IQ[i].memwrite      <= rn_memwrite1;
                    IQ[i].memtoreg      <= rn_memtoreg1; 
                    IQ[i].branch_tag    <= rn_branch_tag;
                    IQ[i].branch_mask   <= rn_branch_mask; 
                    IQ[i].biq_address   <= rn_biq_address;
                end
                break;
            end
            for (int j=i; j < IQ_ROWS; j++) begin
                if (IQ[j].available && rn_valid2) begin
                    IQ[j].available     <= 0;
                    IQ[j].pc            <= rn_pc;
                    IQ[j].prd           <= rn_prd2; 
                    IQ[j].prs1          <= rn_prs1_2;
                    IQ[j].prs1_busy     <= rn_prs1_busy2;
                    IQ[j].prs2          <= rn_prs2_2;
                    IQ[j].immediate     <= rn_immout2; 
                    IQ[j].prs2_busy     <= rn_prs2_busy2;
                    IQ[j].alu_operation <= rn_alu_operation2;
                    IQ[j].jump_reg      <= rn_jump_reg2;
                    IQ[j].jump          <= rn_jump2; 
                    IQ[j].branch        <= rn_branch2;
                    IQ[j].regsrc1       <= rn_regsrc1_2;
                    IQ[j].regsrc2       <= rn_regsrc2_2;
                    IQ[j].immtype       <= rn_immtype2;
                    IQ[j].isimm         <= rn_isimm2; 
                    IQ[j].retaddr       <= rn_retaddr2;
                    IQ[j].upperimm      <= rn_upperimm2;
                    IQ[j].regwrite      <= rn_regwrite2;
                    IQ[j].memwrite      <= rn_memwrite2;
                    IQ[j].memtoreg      <= rn_memtoreg2; 
                    IQ[j].branch_tag    <= rn_branch_tag;
                    IQ[j].branch_mask   <= rn_branch_mask; 
                    IQ[j].biq_address   <= rn_biq_address;
                end
                break;
            end
        end
        
    end
    
endmodule
