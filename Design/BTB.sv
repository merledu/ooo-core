//direct-mapped cache BTB
module BTB #(
    parameter BTB_ROWS = 64,
    parameter XLEN = 32,
    parameter BTB_ADDRESS = $clog2(BTB_ROWS),
    parameter TAG_SIZE = XLEN - BTB_ADDRESS - 3
) (
    input logic CLK, reset, if_is_jal1, if_is_jal2, ex_is_taken_branch, ex_is_jalr, ex_is_not_ret,
    input logic [XLEN-1:0] pd_pc, if_pc, ex_pc, 
    input logic [XLEN-3:0] ex_target_address, if_target_address1, if_target_address2,
    output logic btb_hit,
    output logic [XLEN-1:0] pred_target_address
);  

    logic [TAG_SIZE-1:0] pd_tag, if_tag, ex_tag;
    logic [XLEN-3:0] if_target_address;
    logic [BTB_ADDRESS-1:0] btb_read_address, ex_btb_write_address, if_btb_write_address;

    typedef struct packed {
        logic [TAG_SIZE-1:0] bundled_tag;
        logic [XLEN-3:0] target_address; //for bundled pc and not storing the 2 bits cuz they are always zero 
        logic valid; 
    } btb_organization;

    btb_organization BTB [0:BTB_ROWS-1]; 
    always_comb begin
        pd_tag = pd_pc[XLEN-1: BTB_ADDRESS+3];
        if_tag = if_pc[XLEN-1: BTB_ADDRESS+3];
        ex_tag = ex_pc[XLEN-1: BTB_ADDRESS+3];

        btb_read_address     = pd_pc[BTB_ADDRESS+2:3];
        if_btb_write_address = if_pc[BTB_ADDRESS+2:3];
        ex_btb_write_address = ex_pc[BTB_ADDRESS+2:3];

        if_target_address = (if_is_jal1)? if_target_address1 : if_target_address2;
    end 
          
    always_ff @(posedge CLK) begin
        //writing btb from ex stage 
        if(ex_is_taken_branch || ex_is_jalr && ex_is_not_ret) begin
            BTB[ex_btb_write_address].bundled_tag <=  ex_tag; 
            BTB[ex_btb_write_address].target_address <= ex_target_address;
            BTB[ex_btb_write_address].valid <= 1;
        end
        //writing btb from fetch stage        
        if (if_is_jal1 || if_is_jal2) begin
            BTB[if_btb_write_address].bundled_tag <=  if_tag; 
            BTB[if_btb_write_address].target_address <= if_target_address;
            BTB[if_btb_write_address].valid <= 1;
        end
        // read btb
        if (BTB[btb_read_address].valid && BTB[btb_read_address].bundled_tag == pd_tag) begin
            btb_hit             <= 1;
            pred_target_address <= {BTB[btb_read_address].target_address, 2'b00};
        end
        else begin
            btb_hit             <= 0;
        end
    end
   
endmodule