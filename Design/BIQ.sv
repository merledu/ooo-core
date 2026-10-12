module BIQ #(
    parameter BIQ_ADDRESS = 5,
    parameter XLEN = 32,
    parameter PHT_ADDRESS = 9,
    parameter GHR_SIZE = 9,
    parameter RAS_ADDRESS = 3
) (
    input logic CLK, reset, flush, biq_alloc, pred_taken, slot, is_ret, rob_global_flush,
    input logic [1:0] biq_dealloc,                 //number of branches committed in this cycle
    input logic [XLEN-1:0] pred_target,
    input logic [BIQ_ADDRESS-1:0] biq_id,          //read address (branch being issued)
    input logic [BIQ_ADDRESS-1:0] flush_biq_id,    //entry of the mispredicted branch
    input logic [PHT_ADDRESS-1:0] pht_index,
    input logic [GHR_SIZE-1:0] prev_ghr,
    input logic [RAS_ADDRESS-1:0] sp_snap,
    input logic [2*XLEN-1:0] ras_snap,

    output logic biq_pred_taken, biq_slot, biq_is_ret, biq_full, 
    output logic [BIQ_ADDRESS-1:0] biq_address,
    output logic [XLEN-1:0] biq_pred_target, 
    output logic [GHR_SIZE-1:0] biq_restore_ghr, 
    output logic [RAS_ADDRESS-1:0] biq_sp_snap,
    output logic [2*XLEN-1:0] biq_ras_snap,
    output logic [PHT_ADDRESS-1:0] biq_pht_index
);

    typedef struct packed {
        logic predicted_taken;
        logic bundle_slot;   // 0: branch is the 1st instruction of its bundle, 1: 2nd instruction
        logic is_return;
        logic [XLEN-1:0] predicted_target;
        logic [PHT_ADDRESS-1:0] pht_table_index;
        logic [GHR_SIZE-1:0] previous_ghr;
        logic [2*XLEN-1:0] ras_snapshot;
        logic [RAS_ADDRESS-1:0] sp_snapshot;
    } biq_organization;

    (* ram_style = "distributed" *) biq_organization BIQ [0:(1<<BIQ_ADDRESS)-1];
    logic [BIQ_ADDRESS-1:0] biq_read_address;
    logic [BIQ_ADDRESS:0] biq_head_ptr, biq_tail_ptr, biq_next_head_ptr;
    logic flush_wrap_bit;

    assign biq_read_address  = biq_id;
    assign biq_full          = (biq_head_ptr[BIQ_ADDRESS-1:0] == biq_tail_ptr[BIQ_ADDRESS-1:0]) && (biq_head_ptr[BIQ_ADDRESS]!= biq_tail_ptr[BIQ_ADDRESS]);
    assign biq_address       = biq_tail_ptr[BIQ_ADDRESS-1:0];
    assign biq_next_head_ptr = biq_head_ptr + {{(BIQ_ADDRESS-1){1'b0}}, biq_dealloc};
    //wrap bit of the mispredicted branch's entry (it lies between head and tail)
    assign flush_wrap_bit    = biq_head_ptr[BIQ_ADDRESS] ^ (flush_biq_id < biq_head_ptr[BIQ_ADDRESS-1:0]);

    //write to biq        
    always_ff @(posedge CLK) begin
        if (reset) begin
            biq_head_ptr <= 0;
            biq_tail_ptr <= 0;
        end
        else begin
            //entries are freed in order when their branch commits
            biq_head_ptr <= biq_next_head_ptr;

            if (rob_global_flush) begin
                //every remaining entry belongs to a squashed branch
                biq_tail_ptr <= biq_next_head_ptr;
            end
            else if (flush) begin
                //drop only the entries allocated after the mispredicted branch
                biq_tail_ptr <= {flush_wrap_bit, flush_biq_id} + 1;
            end
            else if (!biq_full && biq_alloc) begin
                BIQ[biq_address].predicted_taken  <= pred_taken;
                BIQ[biq_address].bundle_slot      <= slot;
                BIQ[biq_address].is_return        <= is_ret;
                BIQ[biq_address].predicted_target <= pred_target;
                BIQ[biq_address].pht_table_index  <= pht_index;
                BIQ[biq_address].previous_ghr     <= prev_ghr;
                BIQ[biq_address].ras_snapshot     <= ras_snap;
                BIQ[biq_address].sp_snapshot      <= sp_snap;
                biq_tail_ptr <= biq_tail_ptr + 1;
            end
        end
    end    
    
    // reading from biq (while the branch reads its registers, so the data is there in EX stage)   
    always_ff @(posedge CLK) begin
        biq_pred_taken  <= BIQ[biq_read_address].predicted_taken;
        biq_slot        <= BIQ[biq_read_address].bundle_slot;
        biq_is_ret      <= BIQ[biq_read_address].is_return;
        biq_pht_index   <= BIQ[biq_read_address].pht_table_index;
        biq_pred_target <= BIQ[biq_read_address].predicted_target;
        biq_restore_ghr <= BIQ[biq_read_address].previous_ghr;
        biq_ras_snap    <= BIQ[biq_read_address].ras_snapshot;
        biq_sp_snap     <= BIQ[biq_read_address].sp_snapshot;
    end 
endmodule
