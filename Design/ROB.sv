module ROB #(
    parameter PRF_ADDRESS = 6,
    parameter ROB_SIZE = 64,
    parameter ROB_PTR_SIZE = $clog2(ROB_SIZE)

) (
    input logic CLK, reset, stall_frontend, branch_mispredicted, rn_valid1, rn_valid2, 
    input logic cdb_done1, cdb_done2,
    input logic [4:0] rn_rd1, rn_rd2,
    input logic [PRF_ADDRESS-1:0] rn_prd1, rn_prd2,
    input logic [PRF_ADDRESS-1:0]  rn_old_prd1, rn_old_prd2,   
    input logic [ROB_PTR_SIZE-1:0] cdb_rob_index1, cdb_rob_index2, cdb_branch_rob_index,          

    output logic rob_full, commit_instr1, commit_instr2,
    output logic [ROB_PTR_SIZE-1:0] current_rob_index,
    output logic [PRF_ADDRESS-1:0] dis_free_old_prd1, dis_free_old_prd2,
    output logic [PRF_ADDRESS-1:0] comm_prd1, comm_prd2,
    output logic [4:0] comm_rd1, comm_rd2
);

    typedef struct packed {
        logic done;
        logic [4:0] rd;
        logic [PRF_ADDRESS-1:0] prd;
        logic [PRF_ADDRESS-1:0] old_prd;
    } ROB_organization;

    
    (* ram_style = "distributed" *) ROB_organization ROB [ROB_SIZE-1:0];
    logic [ROB_PTR_SIZE:0] rob_head_ptr, rob_tail_ptr;
    logic [ROB_PTR_SIZE:0] rob_count;
    logic completed1, completed2;
    logic branch_wrap_bit; //to find what should be at msb when recovery of tail pointer on misprediction

    assign branch_wrap_bit      = rob_head_ptr[ROB_PTR_SIZE] ^ (cdb_branch_rob_index < rob_head_ptr[ROB_PTR_SIZE-1:0]);
    assign rob_count            = rob_tail_ptr - rob_head_ptr; //it would never be negative cuz taking ptrsize + 1
    assign current_rob_index    = rob_tail_ptr[ROB_PTR_SIZE-1:0];
    assign rob_full             = (rob_count >= (ROB_PTR_SIZE+1)'(ROB_SIZE - 1));          
    assign completed1           = (rob_count > 0) && ROB[rob_head_ptr[ROB_PTR_SIZE-1:0]].done;
    assign completed2           = (rob_count > 1) && ROB[ROB_PTR_SIZE'(rob_head_ptr[ROB_PTR_SIZE-1:0] + ROB_PTR_SIZE'(1))].done && completed1;
    assign dis_free_old_prd1    = ROB[rob_head_ptr[ROB_PTR_SIZE-1:0]].old_prd;
    assign dis_free_old_prd2    = ROB[ROB_PTR_SIZE'(rob_head_ptr[ROB_PTR_SIZE-1:0] + ROB_PTR_SIZE'(1))].old_prd;

    assign comm_prd1            = ROB[rob_head_ptr[ROB_PTR_SIZE-1:0]].prd;
    assign comm_prd2            = ROB[ROB_PTR_SIZE'(rob_head_ptr[ROB_PTR_SIZE-1:0] + ROB_PTR_SIZE'(1))].prd;

    assign comm_rd1             = ROB[rob_head_ptr[ROB_PTR_SIZE-1:0]].rd;
    assign comm_rd2             = ROB[ROB_PTR_SIZE'(rob_head_ptr[ROB_PTR_SIZE-1:0] + ROB_PTR_SIZE'(1))].rd;

    assign commit_instr1 = completed1;
    assign commit_instr2 = completed2;

    always_ff @(posedge CLK) begin
        if (reset) begin
            rob_head_ptr <= 0;
            rob_tail_ptr <= 0;
        end
        else begin
            rob_head_ptr <= rob_head_ptr + { {(ROB_PTR_SIZE){1'b0}}, completed1 } 
                                         + { {(ROB_PTR_SIZE){1'b0}}, completed2 };
            if (branch_mispredicted) begin
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
            if(!rob_full) begin
                //for 1st instruction
                ROB[rob_tail_ptr[ROB_PTR_SIZE-1:0]].done          <= 0;
                ROB[rob_tail_ptr[ROB_PTR_SIZE-1:0]].prd           <= (rn_valid1)? rn_prd1 : rn_prd2;
                ROB[rob_tail_ptr[ROB_PTR_SIZE-1:0]].rd            <= (rn_valid1)? rn_rd1 : rn_rd2;
                ROB[rob_tail_ptr[ROB_PTR_SIZE-1:0]].old_prd       <= (rn_valid1)? rn_old_prd1 : rn_old_prd2;
                //for 2nd instruction
                ROB[ROB_PTR_SIZE'(rob_tail_ptr[ROB_PTR_SIZE-1:0] + ROB_PTR_SIZE'(1))].done        <= 0;
                ROB[ROB_PTR_SIZE'(rob_tail_ptr[ROB_PTR_SIZE-1:0] + ROB_PTR_SIZE'(1))].prd         <= rn_prd2;
                ROB[ROB_PTR_SIZE'(rob_tail_ptr[ROB_PTR_SIZE-1:0] + ROB_PTR_SIZE'(1))].rd          <= rn_rd2;
                ROB[ROB_PTR_SIZE'(rob_tail_ptr[ROB_PTR_SIZE-1:0] + ROB_PTR_SIZE'(1))].old_prd     <= rn_old_prd2;
            end
        end
    end
endmodule

