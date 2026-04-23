module BS #(
    parameter PRF_ADDRESS = 6,
    parameter NUM_PHY_REG = 1 << PRF_ADDRESS,
    parameter MAX_BRANCHES = 4,
    parameter BTAG_SIZE = $clog2(MAX_BRANCHES),
    parameter FL_ROWS = NUM_PHY_REG - 32,                 
    parameter FL_INDEX_WIDTH = $clog2(FL_ROWS),           
    parameter FL_PTR_WIDTH = FL_INDEX_WIDTH + 1           
) (
    input logic CLK, reset, flush, id_take_snap, ex_branch_resolved, pop1, pop2,
    input logic id_branch1, id_jump1, id_valid1,
    input logic [BTAG_SIZE-1:0] ex_btag,
    input logic [PRF_ADDRESS-1:0] rmt_snap [0:31],
    input logic [FL_PTR_WIDTH-1:0] freelist_head_snap,
    output logic bs_full,
    output logic [PRF_ADDRESS-1:0] bs_rmt_snap [0:31],
    output logic [FL_PTR_WIDTH-1:0] bs_freelist_head_snap,
    output logic [BTAG_SIZE-1:0] bs_branch_tag,
    output logic [MAX_BRANCHES-1:0] bs_branch_mask
);
 
    typedef struct {
        logic [PRF_ADDRESS-1:0] rmt_snapshot [0:31];
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
                current_btag = i;
                break;
            end
        end
    end
     
    //to rename map table
    assign bs_rmt_snap = BS[ex_btag].rmt_snapshot;
    assign bs_freelist_head_snap = BS[ex_btag].freelist_head_snapshot;
    assign bs_full = &BMR;

    always_ff @(posedge CLK) begin
        //to dispatch stage
        bs_branch_tag <= current_btag;
        bs_branch_mask <= BMR;

        if (reset) begin
            BMR <= '0;
        end
        else begin
            //when branch is resolved we make the tag bit zero back again
            if (flush) begin 
                BMR <= BS[ex_btag].bmr_snapshot;
            end
            if (ex_branch_resolved) begin
                BMR[ex_btag] <= 1'b0;
                //all the branches that took snapshot of BMR should also get 0 because branch is resolved
                for (int i = 0; i < MAX_BRANCHES; i++) begin
                    if (!(id_take_snap && (i == current_btag))) begin
                        BS[i].bmr_snapshot[ex_btag] <= 1'b0; 
                    end
                end
            end
            if (id_take_snap) begin
                BMR[current_btag] <= 1'b1;
                BS[current_btag].rmt_snapshot <= rmt_snap;
                BS[current_btag].freelist_head_snapshot <= freelist_head_snap;
                BS[current_btag].bmr_snapshot <= (ex_branch_resolved) ? (BMR & ~(1 << ex_btag)) : BMR;
            end
        end
    end
endmodule