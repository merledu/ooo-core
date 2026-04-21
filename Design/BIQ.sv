module BIQ #(
    parameter BIQ_ADDRESS = 5,
    parameter XLEN = 32,
    parameter PHT_ADDRESS = 9,
    parameter GHR_SIZE = 9,
    parameter RAS_ADDRESS = 3
) (
    input logic CLK, reset, biq_dealloc, flush, pred_valid1, pred_valid2, biq_alloc1, biq_alloc2, pred_taken1, pred_taken2,
    input logic [BIQ_ADDRESS:0] biq_id, // biq id(5 bits) + slot id (1bit)=6
    input logic [XLEN-1:0] pred_target1, pred_target2,
    input logic [PHT_ADDRESS-1:0] pht_index1, pht_index2,
    input logic [GHR_SIZE-1:0] prev_ghr,
    input logic [RAS_ADDRESS-1:0] sp_snap,
    input logic [2*XLEN-1:0] ras_snap,
    output logic [BIQ_ADDRESS-1:0] biq_address, //without slot id cuz 2 slots combined
    output logic biq_valid, biq_pred_taken, stall_frontend, 
    output logic [XLEN-1:0] biq_pred_target, 
    output logic [GHR_SIZE-1:0] biq_restore_ghr, 
    output logic [RAS_ADDRESS-1:0] biq_sp_snap,
    output logic [2*XLEN-1:0] biq_ras_snap,
    output logic [PHT_ADDRESS-1:0] biq_pht_index
);

    typedef struct packed {
        logic predicted_valid;
        logic predicted_taken;
        logic [XLEN-1:0] predicted_target;
        logic [PHT_ADDRESS-1:0] pht_table_index;
    } biq_bank_organization;

    typedef struct packed {
        logic [GHR_SIZE-1:0] previous_ghr;
        logic [2*XLEN-1:0] ras_snapshot;
        logic [RAS_ADDRESS-1:0] sp_snapshot;
    } biq_shared_organization;

    (* ram_style = "distributed" *) biq_bank_organization BIQ_BANK0 [0:(1<<BIQ_ADDRESS)-1];
    (* ram_style = "distributed" *) biq_bank_organization BIQ_BANK1 [0:(1<<BIQ_ADDRESS)-1];
    (* ram_style = "distributed" *) biq_shared_organization BIQ_SHARED [0:(1<<BIQ_ADDRESS)-1];

    logic [BIQ_ADDRESS-1:0] biq_read_address;
    logic [BIQ_ADDRESS:0] biq_head_ptr, biq_tail_ptr;
    logic biq_full;

    assign biq_read_address = biq_id[BIQ_ADDRESS:1];
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
            if(!biq_full) begin
                if (biq_alloc1) begin
                    BIQ_BANK0[biq_tail_ptr[BIQ_ADDRESS-1:0]].predicted_valid <= pred_valid1;
                    BIQ_BANK0[biq_tail_ptr[BIQ_ADDRESS-1:0]].predicted_taken <= pred_taken1;
                    BIQ_BANK0[biq_tail_ptr[BIQ_ADDRESS-1:0]].predicted_target <= pred_target1;
                    BIQ_BANK0[biq_tail_ptr[BIQ_ADDRESS-1:0]].pht_table_index <= pht_index1;
                end
                if (biq_alloc2) begin
                    BIQ_BANK1[biq_tail_ptr[BIQ_ADDRESS-1:0]].predicted_valid <= pred_valid2;
                    BIQ_BANK1[biq_tail_ptr[BIQ_ADDRESS-1:0]].predicted_taken <= pred_taken2;
                    BIQ_BANK1[biq_tail_ptr[BIQ_ADDRESS-1:0]].predicted_target <= pred_target2;
                    BIQ_BANK1[biq_tail_ptr[BIQ_ADDRESS-1:0]].pht_table_index <= pht_index2;
                end
                if (biq_alloc1 || biq_alloc2) begin
                    biq_tail_ptr <= biq_tail_ptr + 1;
                    BIQ_SHARED[biq_tail_ptr[BIQ_ADDRESS-1:0]].previous_ghr <= prev_ghr;
                    BIQ_SHARED[biq_tail_ptr[BIQ_ADDRESS-1:0]].ras_snapshot <= ras_snap;
                    BIQ_SHARED[biq_tail_ptr[BIQ_ADDRESS-1:0]].sp_snapshot <= sp_snap;
                end
            end
        end    
    end
    // reading from biq    
    always_ff @(posedge CLK) begin
        if (biq_id[0]) begin //for bank1
            biq_valid <= BIQ_BANK1[biq_read_address].predicted_valid;
            biq_pred_taken <= BIQ_BANK1[biq_read_address].predicted_taken;
            biq_pht_index <= BIQ_BANK1[biq_read_address].pht_table_index;
            biq_pred_target <= BIQ_BANK1[biq_read_address].predicted_target;
        end 
        else begin //for bank 0
            biq_valid <= BIQ_BANK0[biq_read_address].predicted_valid;
            biq_pred_taken <= BIQ_BANK0[biq_read_address].predicted_taken;
            biq_pht_index <= BIQ_BANK0[biq_read_address].pht_table_index;
            biq_pred_target <= BIQ_BANK0[biq_read_address].predicted_target;            
        end
        biq_restore_ghr <= BIQ_SHARED[biq_read_address].previous_ghr;
        biq_ras_snap <= BIQ_SHARED[biq_read_address].ras_snapshot;
        biq_sp_snap <= BIQ_SHARED[biq_read_address].sp_snapshot;
    end 
endmodule