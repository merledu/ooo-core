// 3-Stage Decoupled Radix-4 Divider with Early Wakeup & Branch Flush
module DIV_Unit #(
    parameter XLEN = 32,
    parameter PRF_ADDRESS = 6,
    parameter ROB_PTR_SIZE = 6,
    parameter MAX_BRANCHES = 4,                                
    parameter BTAG_SIZE = $clog2(MAX_BRANCHES)                
) (
    input  logic CLK, reset, flush, valid,                     
    input  logic [BTAG_SIZE-1:0] cdb_branch_tag,               
    input  logic [MAX_BRANCHES-1:0] rr_branch_mask,            
    input  logic cdb_branch_resolved,                          
    input  logic cdb_branch_correct,                          
    
    input  logic [XLEN-1:0] rs1_data, //dividend
    input  logic [XLEN-1:0] rs2_data, //divisor
    input  logic [4:0] alu_operation, 
    input  logic [PRF_ADDRESS-1:0]  rr_prd,
    input  logic [ROB_PTR_SIZE-1:0] rr_rob_index,

    output logic cdb_div_busy,     
    output logic cdb_write_data, 
    output logic [XLEN-1:0] cdb_alu_result,
    output logic [PRF_ADDRESS-1:0]  cdb_prd,
    output logic [ROB_PTR_SIZE-1:0] cdb_rob_index
);

    // Stage 1: Math Engine (FSM Definitions)
    typedef enum logic [1:0] {
        IDLE    = 2'b00,
        PREP    = 2'b01,
        DIVIDE  = 2'b10
    } div_state_t;
    
    div_state_t state;

    // FSM Internal Math Registers
    logic [31:0] Q_reg, R_reg;
    logic [33:0] D_1x, D_2x, D_3x; 
    logic [4:0]  iterations;
    
    // FSM Internal Metadata Registers
    logic [PRF_ADDRESS-1:0]  saved_prd;
    logic [ROB_PTR_SIZE-1:0] saved_rob_index;
    logic [MAX_BRANCHES-1:0] saved_branch_mask;              
    logic div_by_zero_reg, overflow_reg, is_rem_reg;
    logic out_sign_q_reg, out_sign_r_reg;

    // Stage 2: The "Holding Pen" (Output Pipeline Registers)
    logic [31:0] Out_Q_reg, Out_R_reg;
    logic [PRF_ADDRESS-1:0]  Out_prd_reg;
    logic [ROB_PTR_SIZE-1:0] Out_rob_index_reg;
    
    logic Out_sign_q, Out_sign_r, Out_is_rem;
    logic Out_div_by_zero, Out_overflow;
    logic Out_valid_reg;

    // Combinational Logic: Input Extraction & Radix-4 Math
    logic is_signed, in_is_rem;
    
    assign is_signed = ~alu_operation[0]; // 0 = Signed (DIV/REM), 1 = Unsigned (DIVU/REMU)
    assign in_is_rem = alu_operation[1];  // 0 = Quotient (DIV), 1 = Remainder (REM)

    logic in_sign_dividend, in_sign_divisor;
    assign in_sign_dividend = is_signed && rs1_data[31];
    assign in_sign_divisor  = is_signed && rs2_data[31];
    
    // Extract absolute values
    logic [31:0] in_abs_dividend, in_abs_divisor;
    assign in_abs_dividend = in_sign_dividend ? -rs1_data : rs1_data;
    assign in_abs_divisor  = in_sign_divisor  ? -rs2_data  : rs2_data;

    // Calculate edge Cases and final signs immediately
    logic in_div_by_zero, in_overflow, in_out_sign_q, in_out_sign_r;
    assign in_div_by_zero = (rs2_data == 32'b0);
    assign in_overflow    = is_signed && (rs1_data == 32'h80000000) && (rs2_data == 32'hFFFFFFFF);
    assign in_out_sign_q  = in_sign_dividend ^ in_sign_divisor;
    assign in_out_sign_r  = in_sign_dividend;

    // Radix-4 Math Engine
    logic [33:0] shift_R;
    logic [31:0] next_R, next_Q;
    
    assign shift_R = {R_reg[31:0], Q_reg[31:30]};

    always_comb begin
        if (shift_R >= D_3x) begin
            next_R = shift_R - D_3x;
            next_Q = {Q_reg[29:0], 2'b11};
        end 
        else if (shift_R >= D_2x) begin
            next_R = shift_R - D_2x;
            next_Q = {Q_reg[29:0], 2'b10};
        end 
        else if (shift_R >= D_1x) begin
            next_R = shift_R - D_1x;
            next_Q = {Q_reg[29:0], 2'b01};
        end 
        else begin
            next_R = shift_R[31:0];
            next_Q = {Q_reg[29:0], 2'b00};
        end
    end

    // Sequential Logic: The FSM & Pipeline Latch
    always_ff @(posedge CLK) begin
        if (reset) begin
            state <= IDLE;
            cdb_div_busy <= 1'b0;
            Out_valid_reg <= 1'b0;
        end
        // ADDED FLUSH LOGIC
        // If a flush occurs AND this specific instruction is masked by the mispredicted branch
        else if (flush && state != IDLE && saved_branch_mask[cdb_branch_tag]) begin
            state <= IDLE;
            cdb_div_busy <= 1'b0; // Immediately free the unit for the Issue Queue
            Out_valid_reg <= 1'b0;
        end
        else begin
            Out_valid_reg <= 1'b0; 
            
            // ADDED MASK CLEAR LOGIC
            // If a branch resolves correctly, clear its bit in the mask so we don't accidentally 
            // flush this instruction if the tag gets recycled before the division finishes.
            if (cdb_branch_resolved && cdb_branch_correct && state != IDLE) begin
                saved_branch_mask[cdb_branch_tag] <= 1'b0;
            end

            case (state)
                IDLE: begin
                    if (valid) begin
                        state <= PREP;
                        cdb_div_busy <= 1'b1;    
                        saved_prd         <= rr_prd;
                        saved_rob_index   <= rr_rob_index;
                        saved_branch_mask <= rr_branch_mask;   
                        out_sign_q_reg    <= in_out_sign_q;
                        out_sign_r_reg    <= in_out_sign_r;
                        is_rem_reg        <= in_is_rem;
                        div_by_zero_reg   <= in_div_by_zero;
                        overflow_reg      <= in_overflow;
                        Q_reg <= in_abs_dividend;
                        D_1x  <= {2'b00, in_abs_divisor};
                        R_reg <= 32'b0;
                    end
                end
                
                PREP: begin
                    D_2x <= D_1x << 1;
                    D_3x <= D_1x + (D_1x << 1);
                    iterations <= 5'd15; // 16 Iterations (0 to 15)
                    
                    if (div_by_zero_reg || overflow_reg) begin
                        // EDGE CASE: Skip DIVIDE loop. Dump straight to Holding Pen.
                        Out_Q_reg <= Q_reg; // Holds absolute dividend
                        Out_R_reg <= 32'b0;
                        Out_prd_reg <= saved_prd;
                        Out_rob_index_reg <= saved_rob_index;
                        Out_sign_q <= out_sign_q_reg;
                        Out_sign_r <= out_sign_r_reg;
                        Out_is_rem <= is_rem_reg;
                        Out_div_by_zero <= div_by_zero_reg;
                        Out_overflow <= overflow_reg;
                        
                        Out_valid_reg <= 1'b1;
                        
                        // Fast Wakeup Catch
                        if (valid) begin
                            saved_prd         <= rr_prd;
                            saved_rob_index   <= rr_rob_index;
                            saved_branch_mask <= rr_branch_mask; 
                            out_sign_q_reg    <= in_out_sign_q;
                            out_sign_r_reg    <= in_out_sign_r;
                            is_rem_reg        <= in_is_rem;
                            div_by_zero_reg   <= in_div_by_zero;
                            overflow_reg      <= in_overflow;
                            Q_reg             <= in_abs_dividend;
                            D_1x              <= {2'b00, in_abs_divisor};
                            R_reg             <= 32'b0;
                        end else begin
                            cdb_div_busy <= 1'b0;
                            state <= IDLE;
                        end
                    end 
                    else begin
                        state <= DIVIDE;
                    end
                end
                
                DIVIDE: begin
                    if (iterations == 0) begin
                        // MATHEMATICS FINISHED: Dump computed answers into the Holding Pen
                        Out_Q_reg <= next_Q;
                        Out_R_reg <= next_R;
                        Out_prd_reg <= saved_prd;
                        Out_rob_index_reg <= saved_rob_index;
                        Out_sign_q <= out_sign_q_reg;
                        Out_sign_r <= out_sign_r_reg;
                        Out_is_rem <= is_rem_reg;
                        Out_div_by_zero <= div_by_zero_reg;
                        Out_overflow <= overflow_reg;
                        
                        Out_valid_reg <= 1'b1; 

                        // Fast Wakeup Catch
                        if (valid) begin
                            state <= PREP;
                            cdb_div_busy <= 1'b1; 
                            
                            saved_prd         <= rr_prd;
                            saved_rob_index   <= rr_rob_index;
                            saved_branch_mask <= rr_branch_mask;  
                            out_sign_q_reg    <= in_out_sign_q;
                            out_sign_r_reg    <= in_out_sign_r;
                            is_rem_reg        <= in_is_rem;
                            div_by_zero_reg   <= in_div_by_zero;
                            overflow_reg      <= in_overflow;
                            Q_reg             <= in_abs_dividend;
                            D_1x              <= {2'b00, in_abs_divisor};
                            R_reg             <= 32'b0;
                        end else begin
                            state <= IDLE;
                        end
                    end 
                    else begin
                        // Math continues spinning
                        R_reg <= next_R;
                        Q_reg <= next_Q;
                        iterations <= iterations - 1;
                        
                        // EARLY WAKEUP TRIGGER 
                        if (iterations == 1) cdb_div_busy <= 1'b0; 
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end

    // Stage 3: Combinational Formatting (Two's Complement) & CDB Write
    assign cdb_write_data = Out_valid_reg;
    assign cdb_prd        = Out_prd_reg;
    assign cdb_rob_index  = Out_rob_index_reg;

    always_comb begin
        if (Out_div_by_zero) begin
            // HAZARD FIX: Reconstruct original dividend from Out_Q_reg to prevent cross-instruction corruption
            cdb_alu_result = Out_is_rem ? (Out_sign_r ? -Out_Q_reg : Out_Q_reg) : 32'hFFFFFFFF; 
        end 
        else if (Out_overflow) begin
            cdb_alu_result = Out_is_rem ? 32'b0 : 32'h80000000;      
        end 
        else begin
            if (Out_is_rem) begin
                cdb_alu_result = Out_sign_r ? -Out_R_reg : Out_R_reg;
            end else begin
                cdb_alu_result = Out_sign_q ? -Out_Q_reg : Out_Q_reg;
            end
        end
    end

endmodule
