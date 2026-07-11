module GHR #(
    parameter GHR_SIZE = 9
)(
    input logic CLK, reset, stall_frontend, restore_ghr, ex_actual_taken, ex_is_branch,
    input logic [GHR_SIZE-1:0] ghr_snap,
    output logic [GHR_SIZE-1:0] ghr_out, prev_ghr
);
    logic pred_taken;
    assign prev_ghr = ghr_out;

    always_ff @(posedge CLK) begin
        if (reset) begin
            ghr_out <= '0;
        end
        else if (restore_ghr) begin
            ghr_out <= {ghr_snap[GHR_SIZE-2:0], ex_actual_taken};
        end
        else if (!stall_frontend && ex_is_branch) begin
            ghr_out <= {ghr_out[GHR_SIZE-2:0], ex_actual_taken};
        end
    end     
endmodule