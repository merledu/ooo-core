//set associative cache BTB, indexed and tagged with the pc of the fetched bundle
//BTB_ROWS entries in total, BTB_ROWS / BTB_WAYS sets (BTB_WAYS = 1: direct mapped)
module BTB #(
    parameter BTB_ROWS = 64,
    parameter BTB_WAYS = 2,
    parameter XLEN = 32,
    parameter BTB_SETS = BTB_ROWS / BTB_WAYS,
    parameter BTB_ADDRESS = $clog2(BTB_SETS),
    parameter TAG_SIZE = XLEN - BTB_ADDRESS - 2,
    parameter WAY_BITS = (BTB_WAYS > 1) ? $clog2(BTB_WAYS) : 1
) (
    input logic CLK, reset, read_en,
    input logic if_write, if_slot,           //jal found in fetch stage
    input logic ex_write, ex_slot, ex_is_branch, //taken branch / jal / jalr (not return) resolved in ex stage
    input logic [XLEN-1:0] read_pc, if_pc, ex_pc, //pc of the bundle (not of the instruction)
    input logic [XLEN-3:0] ex_target_address, if_target_address,

    output logic btb_hit, btb_slot, btb_is_branch,
    output logic [XLEN-1:0] pred_target_address
);

    logic [TAG_SIZE-1:0] read_tag, if_tag, ex_tag;
    logic [BTB_ADDRESS-1:0] btb_read_address, ex_btb_write_address, if_btb_write_address;

    typedef struct packed {
        logic [TAG_SIZE-1:0] bundled_tag;
        logic [XLEN-3:0] target_address; //not storing the 2 lsbs cuz they are always zero
        logic offset;    // which among the bundle is the branch (0: 1st instruction, 1: 2nd instruction)
        logic is_branch; // conditional branch (consult the PHT) or jump (always taken)
    } btb_organization;

    btb_organization BTB [BTB_WAYS][BTB_SETS];
    logic [BTB_WAYS-1:0][BTB_SETS-1:0] btb_valid;
    //most recently used way of each set (the other way is replaced first when there are 2 ways)
    logic [BTB_SETS-1:0][WAY_BITS-1:0] mru;

    always_comb begin
        read_tag = read_pc[XLEN-1: BTB_ADDRESS+2];
        if_tag   = if_pc[XLEN-1: BTB_ADDRESS+2];
        ex_tag   = ex_pc[XLEN-1: BTB_ADDRESS+2];
        btb_read_address     = read_pc[BTB_ADDRESS+1:2];
        if_btb_write_address = if_pc[BTB_ADDRESS+1:2];
        ex_btb_write_address = ex_pc[BTB_ADDRESS+1:2];
    end

    //way written for a bundle: the way which already holds it, else an empty way, else the one after the mru way
    function automatic logic [WAY_BITS-1:0] write_way(input logic [BTB_ADDRESS-1:0] set, input logic [TAG_SIZE-1:0] tag);
        logic found;
        found = 0;
        write_way = (BTB_WAYS > 1) ? WAY_BITS'((int'(mru[set]) + 1) % BTB_WAYS) : '0;
        for (int w = BTB_WAYS-1; w >= 0; w--) begin
            if (!btb_valid[w][set]) write_way = WAY_BITS'(w);
        end
        for (int w = 0; w < BTB_WAYS; w++) begin
            if (!found && btb_valid[w][set] && BTB[w][set].bundled_tag == tag) begin
                write_way = WAY_BITS'(w);
                found = 1;
            end
        end
    endfunction

    logic [WAY_BITS-1:0] if_way, ex_way, read_way;
    logic read_found, if_write_en;
    always_comb begin
        if_way = write_way(if_btb_write_address, if_tag);
        ex_way = write_way(ex_btb_write_address, ex_tag);
        //ex stage has the older instruction, so it wins if both write the same entry
        if_write_en = if_write && !(ex_write && if_btb_write_address == ex_btb_write_address && if_way == ex_way);

        read_found = 0;
        read_way = '0;
        for (int w = 0; w < BTB_WAYS; w++) begin
            if (!read_found && btb_valid[w][btb_read_address] && BTB[w][btb_read_address].bundled_tag == read_tag) begin
                read_way = WAY_BITS'(w);
                read_found = 1;
            end
        end
    end

    always_ff @(posedge CLK) begin
        if (reset) begin
            btb_valid           <= '0;
            mru                 <= '0;
            btb_hit             <= 0;
            btb_slot            <= 0;
            btb_is_branch       <= 0;
            pred_target_address <= '0;
        end
        else begin
            // read btb
            if (read_en) begin
                btb_hit             <= read_found;
                pred_target_address <= {BTB[read_way][btb_read_address].target_address, 2'b00};
                btb_slot            <= BTB[read_way][btb_read_address].offset;
                btb_is_branch       <= BTB[read_way][btb_read_address].is_branch;
                if (read_found) mru[btb_read_address] <= read_way;
            end
            //writing btb from fetch stage
            if (if_write_en) begin
                BTB[if_way][if_btb_write_address].bundled_tag    <= if_tag;
                BTB[if_way][if_btb_write_address].target_address <= if_target_address;
                BTB[if_way][if_btb_write_address].offset         <= if_slot;
                BTB[if_way][if_btb_write_address].is_branch      <= 0;
                btb_valid[if_way][if_btb_write_address]          <= 1;
                mru[if_btb_write_address]                        <= if_way;
            end
            //writing btb from ex stage
            if (ex_write) begin
                BTB[ex_way][ex_btb_write_address].bundled_tag    <= ex_tag;
                BTB[ex_way][ex_btb_write_address].target_address <= ex_target_address;
                BTB[ex_way][ex_btb_write_address].offset         <= ex_slot;
                BTB[ex_way][ex_btb_write_address].is_branch      <= ex_is_branch;
                btb_valid[ex_way][ex_btb_write_address]          <= 1;
                mru[ex_btb_write_address]                        <= ex_way;
            end
        end
    end

endmodule
