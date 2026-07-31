module FL #(
    parameter PRF_ADDRESS = 6,
    parameter NUM_PHY_REG = 1 << PRF_ADDRESS,
    parameter FL_ROWS = NUM_PHY_REG - 32,
    parameter FL_INDEX_WIDTH = $clog2(FL_ROWS),
    parameter FL_PTR_WIDTH = FL_INDEX_WIDTH + 1
) (
    input logic CLK, reset, flush, stall_frontend, rob_global_flush, push1, push2, pop1, pop2,
    input logic id_branch1, id_jump1, id_valid1,
    input logic [PRF_ADDRESS-1:0] comm_free_reg1, comm_free_reg2,
    input logic [FL_PTR_WIDTH-1:0] bs_head_ptr_snap,
    input logic [31:0][PRF_ADDRESS-1:0] amt_state,

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

    
    assign valid_pop1 = pop1 && !stall_frontend && !flush;
    assign valid_pop2 = pop2 && !stall_frontend && !flush;

    always_comb begin
        //during flush, we fetch instruction from correct path, so we dont pop register in this cycle
        next_head = (flush) ? bs_head_ptr_snap : (head + FL_PTR_WIDTH'(valid_pop1) + FL_PTR_WIDTH'(valid_pop2));

        if ((id_branch1 || id_jump1) && id_valid1) begin
            fl_head_ptr = head + FL_PTR_WIDTH'(valid_pop1); 
        end else begin
            fl_head_ptr = next_head; // Same as head + valid_pop1 + valid_pop2
        end
    end

    // which physical registers are currently in the AMT
    logic [NUM_PHY_REG-1:0] is_in_amt;
    always_comb begin
        is_in_amt = '0;
        for (int i = 0; i < 32; i++) begin
            is_in_amt[amt_state[i]] = 1'b1;
        end
    end

    always_ff @(posedge CLK) begin
        if (reset) begin
            for (int i = 32; i < NUM_PHY_REG; i++) begin
                FL[i-32] <= PRF_ADDRESS'(i);
            end
            head <= '0;
            tail <= {1'b1, {FL_INDEX_WIDTH{1'b0}}}; 
        end
        else if (rob_global_flush) begin
            // rebuild the Free List by collecting all PRFs in the AMT
            logic [FL_PTR_WIDTH-1:0] temp_tail;
            temp_tail = '0;
            
            for (int i = 1; i < NUM_PHY_REG; i++) begin // Start at 1 (p0 is hardwired 0)
                if (!is_in_amt[i]) begin
                    FL[temp_tail[FL_INDEX_WIDTH-1:0]] <= PRF_ADDRESS'(i);
                    temp_tail = temp_tail + FL_PTR_WIDTH'(1);
                end
            end
            
            head <= '0;
            tail <= temp_tail; 
        end
        else begin
            head <= next_head;
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