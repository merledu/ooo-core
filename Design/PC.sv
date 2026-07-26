
module PC #(
    parameter XLEN = 32    
)(  
    input logic CLK, reset, flush, rob_global_flush, stall_frontend, is_return_instr, btb_hit, 
    input logic pht_pred_taken, btb_is_branch,
    input logic [XLEN-3:0] rob_flush_pc,
    input logic [XLEN-1:0] ras_target_address, btb_target_address, ex_actual_target_address,
    output logic [XLEN-1:0] next_pc
);

    always_ff @(posedge CLK) begin
        if (reset) begin
            next_pc <= -8;
        end
        else if (rob_global_flush) begin
            next_pc <= {rob_flush_pc,2'b00};
        end
        else if (flush) begin
            next_pc <= ex_actual_target_address; //from EX stage(actual target address)
        end
        else if (is_return_instr) begin
            next_pc <= ras_target_address; //from RAS
        end
        else if (btb_hit && (pht_pred_taken || ~btb_is_branch)) begin
            next_pc <= btb_target_address; //from BTB
        end
        else if (!stall_frontend) begin
            next_pc <= next_pc + 8;
        end
        
    end
endmodule
