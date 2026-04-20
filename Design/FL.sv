module FL #(
    parameter PRF_ADDRESS = 6,
    parameter FL_ROWS = (1 << PRF_ADDRESS) - 32,
    parameter FL_INDEX_WIDTH = $clog2(FL_ROWS),
    parameter FL_PTR_WIDTH = FL_INDEX_WIDTH + 1
) (
    input logic CLK, flush, reset, push1, push2, pop, 
    input logic [PRF_ADDRESS-1:0] comm_free_reg1, comm_free_reg2,
    input logic [FL_PTR_WIDTH-1:0] bs_head_ptr_snap,
    output logic [PRF_ADDRESS-1:0] fl_freed_reg1, fl_freed_reg2,
    output logic [FL_PTR_WIDTH-1:0] fl_head_ptr,
    output logic stall_frontend
);
    logic [PRF_ADDRESS-1:0] FL [0:FL_ROWS-1];
    logic [FL_PTR_WIDTH-1:0] head, tail;
    assign stall_frontend = (head == tail);

    assign fl_head_ptr = head;
    assign fl_freed_reg1 = FL[head[FL_INDEX_WIDTH-1:0]];
    assign fl_freed_reg2 = FL[FL_INDEX_WIDTH'(head[FL_INDEX_WIDTH-1:0]+1)];

    always_ff @(posedge CLK) begin
        if (reset) begin
            for (int i = 32; i < (1 << PRF_ADDRESS); i++) begin
                FL[i-32] <= i;
            end
            head <= '0; // ALL ZEROS
            tail <= {1'b1, {FL_INDEX_WIDTH{1'b0}}}; // IS FULL (BACK TO HEAD)
        end
        else begin
            //during flush, we fetch instruction from correct path, so we dont pop register in this cycle
            if (flush) begin
                head <= bs_head_ptr_snap;
            end
            else if (pop) begin
                head <= head + 2;
            end
            //from the commit stage we push registers back to free list
            if (push1 && push2) begin
                FL[tail[FL_INDEX_WIDTH-1:0]] <= comm_free_reg1;
                FL[FL_INDEX_WIDTH'(tail[FL_INDEX_WIDTH-1:0]+1)] <= comm_free_reg2;
                tail <= tail + 2;
            end
            else if (push1 || push2) begin
                FL[tail[FL_INDEX_WIDTH-1:0]] <= (push1)? comm_free_reg1 : comm_free_reg2;
                tail <= tail + 1;
            end

            
        end
    end

endmodule 