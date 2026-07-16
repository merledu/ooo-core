module LSQ #(
    parameter XLEN = 32,
    parameter LQ_ENTRIES = 16,
    parameter SQ_ENTRIES = 16,
    parameter PRF_ADDRESS = 6,
    parameter ROB_SIZE = 64,
    parameter ROB_PTR_SIZE = $clog2(ROB_SIZE),
    parameter MAX_BRANCHES = 4
) (
    input logic CLK, reset,
);
    
    typedef struct packed {
        logic valid;
        logic [MAX_BRANCHES-1:0] branch_mask;
        logic speculative_execution;
        logic [ROB_PTR_SIZE-1:0] age;
        logic [XLEN-1:0] address;
        logic address_available;
        logic [PRF_ADDRESS-1:0] prd;
        logic [1:0] size;
        logic sign_extend;
    } lq_organization;
     
    typedef struct packed {
        logic valid;
        logic [MAX_BRANCHES-1:0] branch_mask;
        logic committed;
        logic [ROB_PTR_SIZE-1:0] age;
        logic [XLEN-1:0] address;
        logic address_available;
        logic [PRF_ADDRESS-1:0] prs2;
        logic [XLEN-1:0] stored_data;
        logic data_valid;
        logic [1:0] size;
    } sq_organization;
     
    lq_organization LQ [LQ_ENTRIES-1:0];
    sq_organization SQ [SQ_ENTRIES-1:0];    
endmodule