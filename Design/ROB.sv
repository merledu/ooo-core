module ROB #(
    parameter XLEN = 32,             
    parameter PRF_ADDRESS = 6,
    parameter ROB_SIZE = 64,
    parameter ROB_PTR_SIZE = $clog2(ROB_SIZE)
) (
    input logic CLK, reset, stall_frontend, flush, rn_valid1, rn_valid2, 
    input logic cdb_done1, cdb_done2,
    input logic [4:0] rn_rd1, rn_rd2,
    input logic [PRF_ADDRESS-1:0] rn_prd1, rn_prd2,
    input logic [PRF_ADDRESS-1:0] rn_old_prd1, rn_old_prd2,   
    input logic [ROB_PTR_SIZE-1:0] cdb_rob_index1, cdb_rob_index2, cdb_branch_rob_index,          
    input logic rn_is_load1, rn_is_load2,
    input logic rn_is_store1, rn_is_store2, 
    input logic [XLEN-3:0] rn_pc1, rn_pc2, 
    input logic load1_violation_flush, 
    input logic load2_violation_flush,

    output logic rob_full, commit_instr1, commit_instr2,
    output logic [ROB_PTR_SIZE:0] current_rob_index,
    output logic [PRF_ADDRESS-1:0] dis_free_old_prd1, dis_free_old_prd2,
    output logic [PRF_ADDRESS-1:0] comm_prd1, comm_prd2,
    output logic [4:0] comm_rd1, comm_rd2,
    output logic rob_global_flush,
    output logic [XLEN-3:0] rob_flush_pc,
    output logic commit_is_load1, commit_is_load2,
    output logic commit_is_store1, commit_is_store2 
);

    typedef struct packed {
        logic done;
        logic is_load;           
        logic is_store;          
        logic [XLEN-3:0] pc;     
        logic [4:0] rd;
        logic [PRF_ADDRESS-1:0] prd;
        logic [PRF_ADDRESS-1:0] old_prd;
    } ROB_organization;

    (* ram_style = "distributed" *) ROB_organization ROB [ROB_SIZE-1:0];
    logic [ROB_PTR_SIZE:0] rob_head_ptr, rob_tail_ptr;
    logic [ROB_PTR_SIZE:0] rob_count;
    logic completed1, completed2;
    logic branch_wrap_bit;

    logic [ROB_PTR_SIZE-1:0] head_idx, head_plus_1_idx;
    assign head_idx = rob_head_ptr[ROB_PTR_SIZE-1:0];
    assign head_plus_1_idx = ROB_PTR_SIZE'(rob_head_ptr[ROB_PTR_SIZE-1:0] + ROB_PTR_SIZE'(1));

    assign branch_wrap_bit      = rob_head_ptr[ROB_PTR_SIZE] ^ (cdb_branch_rob_index < rob_head_ptr[ROB_PTR_SIZE-1:0]);
    assign rob_count            = rob_tail_ptr - rob_head_ptr; 
    assign current_rob_index    = rob_tail_ptr;
    assign rob_full             = (rob_count >= (ROB_PTR_SIZE+1)'(ROB_SIZE - 1));          

    logic slot1_is_load, slot2_is_load;
    logic slot1_is_store, slot2_is_store; 
    logic slot2_poisoned;

    assign slot1_is_load = ROB[head_idx].is_load;
    assign slot2_is_load = ROB[head_plus_1_idx].is_load;
    assign slot1_is_store = ROB[head_idx].is_store; 
    assign slot2_is_store = ROB[head_plus_1_idx].is_store; 

    always_comb begin
        completed1 = 1'b0;
        completed2 = 1'b0;
        rob_global_flush = 1'b0;
        rob_flush_pc = '0; 
        slot2_poisoned = 1'b0;

        if ((rob_count > 0) && ROB[head_idx].done) begin
            if (slot1_is_load && load1_violation_flush) begin
                rob_global_flush = 1'b1;
                rob_flush_pc = ROB[head_idx].pc; 
            end 
            else begin
                completed1 = 1'b1;
                
                if ((rob_count > 1) && ROB[head_plus_1_idx].done) begin
                    
                    
                    if (slot2_is_load) begin
                        if (slot1_is_load) begin
                            slot2_poisoned = load2_violation_flush;
                        end else begin
                            slot2_poisoned = load1_violation_flush;
                        end
                    end
                    if (!slot2_poisoned) begin
                        completed2 = 1'b1;
                    end
                end
            end
        end
    end
    
    assign commit_instr1 = completed1;
    assign commit_instr2 = completed2;
    assign commit_is_load1  = completed1 && slot1_is_load;
    assign commit_is_load2  = completed2 && slot2_is_load;    
    
    assign commit_is_store1 = completed1 && slot1_is_store; 
    assign commit_is_store2 = completed2 && slot2_is_store; 
    
    assign dis_free_old_prd1    = ROB[head_idx].old_prd;
    assign dis_free_old_prd2    = ROB[head_plus_1_idx].old_prd;
    assign comm_prd1            = ROB[head_idx].prd;
    assign comm_prd2            = ROB[head_plus_1_idx].prd;
    assign comm_rd1             = ROB[head_idx].rd;
    assign comm_rd2             = ROB[head_plus_1_idx].rd;

    always_ff @(posedge CLK) begin
        if (reset) begin
            rob_head_ptr <= 0;
            rob_tail_ptr <= 0;
        end
        else begin
            rob_head_ptr <= rob_head_ptr + { {(ROB_PTR_SIZE){1'b0}}, completed1 } 
                                         + { {(ROB_PTR_SIZE){1'b0}}, completed2 };
                                         
            if (rob_global_flush) begin
                rob_tail_ptr <= rob_head_ptr; 
            end
            else if (flush) begin
                rob_tail_ptr <= {branch_wrap_bit, cdb_branch_rob_index} + ROB_PTR_SIZE'(1);
            end
            else if(!stall_frontend) begin
                rob_tail_ptr <= rob_tail_ptr + { {(ROB_PTR_SIZE){1'b0}}, rn_valid1 } 
                                             + { {(ROB_PTR_SIZE){1'b0}}, rn_valid2 };
            end
            
            if (cdb_done1) begin
                ROB[cdb_rob_index1].done <= 1;
            end
            if (cdb_done2) begin
                ROB[cdb_rob_index2].done <= 1;
            end
            
            if(!rob_full && !stall_frontend) begin
                ROB[rob_tail_ptr[ROB_PTR_SIZE-1:0]].done          <= 0;
                ROB[rob_tail_ptr[ROB_PTR_SIZE-1:0]].prd           <= (rn_valid1)? rn_prd1 : rn_prd2;
                ROB[rob_tail_ptr[ROB_PTR_SIZE-1:0]].rd            <= (rn_valid1)? rn_rd1 : rn_rd2;
                ROB[rob_tail_ptr[ROB_PTR_SIZE-1:0]].old_prd       <= (rn_valid1)? rn_old_prd1 : rn_old_prd2;
                ROB[rob_tail_ptr[ROB_PTR_SIZE-1:0]].is_load       <= (rn_valid1)? rn_is_load1 : rn_is_load2;
                ROB[rob_tail_ptr[ROB_PTR_SIZE-1:0]].is_store      <= (rn_valid1)? rn_is_store1 : rn_is_store2; 
                ROB[rob_tail_ptr[ROB_PTR_SIZE-1:0]].pc            <= (rn_valid1)? rn_pc1 : rn_pc2;
                
                ROB[ROB_PTR_SIZE'(rob_tail_ptr[ROB_PTR_SIZE-1:0] + ROB_PTR_SIZE'(1))].done        <= 0;
                ROB[ROB_PTR_SIZE'(rob_tail_ptr[ROB_PTR_SIZE-1:0] + ROB_PTR_SIZE'(1))].prd         <= rn_prd2;
                ROB[ROB_PTR_SIZE'(rob_tail_ptr[ROB_PTR_SIZE-1:0] + ROB_PTR_SIZE'(1))].rd          <= rn_rd2;
                ROB[ROB_PTR_SIZE'(rob_tail_ptr[ROB_PTR_SIZE-1:0] + ROB_PTR_SIZE'(1))].old_prd     <= rn_old_prd2;
                ROB[ROB_PTR_SIZE'(rob_tail_ptr[ROB_PTR_SIZE-1:0] + ROB_PTR_SIZE'(1))].is_load     <= rn_is_load2;
                ROB[ROB_PTR_SIZE'(rob_tail_ptr[ROB_PTR_SIZE-1:0] + ROB_PTR_SIZE'(1))].is_store    <= rn_is_store2; 
                ROB[ROB_PTR_SIZE'(rob_tail_ptr[ROB_PTR_SIZE-1:0] + ROB_PTR_SIZE'(1))].pc          <= rn_pc2;
            end
        end
    end
endmodule