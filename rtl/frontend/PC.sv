
module PC #(
    parameter XLEN = 32,
    parameter RESET_PC = 32'h0
)(  
    input logic CLK, reset, flush, rob_global_flush, stall_frontend, if_redirect, pd_pred_taken,
    input logic [XLEN-3:0] rob_flush_pc,
    input logic [XLEN-1:0] if_redirect_target, pd_pred_target, ex_redirect_pc,
    output logic [XLEN-1:0] next_pc, //address fetched in the next cycle (also read address of BTB and PHT)
    output logic [XLEN-1:0] pc       //address of the bundle currently in prediction stage
);

    always_comb begin
        if (rob_global_flush) begin
            next_pc = {rob_flush_pc, 2'b00}; //from ROB (refetch the violated load)
        end
        else if (flush) begin
            next_pc = ex_redirect_pc; //from EX stage (actual next pc of the mispredicted branch)
        end
        else if (stall_frontend) begin
            next_pc = pc;
        end
        else if (if_redirect) begin
            next_pc = if_redirect_target; //from IF stage (jal target or RAS)
        end
        else if (pd_pred_taken) begin
            next_pc = pd_pred_target; //from BTB
        end
        else begin
            next_pc = pc + 8;
        end
    end

    always_ff @(posedge CLK) begin
        if (reset) begin
            pc <= RESET_PC;
        end
        else begin
            pc <= next_pc;
        end
    end
endmodule
