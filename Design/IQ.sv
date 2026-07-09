module IQ #(
    parameter XLEN = 32,
    parameter PRF_ADDRESS = 6,
    parameter INIT_IMMEDIATE_SIZE = 21,
    parameter MAX_BRANCHES = 4,
    parameter BTAG_SIZE = $clog2(MAX_BRANCHES),
    parameter BIQ_ADDRESS = 5,
    parameter IQ_ROWS = 64,
    parameter IQ_ADDRESS = $clog2(IQ_ROWS),
    parameter ROB_SIZE = 64,
    parameter ROB_PTR_SIZE = $clog2(ROB_SIZE)
) (
    input logic CLK, reset, rob_full, flush, cdb_wakeup1, cdb_wakeup2,
    input logic cdb_branch_resolved, cdb_branch_correct,
    input logic [PRF_ADDRESS-1:0] rn_prd1, rn_prs1_1, rn_prs2_1, cdb_waked_reg1, cdb_waked_reg2,
    input logic [PRF_ADDRESS-1:0] rn_prd2, rn_prs1_2, rn_prs2_2,       
    input logic rn_prs1_busy1, rn_prs2_busy1, rn_prs1_busy2, rn_prs2_busy2,
    input logic [BTAG_SIZE-1:0] rn_branch_tag, cdb_branch_tag,
    input logic [MAX_BRANCHES-1:0] rn_branch_mask,
    input logic [BIQ_ADDRESS-1:0] rn_biq_address,
    input logic [XLEN-3:0] rn_pc,
    input logic [INIT_IMMEDIATE_SIZE-1:0] rn_immout1, rn_immout2,
    input logic [4:0] rn_alu_operation1, rn_alu_operation2,
    input logic rn_is_m_extension1, rn_is_m_extension2,
    input logic rn_valid1, rn_jump_reg1, rn_jump1, rn_branch1, 
    input logic rn_regsrc1_1, rn_regsrc2_1, rn_immtype1, rn_isimm1, rn_retaddr1,
    input logic rn_upperimm1, rn_regwrite1, rn_memwrite1, rn_memtoreg1, 
    input logic rn_valid2, rn_jump_reg2, rn_jump2, rn_branch2, 
    input logic rn_regsrc1_2, rn_regsrc2_2, rn_immtype2, rn_isimm2, rn_retaddr2,
    input logic rn_upperimm2, rn_regwrite2, rn_memwrite2, rn_memtoreg2,
    input logic [ROB_PTR_SIZE-1:0] current_rob_index,

    output logic iq_full,
    // Issued Instruction 1
    output logic iss_valid1, iss_is_m_extension1, iss_jump_reg1, iss_jump1, iss_branch1, 
    output logic iss_instr1_regsrc1, iss_instr1_regsrc2, iss_immtype1, iss_isimm1, iss_retaddr1,
    output logic iss_upperimm1, iss_regwrite1, iss_memwrite1, iss_memtoreg1,
    output logic [XLEN-3:0] iss_pc1,
    output logic [PRF_ADDRESS-1:0] iss_prd1, iss_instr1_prs1, iss_instr1_prs2,
    output logic [INIT_IMMEDIATE_SIZE-1:0] iss_immediate1,
    output logic [4:0] iss_alu_operation1,
    output logic [BTAG_SIZE-1:0] iss_branch_tag1,
    output logic [MAX_BRANCHES-1:0] iss_branch_mask1,
    output logic [BIQ_ADDRESS-1:0] iss_biq_address1,
    output logic [ROB_PTR_SIZE-1:0] iss_rob_index1,

    // Issued Instruction 2
    output logic iss_valid2, iss_is_m_extension2, iss_jump_reg2, iss_jump2, iss_branch2, 
    output logic iss_instr2_regsrc1, iss_instr2_regsrc2, iss_immtype2, iss_isimm2, iss_retaddr2,
    output logic iss_upperimm2, iss_regwrite2, iss_memwrite2, iss_memtoreg2,
    output logic [XLEN-3:0] iss_pc2,
    output logic [PRF_ADDRESS-1:0] iss_prd2, iss_instr2_prs1, iss_instr2_prs2,
    output logic [INIT_IMMEDIATE_SIZE-1:0] iss_immediate2,
    output logic [4:0] iss_alu_operation2,
    output logic [BTAG_SIZE-1:0] iss_branch_tag2,
    output logic [MAX_BRANCHES-1:0] iss_branch_mask2,
    output logic [BIQ_ADDRESS-1:0] iss_biq_address2,
    output logic [ROB_PTR_SIZE-1:0] iss_rob_index2
);
    typedef struct packed {
        logic available;
        logic is_m_extension;
        logic [XLEN-3:0] pc;
        logic [PRF_ADDRESS-1:0] prd; 
        logic [PRF_ADDRESS-1:0] prs1;
        logic prs1_busy;
        logic [PRF_ADDRESS-1:0] prs2; 
        logic [INIT_IMMEDIATE_SIZE-1:0] immediate;
        logic prs2_busy;
        logic [4:0] alu_operation;
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
        logic [ROB_PTR_SIZE-1:0] rob_index;
    } IQ_organization;
    
    IQ_organization IQ [0:IQ_ROWS-1];

    logic [IQ_ADDRESS-1:0] iq_alloc_index1, iq_alloc_index2;
    logic alloc1_found, alloc2_found, fast_wakeup1, fast_wakeup2;
    logic [PRF_ADDRESS-1:0] fast_waked_reg1, fast_waked_reg2;
    logic [IQ_ADDRESS-1:0] issue_index1, issue_index2;
    logic is_control_flow_instr, issue1_found, issue2_found;

    always_comb begin
        iq_alloc_index1   = '0;
        iq_alloc_index2   = '0;
        alloc1_found      = 1'b0;
        alloc2_found      = 1'b0;
        iq_full           = 0;
        
        for (int i = 0; i < IQ_ROWS; i++) begin
            if (IQ[i].available && !alloc1_found) begin
                iq_alloc_index1 = IQ_ADDRESS'(i);
                alloc1_found = 1'b1;
            end 
            else if (IQ[i].available && alloc1_found && !alloc2_found) begin
                iq_alloc_index2 = IQ_ADDRESS'(i);
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
                    //if instruction is issued then free the slot
                    if (!flush && ((issue1_found && (IQ_ADDRESS'(i) == issue_index1))||(issue2_found && (IQ_ADDRESS'(i) == issue_index2)))) begin
                        IQ[i].available <= 1'b1;
                    end

                    //clearing branch mask after correctly predicted
                    if (cdb_branch_resolved && cdb_branch_correct) begin
                        IQ[i].branch_mask[cdb_branch_tag] <= 1'b0;
                    end
                    // wake up prs1
                    if (IQ[i].prs1_busy) begin
                        if ((cdb_wakeup1 && (IQ[i].prs1 == cdb_waked_reg1)) || 
                            (cdb_wakeup2 && (IQ[i].prs1 == cdb_waked_reg2)) || 
                            (fast_wakeup1 && (IQ[i].prs1 == fast_waked_reg1)) ||
                            (fast_wakeup2 && (IQ[i].prs1 == fast_waked_reg2))) begin
                            IQ[i].prs1_busy <= 1'b0;
                        end
                    end
                    // wake up prs2
                    if (IQ[i].prs2_busy) begin
                        if ((cdb_wakeup1 && (IQ[i].prs2 == cdb_waked_reg1)) || 
                            (cdb_wakeup2 && (IQ[i].prs2 == cdb_waked_reg2)) || 
                            (fast_wakeup1 && (IQ[i].prs1 == fast_waked_reg1)) ||
                            (fast_wakeup2 && (IQ[i].prs1 == fast_waked_reg2))) begin
                            IQ[i].prs2_busy <= 1'b0;
                        end
                    end
                end
            end 
            if(!rob_full && !iq_full && !flush) begin
                if (alloc1_found && rn_valid1) begin
                    IQ[iq_alloc_index1].available     <= 0;
                    IQ[iq_alloc_index1].is_m_extension<= rn_is_m_extension1;
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
                    IQ[iq_alloc_index1].rob_index     <= current_rob_index;
                end
                if (alloc2_found && rn_valid2) begin
                    IQ[iq_alloc_index2].available     <= 0;
                    IQ[iq_alloc_index2].is_m_extension<= rn_is_m_extension2;
                    IQ[iq_alloc_index2].pc            <= rn_pc + 1;
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
                    IQ[iq_alloc_index2].rob_index     <= current_rob_index + 1;
                end
            end
        end
    end

    //issue stage 
    always_comb begin
        issue_index1 = '0;
        issue_index2 = '0;
        issue1_found = 0;
        issue2_found = 0;
        is_control_flow_instr = 0;
        
        //only 1 branch is executed in 1 cycle for simplicity
        for (int i = 0; i < IQ_ROWS; i++) begin
            if (!IQ[i].available && !IQ[i].prs1_busy && !IQ[i].prs2_busy && !issue1_found) begin
                issue_index1 = IQ_ADDRESS'(i);
                is_control_flow_instr = (IQ[i].branch || IQ[i].jump);
                issue1_found = 1'b1;
            end
            else if (!IQ[i].available && !IQ[i].prs1_busy && !IQ[i].prs2_busy && !issue2_found && issue1_found && !is_control_flow_instr) begin
                issue_index2 = IQ_ADDRESS'(i);
                issue2_found = 1'b1;
            end
        end
        // fast wakeup logic
        fast_waked_reg1 = IQ[issue_index1].prd;
        fast_waked_reg2 = IQ[issue_index2].prd;
        fast_wakeup1    = issue1_found && !IQ[issue_index1].is_m_extension && !IQ[issue_index1].memtoreg && IQ[issue_index1].regwrite;
        fast_wakeup2    = issue2_found && !IQ[issue_index2].is_m_extension && !IQ[issue_index2].memtoreg && IQ[issue_index2].regwrite;
    end
    //pipeline of issue stage
    always_ff @(posedge CLK) begin
        if (reset) begin
            iss_valid1 <= 0;
            iss_valid2 <= 0;
        end
        else begin 
            if (issue1_found && !flush) begin
                iss_valid1         <= 1'b1; 
                iss_is_m_extension1<= IQ[issue_index1].is_m_extension;          
                iss_pc1            <= IQ[issue_index1].pc;       
                iss_prd1           <= IQ[issue_index1].prd;           
                iss_instr1_prs1    <= IQ[issue_index1].prs1;        
                iss_instr1_prs2    <= IQ[issue_index1].prs2;       
                iss_immediate1     <= IQ[issue_index1].immediate;     
                iss_alu_operation1 <= IQ[issue_index1].alu_operation;
                iss_jump_reg1      <= IQ[issue_index1].jump_reg;     
                iss_jump1          <= IQ[issue_index1].jump;         
                iss_branch1        <= IQ[issue_index1].branch;        
                iss_instr1_regsrc1 <= IQ[issue_index1].regsrc1;     
                iss_instr1_regsrc2 <= IQ[issue_index1].regsrc2;     
                iss_immtype1       <= IQ[issue_index1].immtype;       
                iss_isimm1         <= IQ[issue_index1].isimm;          
                iss_retaddr1       <= IQ[issue_index1].retaddr;      
                iss_upperimm1      <= IQ[issue_index1].upperimm;      
                iss_regwrite1      <= IQ[issue_index1].regwrite;      
                iss_memwrite1      <= IQ[issue_index1].memwrite;      
                iss_memtoreg1      <= IQ[issue_index1].memtoreg;      
                iss_branch_tag1    <= IQ[issue_index1].branch_tag;    
                iss_branch_mask1   <= IQ[issue_index1].branch_mask;   
                iss_biq_address1   <= IQ[issue_index1].biq_address;  
                iss_rob_index1     <= IQ[issue_index1].rob_index; 
            end
            else begin
                iss_valid1         <= 1'b0;
            end

            if (issue2_found && !flush) begin
                iss_valid2         <= 1'b1;     
                iss_is_m_extension2<= IQ[issue_index2].is_m_extension;                   
                iss_pc2            <= IQ[issue_index2].pc;       
                iss_prd2           <= IQ[issue_index2].prd;           
                iss_instr2_prs1    <= IQ[issue_index2].prs1;        
                iss_instr2_prs2    <= IQ[issue_index2].prs2;       
                iss_immediate2     <= IQ[issue_index2].immediate;     
                iss_alu_operation2 <= IQ[issue_index2].alu_operation;
                iss_jump_reg2      <= IQ[issue_index2].jump_reg;     
                iss_jump2          <= IQ[issue_index2].jump;         
                iss_branch2        <= IQ[issue_index2].branch;        
                iss_instr2_regsrc1 <= IQ[issue_index2].regsrc1;     
                iss_instr2_regsrc2 <= IQ[issue_index2].regsrc2;     
                iss_immtype2       <= IQ[issue_index2].immtype;       
                iss_isimm2         <= IQ[issue_index2].isimm;          
                iss_retaddr2       <= IQ[issue_index2].retaddr;      
                iss_upperimm2      <= IQ[issue_index2].upperimm;      
                iss_regwrite2      <= IQ[issue_index2].regwrite;      
                iss_memwrite2      <= IQ[issue_index2].memwrite;      
                iss_memtoreg2      <= IQ[issue_index2].memtoreg;      
                iss_branch_tag2    <= IQ[issue_index2].branch_tag;    
                iss_branch_mask2   <= IQ[issue_index2].branch_mask;   
                iss_biq_address2   <= IQ[issue_index2].biq_address; 
                iss_rob_index2     <= IQ[issue_index2].rob_index; 
            end
            else begin
                iss_valid2         <= 1'b0;
            end
        end
    end


            
endmodule
