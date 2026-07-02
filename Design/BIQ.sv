module BIQ #(
    parameter BIQ_ADDRESS = 5,
    parameter XLEN = 32,
    parameter PHT_ADDRESS = 9,
    parameter GHR_SIZE = 9,
    parameter RAS_ADDRESS = 3
) (
    input logic CLK, reset, biq_dealloc, flush, biq_alloc, pred_taken,
    input logic [XLEN-1:0] pred_target,
    input logic [BIQ_ADDRESS-1:0] biq_id,
    input logic [PHT_ADDRESS-1:0] pht_index,
    input logic [GHR_SIZE-1:0] prev_ghr,
    input logic [RAS_ADDRESS-1:0] sp_snap,
    input logic [2*XLEN-1:0] ras_snap,

    output logic biq_pred_taken, stall_frontend, 
    output logic [BIQ_ADDRESS-1:0] biq_address,
    output logic [XLEN-1:0] biq_pred_target, 
    output logic [GHR_SIZE-1:0] biq_restore_ghr, 
    output logic [RAS_ADDRESS-1:0] biq_sp_snap,
    output logic [2*XLEN-1:0] biq_ras_snap,
    output logic [PHT_ADDRESS-1:0] biq_pht_index
);

    typedef struct packed {
        logic predicted_taken;
        logic [XLEN-1:0] predicted_target;
        logic [PHT_ADDRESS-1:0] pht_table_index;
        logic [GHR_SIZE-1:0] previous_ghr;
        logic [2*XLEN-1:0] ras_snapshot;
        logic [RAS_ADDRESS-1:0] sp_snapshot;
    } biq_organization;

    (* ram_style = "distributed" *) biq_organization BIQ [0:(1<<BIQ_ADDRESS)-1];
    logic [BIQ_ADDRESS-1:0] biq_read_address;
    logic [BIQ_ADDRESS:0] biq_head_ptr, biq_tail_ptr;
    logic biq_full;

    assign biq_read_address = biq_id;
    assign biq_full = (biq_head_ptr[BIQ_ADDRESS-1:0] == biq_tail_ptr[BIQ_ADDRESS-1:0]) && (biq_head_ptr[BIQ_ADDRESS]!= biq_tail_ptr[BIQ_ADDRESS]);
    assign biq_address = biq_tail_ptr[BIQ_ADDRESS-1:0];
    assign stall_frontend = biq_full;
    //write to biq        
    always_ff @(posedge CLK) begin
        if (reset) begin
            biq_head_ptr <= 0;
            biq_tail_ptr <= 0;
        end
        else if (flush) begin
            biq_tail_ptr <= biq_head_ptr;
        end
        else begin
            if (biq_dealloc) begin
                biq_head_ptr <= biq_head_ptr + 1;
            end
            if ((!biq_full || biq_dealloc) && biq_alloc) begin
                BIQ[biq_tail_ptr[BIQ_ADDRESS-1:0]].predicted_taken  <= pred_taken;
                BIQ[biq_tail_ptr[BIQ_ADDRESS-1:0]].predicted_target <= pred_target;
                BIQ[biq_tail_ptr[BIQ_ADDRESS-1:0]].pht_table_index  <= pht_index;
                BIQ[biq_tail_ptr[BIQ_ADDRESS-1:0]].previous_ghr     <= prev_ghr;
                BIQ[biq_tail_ptr[BIQ_ADDRESS-1:0]].ras_snapshot     <= ras_snap;
                BIQ[biq_tail_ptr[BIQ_ADDRESS-1:0]].sp_snapshot      <= sp_snap;
                biq_tail_ptr <= biq_tail_ptr + 1;
            end
        end
    end    
    
    // reading from biq    
    always_ff @(posedge CLK) begin
        biq_pred_taken  <= BIQ[biq_read_address].predicted_taken;
        biq_pht_index   <= BIQ[biq_read_address].pht_table_index;
        biq_pred_target <= BIQ[biq_read_address].predicted_target;
        biq_restore_ghr <= BIQ[biq_read_address].previous_ghr;
        biq_ras_snap    <= BIQ[biq_read_address].ras_snapshot;
        biq_sp_snap     <= BIQ[biq_read_address].sp_snapshot;
    end 
endmodule