module RAS #(
    parameter RAS_ADDRESS = 3,
    parameter XLEN = 32,
    parameter RAS_LEN = (1<<RAS_ADDRESS)
) (
    input logic CLK, reset, restore_ras, push, pop, //push/pop requested by the bundle in IF stage
    input logic update_en,                         //bundle leaves IF stage in this cycle
    input logic [XLEN-1:0] if_actual_return_address, 
    input logic [RAS_ADDRESS-1:0] rb_sp_snap,
    input logic [2*XLEN-1:0] rb_ras_snap,

    output logic [XLEN-1:0] pred_return_address,
    //state of the stack before and after the push/pop of this cycle {2nd entry, top entry}
    output logic [RAS_ADDRESS-1:0] sp_snap_pre, sp_snap_post,
    output logic [2*XLEN-1:0] ras_snap_pre, ras_snap_post
);
    (* ram_style = "distributed" *) logic [XLEN-1:0] RAS [0:RAS_LEN-1]; 
    logic [RAS_ADDRESS-1:0] sp;

    always_comb begin
        //top of the stack
        pred_return_address = RAS[RAS_ADDRESS'(sp - 1)]; 

        sp_snap_pre  = sp;
        ras_snap_pre = {RAS[RAS_ADDRESS'(sp - 2)], RAS[RAS_ADDRESS'(sp - 1)]};
        if (push) begin
            sp_snap_post  = sp + 1;
            ras_snap_post = {RAS[RAS_ADDRESS'(sp - 1)], if_actual_return_address};
        end
        else if (pop) begin
            sp_snap_post  = sp - 1;
            ras_snap_post = {RAS[RAS_ADDRESS'(sp - 3)], RAS[RAS_ADDRESS'(sp - 2)]};
        end
        else begin
            sp_snap_post  = sp_snap_pre;
            ras_snap_post = ras_snap_pre;
        end
    end

    always_ff @(posedge CLK) begin 
        if (reset) begin
            sp <= '0; 
            for (int i = 0; i < RAS_LEN; i++) begin
                RAS[i] <= '0;
            end
        end
        else if (restore_ras) begin         
            sp <= rb_sp_snap;                           
            RAS[RAS_ADDRESS'(rb_sp_snap - 1)] <= rb_ras_snap[XLEN-1:0];
            RAS[RAS_ADDRESS'(rb_sp_snap - 2)] <= rb_ras_snap[2*XLEN-1:XLEN];
        end
        else if (update_en && push) begin
            //pushing onto the stack 
            RAS[sp] <= if_actual_return_address; // from the IF stage
            sp <= sp + 1;
        end
        else if (update_en && pop) begin
            sp <= sp - 1;
        end
    end
  
endmodule 
