//direct-mapped cache BTB, indexed and tagged with the pc of the fetched bundle
module BTB #(
    parameter BTB_ROWS = 64,
    parameter XLEN = 32,
    parameter BTB_ADDRESS = $clog2(BTB_ROWS),
    parameter TAG_SIZE = XLEN - BTB_ADDRESS - 2
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

    btb_organization BTB [0:BTB_ROWS-1]; 
    logic [BTB_ROWS-1:0] btb_valid;

    always_comb begin
        read_tag = read_pc[XLEN-1: BTB_ADDRESS+2];
        if_tag   = if_pc[XLEN-1: BTB_ADDRESS+2];
        ex_tag   = ex_pc[XLEN-1: BTB_ADDRESS+2];
        btb_read_address     = read_pc[BTB_ADDRESS+1:2];
        if_btb_write_address = if_pc[BTB_ADDRESS+1:2];
        ex_btb_write_address = ex_pc[BTB_ADDRESS+1:2];
    end 
          
    always_ff @(posedge CLK) begin
        if (reset) begin
            btb_valid           <= '0;
            btb_hit             <= 0;
            btb_slot            <= 0;
            btb_is_branch       <= 0;
            pred_target_address <= '0;
        end
        else begin
            //writing btb from fetch stage        
            if (if_write) begin
                BTB[if_btb_write_address].bundled_tag    <= if_tag; 
                BTB[if_btb_write_address].target_address <= if_target_address;
                BTB[if_btb_write_address].offset         <= if_slot;
                BTB[if_btb_write_address].is_branch      <= 0;
                btb_valid[if_btb_write_address]          <= 1;
            end
            //writing btb from ex stage (older instruction, so it wins if both write the same row)
            if (ex_write) begin
                BTB[ex_btb_write_address].bundled_tag    <= ex_tag; 
                BTB[ex_btb_write_address].target_address <= ex_target_address;
                BTB[ex_btb_write_address].offset         <= ex_slot;
                BTB[ex_btb_write_address].is_branch      <= ex_is_branch;
                btb_valid[ex_btb_write_address]          <= 1;
            end
            // read btb
            if (read_en) begin
                btb_hit             <= btb_valid[btb_read_address] && (BTB[btb_read_address].bundled_tag == read_tag);
                pred_target_address <= {BTB[btb_read_address].target_address, 2'b00};
                btb_slot            <= BTB[btb_read_address].offset;
                btb_is_branch       <= BTB[btb_read_address].is_branch;
            end
        end    
    end
   
endmodule
