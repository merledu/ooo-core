module GHR #(
    parameter GHR_SIZE = 9
)(
    input logic CLK, reset, restore_ghr, ex_actual_taken, ex_is_branch,
    input logic spec_update, spec_taken,
    input logic [GHR_SIZE-1:0] ghr_snap,
    output logic [GHR_SIZE-1:0] ghr_out, prev_ghr
);
    assign prev_ghr = ghr_out;

    always_ff @(posedge CLK) begin
        if (reset) begin
            ghr_out <= '0;
        end
        //misprediction: go back to the history the branch was predicted with and insert the actual outcome
        else if (restore_ghr) begin
            ghr_out <= (ex_is_branch) ? {ghr_snap[GHR_SIZE-2:0], ex_actual_taken} : ghr_snap;
        end
        //speculative update with the predicted direction of a conditional branch
        else if (spec_update) begin
            ghr_out <= {ghr_out[GHR_SIZE-2:0], spec_taken};
        end
    end     
endmodule
