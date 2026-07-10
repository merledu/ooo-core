// 3-Stage Decoupled Radix-4 Booth Multiplier with Branch Flush
module MUL_Unit #(
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
    
    input  logic [XLEN-1:0] rs1_data,      // Multiplicand
    input  logic [XLEN-1:0] rs2_data,      // Multiplier
    input  logic [4:0] alu_operation,      // Uses lower 2 bits for MUL type
    input  logic [PRF_ADDRESS-1:0]  rr_prd,
    input  logic [ROB_PTR_SIZE-1:0] rr_rob_index,

    output logic cdb_mul_busy,     
    output logic cdb_write_data, 
    output logic [XLEN-1:0] cdb_alu_result,
    output logic [PRF_ADDRESS-1:0]  cdb_prd,
    output logic [ROB_PTR_SIZE-1:0] cdb_rob_index
);

    typedef enum logic [1:0] {
        IDLE     = 2'b00,
        PREP     = 2'b01,
        MULTIPLY = 2'b10
    } mul_state_t;
    
    mul_state_t state;

    // FSM Internal Math Registers
    logic [33:0] A_reg;       // Accumulator (Upper half of product)
    logic [33:0] Q_reg;       // Multiplier (Lower half of product)
    logic [34:0] M_reg;       // Multiplicand (Padded for safe shifting)
    logic Q_minus_1;          // Implicit Booth bit
    logic [4:0] iterations;
    
    // FSM Internal Metadata Registers
    logic [PRF_ADDRESS-1:0]  saved_prd;
    logic [ROB_PTR_SIZE-1:0] saved_rob_index;
    logic [MAX_BRANCHES-1:0] saved_branch_mask;
    logic [1:0] saved_alu_op; // Remembers if it's MUL, MULH, MULHSU, or MULHU

    // Stage 2: The "Holding Pen" (Output Pipeline Registers)
    logic [31:0] Out_A_reg;
    logic [31:0] Out_Q_reg;
    logic [1:0]  Out_alu_op;
    logic [PRF_ADDRESS-1:0]  Out_prd_reg;
    logic [ROB_PTR_SIZE-1:0] Out_rob_index_reg;
    logic Out_valid_reg;

    // Combinational Logic: RV32 Sign Extension Extraction
    // RV32M Opcodes: 
    // 00 = MUL (signed x signed)
    // 01 = MULH (signed x signed)
    // 10 = MULHSU (signed x unsigned)
    // 11 = MULHU (unsigned x unsigned)
    
    logic is_rs1_signed, is_rs2_signed;
    assign is_rs1_signed = (alu_operation[1:0] != 2'b11); 
    assign is_rs2_signed = (alu_operation[1:0] == 2'b00 || alu_operation[1:0] == 2'b01);

    // Extend inputs to 33 bits to handle unsigned logic cleanly in 2's complement
    logic [32:0] multiplicand_ext, multiplier_ext;
    assign multiplicand_ext = {(rs1_data[31] & is_rs1_signed), rs1_data};
    assign multiplier_ext   = {(rs2_data[31] & is_rs2_signed), rs2_data};

    // Pad to 34 bits to guarantee an even number of Radix-4 shifts
    logic [33:0] init_M, init_Q;
    assign init_M = {multiplicand_ext[32], multiplicand_ext};
    assign init_Q = {multiplier_ext[32], multiplier_ext};

    // Radix-4 Booth Math Engine
    logic [2:0] booth_sel;
    assign booth_sel = {Q_reg[1:0], Q_minus_1};

    // Determine the partial product based on the Booth window
    logic [34:0] partial_product;
    always_comb begin
        case(booth_sel)
            3'b001, 3'b010: partial_product = {M_reg[33], M_reg};                  // +1 * M
            3'b011:         partial_product = {M_reg, 1'b0};                       // +2 * M
            3'b100:         partial_product = -{M_reg, 1'b0};                      // -2 * M
            3'b101, 3'b110: partial_product = -{M_reg[33], M_reg};                 // -1 * M
            default:        partial_product = 35'b0;                               // 0
        endcase
    end

    // Add partial product to the Accumulator
    logic [34:0] next_A;
    assign next_A = {A_reg[33], A_reg} + partial_product;

    // Shift everything right by 2 (Arithmetic Shift)
    logic [33:0] A_next_state;
    logic [33:0] Q_next_state;
    logic Q_m1_next_state;

    assign A_next_state = {next_A[34], next_A[34], next_A[34:2]}; // Sign extend top 2 bits
    assign Q_next_state = {next_A[1:0], Q_reg[33:2]};             // A's bottom bits slide into Q
    assign Q_m1_next_state = Q_reg[1];                            // Q's bit slides into the Booth tracker

    // Sequential Logic: FSM & Pipeline Latch
    always_ff @(posedge CLK) begin
        if (reset) begin
            state <= IDLE;
            cdb_mul_busy <= 1'b0;
            Out_valid_reg <= 1'b0;
        end
        //  TAG FLUSH COLLISION LOGIC 
        else if (flush && state != IDLE && saved_branch_mask[cdb_branch_tag]) begin
            state <= IDLE;
            cdb_mul_busy <= 1'b0; 
            Out_valid_reg <= 1'b0;
        end
        else begin
            Out_valid_reg <= 1'b0; 
            
            //  DYNAMIC TAG ERASER 
            if (cdb_branch_resolved && cdb_branch_correct && state != IDLE) begin
                saved_branch_mask[cdb_branch_tag] <= 1'b0;
            end

            case (state)
                IDLE: begin
                    if (valid) begin
                        state <= PREP;
                        cdb_mul_busy <= 1'b1;    
                        
                        // Latch Metadata
                        saved_prd         <= rr_prd;
                        saved_rob_index   <= rr_rob_index;
                        saved_branch_mask <= rr_branch_mask;   
                        saved_alu_op      <= alu_operation[1:0];
                        
                        // Initialize Booth Registers
                        M_reg      <= {init_M[33], init_M}; // 35-bit sign extension for addition safety
                        A_reg      <= 34'b0;
                        Q_reg      <= init_Q;
                        Q_minus_1  <= 1'b0;
                    end
                end
                
                PREP: begin
                    state <= MULTIPLY;
                    iterations <= 5'd16; // 17 iterations total (16 down to 0)
                    
                    A_reg     <= A_next_state;
                    Q_reg     <= Q_next_state;
                    Q_minus_1 <= Q_m1_next_state;
                end
                
                MULTIPLY: begin
                    if (iterations == 0) begin
                        // MATHEMATICS FINISHED: Dump to Holding Pen
                        Out_A_reg <= A_next_state[31:0];
                        Out_Q_reg <= Q_next_state[31:0];
                        
                        Out_prd_reg <= saved_prd;
                        Out_rob_index_reg <= saved_rob_index;
                        Out_alu_op <= saved_alu_op;
                        
                        Out_valid_reg <= 1'b1; // Trigger CDB Broadcast

                        // Fast Wakeup Catch
                        if (valid) begin
                            state <= PREP;
                            cdb_mul_busy <= 1'b1; 
                            
                            saved_prd         <= rr_prd;
                            saved_rob_index   <= rr_rob_index;
                            saved_branch_mask <= rr_branch_mask;   
                            saved_alu_op      <= alu_operation[1:0];
                            
                            M_reg      <= {init_M[33], init_M};
                            A_reg      <= 34'b0;
                            Q_reg      <= init_Q;
                            Q_minus_1  <= 1'b0;
                        end else begin
                            state <= IDLE;
                        end
                    end 
                    else begin
                        // Radix-4 Math Continues
                        A_reg     <= A_next_state;
                        Q_reg     <= Q_next_state;
                        Q_minus_1 <= Q_m1_next_state;
                        
                        iterations <= iterations - 1;
                        
                        // EARLY WAKEUP TRIGGER 
                        if (iterations == 1) cdb_mul_busy <= 1'b0; 
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end

    // Stage 3: Combinational Output Formatting & CDB Write
    assign cdb_write_data = Out_valid_reg;
    assign cdb_prd        = Out_prd_reg;
    assign cdb_rob_index  = Out_rob_index_reg;

    always_comb begin
        // Route the correct 32 bits onto the bus based on the saved opcode
        if (Out_alu_op == 2'b00) begin
            // MUL: Standard 32-bit multiply relies on the lower 32 bits
            cdb_alu_result = Out_Q_reg; 
        end else begin
            // MULH, MULHSU, MULHU: Rely on the upper 32 bits
            cdb_alu_result = Out_A_reg;
        end
    end

endmodule
