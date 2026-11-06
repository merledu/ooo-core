module CM_Stage #(
    parameter XLEN = 32,
    parameter PRF_ADDRESS = 6
) (
    input  logic CLK, 
    input  logic reset,
    
    // Commit Signals from ROB
    input  logic commit_instr1, commit_instr2,
    input  logic [4:0] comm_rd1, comm_rd2,
    input  logic [PRF_ADDRESS-1:0] comm_prd1, comm_prd2,
    input  logic [PRF_ADDRESS-1:0] dis_free_old_prd1, dis_free_old_prd2,

    // Free List Push Signals (To RN_Stage)
    output logic comm_free_push1, comm_free_push2,
    output logic [PRF_ADDRESS-1:0] comm_free_reg1, comm_free_reg2,

    // Architectural Map Table State for Recovery (To RN_Stage)
    output logic [31:0][PRF_ADDRESS-1:0] amt_state
);

    logic [PRF_ADDRESS-1:0] AMT [0:31];

    always_comb begin
        for (int i = 0; i < 32; i++) begin
            amt_state[i] = AMT[i];
        end

        // Only free the old register if we are actually writing to a valid architectural register (not x0)
        comm_free_push1 = commit_instr1 && (comm_rd1 != 5'd0);
        comm_free_reg1  = dis_free_old_prd1;

        comm_free_push2 = commit_instr2 && (comm_rd2 != 5'd0);
        comm_free_reg2  = dis_free_old_prd2;
    end

    always_ff @(posedge CLK) begin
        if (reset) begin
            for (int i = 0; i < 32; i++) begin
                AMT[i] <= PRF_ADDRESS'(i);
            end
        end 
        else begin
            if (commit_instr1 && comm_rd1 != 5'd0) begin
                AMT[comm_rd1] <= comm_prd1;
            end
            if (commit_instr2 && comm_rd2 != 5'd0) begin
                AMT[comm_rd2] <= comm_prd2;
            end
        end
    end
endmodule