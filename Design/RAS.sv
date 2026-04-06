module RAS #(
    parameter RAS_ADDRESS = 3,
    parameter XLEN = 32,
    parameter RAS_LEN = (1<<RAS_ADDRESS)
) (
    input logic CLK, reset, update_ras, restore_ras, btb_is_ret1, btb_is_ret2,
    input logic [XLEN-1:0] actual_return_address, 
    input logic [RAS_ADDRESS-1:0] rb_sp_snap,
    input logic [2*XLEN-1:0] rb_ras_snap,
    output logic [XLEN-1:0] pred_return_address,
    output logic [RAS_ADDRESS-1:0] sp_snap,
    output logic [2*XLEN-1:0] ras_snap
);
    (* ram_style = "distributed" *) logic [XLEN-1:0] RAS [0:RAS_LEN-1]; 
    logic [RAS_ADDRESS-1:0] sp, next_sp;
    logic pop;
    logic push;

    assign push = update_ras;
    assign pop = btb_is_ret1 || btb_is_ret2;
    assign next_sp =  sp + {2'b00, push} - {2'b00, pop};

    always_comb begin
        //popping from RAS
        pred_return_address = RAS[next_sp]; 
    end
    always_ff @(posedge CLK) begin 
        if (reset) begin
            sp <= '0; 
            sp_snap <= '0;
            ras_snap <= '0;
        end
        else if (restore_ras) begin         
            sp <= rb_sp_snap;                           
            RAS[rb_sp_snap-1] <= rb_ras_snap[XLEN-1:0];
            RAS[rb_sp_snap-2] <= rb_ras_snap[2*XLEN-1:XLEN];
        end
        else if (push || pop) begin
            sp_snap <= sp;
            ras_snap <= {RAS[sp-2], RAS[sp-1]};
            sp <= next_sp;
            //pushing onto the stack 
            if (push) begin
                RAS[sp] <= actual_return_address; // from the decode
            end
        end
    end
  
endmodule 