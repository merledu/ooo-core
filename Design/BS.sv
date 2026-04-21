module BS #(
    parameter PRF_ADDRESS = 6,
    parameter NUM_PHY_REG = 1 << PRF_ADDRESS,
    parameter MAX_BRANCHES = 4,
    parameter BTAG_SIZE = $clog2(MAX_BRANCHES)  
) (
    input logic CLK, reset, id_take_snap, ex_branch_resolved,
    input logic [BTAG_SIZE-1:0] ex_btag,
    input logic [PRF_ADDRESS-1:0] rmt_snap [0:31],
    input logic [NUM_PHY_REG-1:0] busy_table_snap,
    input logic [PRF_ADDRESS-1:0] freelist_head_snap,
    output logic [PRF_ADDRESS-1:0] bs_rmt_snap [0:31],
    output logic [NUM_PHY_REG-1:0] bs_busytable_snap,
    output logic [PRF_ADDRESS-1:0] bs_freelist_head_snap,
    output logic [BTAG_SIZE-1:0] bs_branch_tag,
    output logic [MAX_BRANCHES-1:0] bs_branch_mask
);
 
    typedef struct {
        logic [PRF_ADDRESS-1:0] rmt_snapshot [0:31];
        logic [NUM_PHY_REG-1:0] busy_table_snapshot;
        logic [PRF_ADDRESS-1:0] freelist_head_snapshot;
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
    //to dispatch stage
    assign bs_branch_tag = current_btag;
    assign bs_branch_mask = BMR; 
    //to rename map table
    assign bs_rmt_snap = BS[ex_btag].rmt_snapshot;
    assign bs_busytable_snap = BS[ex_btag].busy_table_snapshot;
    assign bs_freelist_head_snap = BS[ex_btag].freelist_head_snapshot;

    always_ff @(posedge CLK) begin
        if (reset) begin
            BMR <= '0;
        end
        else begin
            //when branch is resolved we make the tag bit zero back again
            if (ex_branch_resolved) begin
                BMR[ex_btag] <= 1'b0;
            end
            if (id_take_snap) begin
                BMR[current_btag] <= 1'b1;
                BS[current_btag].rmt_snapshot <= rmt_snap;
                BS[current_btag].busy_table_snapshot <= busy_table_snap;
                BS[current_btag].freelist_head_snapshot <= freelist_head_snap;
            end
        end
    end
endmodule