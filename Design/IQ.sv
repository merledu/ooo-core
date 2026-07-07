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
    input logic CLK, reset, stall_frontend, flush, cdb_wakeup1, cdb_wakeup2,
    input logic [PRF_ADDRESS-1:0] rn_prd1, rn_prs1_1, rn_prs2_1, cdb_waked_reg1, cdb_waked_reg2,
    input logic [PRF_ADDRESS-1:0] rn_prd2, rn_prs1_2, rn_prs2_2,       
    input logic rn_prs1_busy1, rn_prs2_busy1, rn_prs1_busy2, rn_prs2_busy2,
    input logic [BTAG_SIZE-1:0] rn_branch_tag, cdb_branch_tag,
    input logic [MAX_BRANCHES-1:0] rn_branch_mask,
    input logic [BIQ_ADDRESS-1:0] rn_biq_address,
    input logic [XLEN-3:0] rn_pc,
    input logic [INIT_IMMEDIATE_SIZE-1:0] rn_immout1, rn_immout2,
    input logic [3:0] rn_alu_operation1, rn_alu_operation2,
    input logic rn_valid1, rn_jump_reg1, rn_jump1, rn_branch1, 
    input logic rn_regsrc1_1, rn_regsrc2_1, rn_immtype1, rn_isimm1, rn_retaddr1,
    input logic rn_upperimm1, rn_regwrite1, rn_memwrite1, rn_memtoreg1, 
    input logic rn_valid2, rn_jump_reg2, rn_jump2, rn_branch2, 
    input logic rn_regsrc1_2, rn_regsrc2_2, rn_immtype2, rn_isimm2, rn_retaddr2,
    input logic rn_upperimm2, rn_regwrite2, rn_memwrite2, rn_memtoreg2,

    output logic iq_full
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

    logic [IQ_ADDRESS-1:0] iq_alloc_index1, iq_alloc_index2;
    logic alloc1_found, alloc2_found;

    always_comb begin
        iq_alloc_index1   = '0;
        iq_alloc_index2   = '0;
        alloc1_found = 1'b0;
        alloc2_found = 1'b0;
        iq_full = 0;
        
        for (int i = 0; i < IQ_ROWS; i++) begin
            if (IQ[i].available && !alloc1_found) begin
                iq_alloc_index1 = i;
                alloc1_found = 1'b1;
            end 
            else if (IQ[i].available && alloc1_found && !alloc2_found) begin
                iq_alloc_index2 = i;
                alloc2_found = 1'b1;
            end
        end

        // iq is full if we dont have enough slots for the VALID instructions
        iq_full = (rn_valid1 && rn_valid2 && !alloc2_found) || ((rn_valid1 || rn_valid2) && !alloc1_found);
    end

    always_ff @(posedge CLK) begin 
        if (reset) begin
            for (int i = 0; i < IQ_ROWS; i++) begin
                IQ[i].available <= 1;
            end
        end
        else begin
            for (int i = 0; i < IQ_ROWS; i++) begin
                //if instruction is flushed
                if (flush && !IQ[i].available && IQ[i].branch_mask[cdb_branch_tag]) begin
                    IQ[i].available <= 1'b1;
                end
                //if the instruction is not flushed
                else if (!IQ[i].available) begin 
                    // wake up prs1
                    if (IQ[i].prs1_busy) begin
                        if ((cdb_wakeup1 && (IQ[i].prs1 == cdb_waked_reg1)) || 
                            (cdb_wakeup2 && (IQ[i].prs1 == cdb_waked_reg2))) begin
                            IQ[i].prs1_busy <= 1'b0;
                        end
                    end
                    // wake up prs2
                    if (IQ[i].prs2_busy) begin
                        if ((cdb_wakeup1 && (IQ[i].prs2 == cdb_waked_reg1)) || 
                            (cdb_wakeup2 && (IQ[i].prs2 == cdb_waked_reg2))) begin
                            IQ[i].prs2_busy <= 1'b0;
                        end
                    end
                end
            end 
            if(!stall_frontend && !iq_full) begin
                if (alloc1_found && rn_valid1) begin
                    IQ[iq_alloc_index1].available     <= 0;
                    IQ[iq_alloc_index1].pc            <= rn_pc;
                    IQ[iq_alloc_index1].prd           <= rn_prd1; 
                    IQ[iq_alloc_index1].prs1          <= rn_prs1_1;
                    IQ[iq_alloc_index1].prs1_busy     <= rn_prs1_busy1;
                    IQ[iq_alloc_index1].prs2          <= rn_prs2_1;
                    IQ[iq_alloc_index1].immediate     <= rn_immout1; 
                    IQ[iq_alloc_index1].prs2_busy     <= rn_prs2_busy1;
                    IQ[iq_alloc_index1].alu_operation <= rn_alu_operation1;
                    IQ[iq_alloc_index1].jump_reg      <= rn_jump_reg1;
                    IQ[iq_alloc_index1].jump          <= rn_jump1; 
                    IQ[iq_alloc_index1].branch        <= rn_branch1;
                    IQ[iq_alloc_index1].regsrc1       <= rn_regsrc1_1;
                    IQ[iq_alloc_index1].regsrc2       <= rn_regsrc2_1;
                    IQ[iq_alloc_index1].immtype       <= rn_immtype1;
                    IQ[iq_alloc_index1].isimm         <= rn_isimm1; 
                    IQ[iq_alloc_index1].retaddr       <= rn_retaddr1;
                    IQ[iq_alloc_index1].upperimm      <= rn_upperimm1;
                    IQ[iq_alloc_index1].regwrite      <= rn_regwrite1;
                    IQ[iq_alloc_index1].memwrite      <= rn_memwrite1;
                    IQ[iq_alloc_index1].memtoreg      <= rn_memtoreg1; 
                    IQ[iq_alloc_index1].branch_tag    <= rn_branch_tag;
                    IQ[iq_alloc_index1].branch_mask   <= rn_branch_mask; 
                    IQ[iq_alloc_index1].biq_address   <= rn_biq_address;
                end
                if (alloc2_found && rn_valid2) begin
                    IQ[iq_alloc_index2].available     <= 0;
                    IQ[iq_alloc_index2].pc            <= rn_pc;
                    IQ[iq_alloc_index2].prd           <= rn_prd2; 
                    IQ[iq_alloc_index2].prs1          <= rn_prs1_2;
                    IQ[iq_alloc_index2].prs1_busy     <= rn_prs1_busy2;
                    IQ[iq_alloc_index2].prs2          <= rn_prs2_2;
                    IQ[iq_alloc_index2].immediate     <= rn_immout2; 
                    IQ[iq_alloc_index2].prs2_busy     <= rn_prs2_busy2;
                    IQ[iq_alloc_index2].alu_operation <= rn_alu_operation2;
                    IQ[iq_alloc_index2].jump_reg      <= rn_jump_reg2;
                    IQ[iq_alloc_index2].jump          <= rn_jump2; 
                    IQ[iq_alloc_index2].branch        <= rn_branch2;
                    IQ[iq_alloc_index2].regsrc1       <= rn_regsrc1_2;
                    IQ[iq_alloc_index2].regsrc2       <= rn_regsrc2_2;
                    IQ[iq_alloc_index2].immtype       <= rn_immtype2;
                    IQ[iq_alloc_index2].isimm         <= rn_isimm2; 
                    IQ[iq_alloc_index2].retaddr       <= rn_retaddr2;
                    IQ[iq_alloc_index2].upperimm      <= rn_upperimm2;
                    IQ[iq_alloc_index2].regwrite      <= rn_regwrite2;
                    IQ[iq_alloc_index2].memwrite      <= rn_memwrite2;
                    IQ[iq_alloc_index2].memtoreg      <= rn_memtoreg2; 
                    IQ[iq_alloc_index2].branch_tag    <= rn_branch_tag;
                    IQ[iq_alloc_index2].branch_mask   <= rn_branch_mask; 
                    IQ[iq_alloc_index2].biq_address   <= rn_biq_address;
                end
            end
        end
    end
            
endmodule
