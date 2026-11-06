module FL #(
    parameter PRF_ADDRESS = 6,
    parameter NUM_PHY_REG = 1 << PRF_ADDRESS,
    parameter FL_ROWS = NUM_PHY_REG - 32,
    parameter FL_INDEX_WIDTH = $clog2(FL_ROWS),
    parameter FL_PTR_WIDTH = FL_INDEX_WIDTH + 1
) (
    input logic CLK, reset, flush, rename_en, rob_global_flush, push1, push2, pop1, pop2,
    input logic id_branch1, id_jump1, id_valid1,
    input logic [PRF_ADDRESS-1:0] comm_free_reg1, comm_free_reg2,
    input logic [FL_PTR_WIDTH-1:0] bs_head_ptr_snap,

    output logic [PRF_ADDRESS-1:0] fl_freed_reg1, fl_freed_reg2,
    output logic [FL_PTR_WIDTH-1:0] fl_head_ptr,
    output logic fl_empty
);

    logic [PRF_ADDRESS-1:0] FL [0:FL_ROWS-1];
    logic [FL_PTR_WIDTH-1:0] head, next_head, tail;
    logic valid_pop1, valid_pop2;
    logic [FL_PTR_WIDTH-1:0] registers_required;

    assign registers_required = {{(FL_PTR_WIDTH-1){1'b0}}, pop1} + {{(FL_PTR_WIDTH-1){1'b0}}, pop2};
    assign fl_empty = (tail - head) < registers_required; 
    assign fl_freed_reg1 = FL[head[FL_INDEX_WIDTH-1:0]];
    assign fl_freed_reg2 = FL[FL_INDEX_WIDTH'(head[FL_INDEX_WIDTH-1:0] + FL_INDEX_WIDTH'(1))];

    
    assign valid_pop1 = pop1 && rename_en;
    assign valid_pop2 = pop2 && rename_en;

    always_comb begin
        //during flush, we fetch instruction from correct path, so we dont pop register in this cycle
        next_head = (flush) ? bs_head_ptr_snap : (head + FL_PTR_WIDTH'(valid_pop1) + FL_PTR_WIDTH'(valid_pop2));

        if ((id_branch1 || id_jump1) && id_valid1) begin
            fl_head_ptr = head + FL_PTR_WIDTH'(valid_pop1); 
        end else begin
            fl_head_ptr = next_head; // Same as head + valid_pop1 + valid_pop2
        end
    end

    // Recovery from a memory violation flush (everything which is not committed is dropped):
    // the registers of the instructions in flight are still in the queue, in program order, between the
    // head of the committed state and the head. A committing instruction with a destination register owns
    // the oldest of them (and frees its old register at the tail), so that head just follows the commits.
    logic [FL_PTR_WIDTH-1:0] committed_head, next_committed_head;
    assign next_committed_head = committed_head + FL_PTR_WIDTH'(push1) + FL_PTR_WIDTH'(push2);

    always_ff @(posedge CLK) begin
        if (reset) begin
            for (int i = 32; i < NUM_PHY_REG; i++) begin
                FL[i-32] <= PRF_ADDRESS'(i);
            end
            head <= '0;
            committed_head <= '0;
            tail <= {1'b1, {FL_INDEX_WIDTH{1'b0}}}; 
        end
        else begin
            committed_head <= next_committed_head;
            head <= (rob_global_flush) ? next_committed_head : next_head;
            //from the commit stage we push registers back to free list
            if (push1 && push2) begin
                FL[tail[FL_INDEX_WIDTH-1:0]] <= comm_free_reg1;
                FL[FL_INDEX_WIDTH'(tail[FL_INDEX_WIDTH-1:0] + FL_INDEX_WIDTH'(1))] <= comm_free_reg2;
                tail <= tail + 2;
            end
            else if (push1 || push2) begin
                FL[tail[FL_INDEX_WIDTH-1:0]] <= (push1)? comm_free_reg1 : comm_free_reg2;
                tail <= tail + 1;
            end
        end
    end

endmodule 