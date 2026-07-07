module BS #(
    parameter PRF_ADDRESS = 6,
    parameter NUM_PHY_REG = 1 << PRF_ADDRESS,
    parameter MAX_BRANCHES = 4,
    parameter BTAG_SIZE = $clog2(MAX_BRANCHES),
    parameter FL_ROWS = NUM_PHY_REG - 32,                 
    parameter FL_INDEX_WIDTH = $clog2(FL_ROWS),           
    parameter FL_PTR_WIDTH = FL_INDEX_WIDTH + 1           
) (
    input logic CLK, reset, flush, id_take_snap, cdb_branch_resolved, pop1, pop2,
    input logic id_branch1, id_jump1, id_valid1,
    input logic [BTAG_SIZE-1:0] cdb_branch_tag,
    input logic [31:0][PRF_ADDRESS-1:0] rmt_snap,
    input logic [FL_PTR_WIDTH-1:0] freelist_head_snap,

    output logic bs_full,
    output logic [31:0][PRF_ADDRESS-1:0] bs_rmt_snap,
    output logic [FL_PTR_WIDTH-1:0] bs_freelist_head_snap,
    output logic [BTAG_SIZE-1:0] bs_branch_tag,
    output logic [MAX_BRANCHES-1:0] bs_branch_mask
);
 
    typedef struct packed{
        logic [31:0][PRF_ADDRESS-1:0] rmt_snapshot;
        logic [FL_PTR_WIDTH-1:0] freelist_head_snapshot;
        logic [MAX_BRANCHES-1:0] bmr_snapshot;
    } bs_organization;

    bs_organization BS [0:MAX_BRANCHES-1];

    logic [MAX_BRANCHES-1:0] BMR;
    logic [BTAG_SIZE-1:0] current_btag;
       
    always_comb begin
        current_btag = '0;
        for (int i = 0; i < MAX_BRANCHES; i++) begin
            if (!BMR[i]) begin
                current_btag = BTAG_SIZE'(i);
                break;
            end
        end
    end
     
    //to rename map table
    assign bs_rmt_snap = BS[cdb_branch_tag].rmt_snapshot;
    assign bs_freelist_head_snap = BS[cdb_branch_tag].freelist_head_snapshot;
    assign bs_full = &BMR;
    //to dispatch stage
    assign bs_branch_tag = current_btag;
    assign bs_branch_mask = BMR;

    always_ff @(posedge CLK) begin
        if (reset) begin
            BMR <= '0;
        end
        else begin
            //when branch is resolved we make the tag bit zero back again
            if (flush) begin 
                BMR <= BS[cdb_branch_tag].bmr_snapshot;
            end
            if (cdb_branch_resolved) begin
                BMR[cdb_branch_tag] <= 1'b0;
                //all the branches that took snapshot of BMR should also get 0 because branch is resolved
                for (int i = 0; i < MAX_BRANCHES; i++) begin
                    if (!(id_take_snap && (BTAG_SIZE'(i) == current_btag))) begin
                        BS[i].bmr_snapshot[cdb_branch_tag] <= 1'b0; 
                    end
                end
            end
            if (id_take_snap) begin
                BMR[current_btag] <= 1'b1;
                BS[current_btag].rmt_snapshot <= rmt_snap;
                BS[current_btag].freelist_head_snapshot <= freelist_head_snap;
                BS[current_btag].bmr_snapshot <= (cdb_branch_resolved) ? (BMR & ~(1 << cdb_branch_tag)) : BMR;
            end
        end
    end
endmodule