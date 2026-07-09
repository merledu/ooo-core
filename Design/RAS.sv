module RAS #(
    parameter RAS_ADDRESS = 3,
    parameter XLEN = 32,
    parameter RAS_LEN = (1<<RAS_ADDRESS)
) (
    input logic CLK, reset, stall_frontend, restore_ras,
    input logic [1:0] if_predecode_instr1, if_predecode_instr2,
    input logic [XLEN-1:0] if_actual_return_address, 
    input logic [RAS_ADDRESS-1:0] rb_sp_snap,
    input logic [2*XLEN-1:0] rb_ras_snap,

    output logic is_return_instr,
    output logic [XLEN-1:0] pred_return_address,
    output logic [RAS_ADDRESS-1:0] sp_snap,
    output logic [2*XLEN-1:0] ras_snap
);
    (* ram_style = "distributed" *) logic [XLEN-1:0] RAS [0:RAS_LEN-1]; 
    logic [RAS_ADDRESS-1:0] sp, next_sp;
    logic pop;
    logic push;
    logic if_is_call1, if_is_call2, if_is_ret1, if_is_ret2;

    assign if_is_call1 = (if_predecode_instr1 ==  2'b10);
    assign if_is_call2 = (if_predecode_instr2 ==  2'b10);
    assign if_is_ret1  = (if_predecode_instr1 ==  2'b01);
    assign if_is_ret2  = (if_predecode_instr2 ==  2'b01);
    assign push = if_is_call1 || if_is_call2;
    assign pop  = if_is_ret1 || if_is_ret2;
    assign is_return_instr = pop;
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
        else if (!stall_frontend && (push || pop)) begin
            sp_snap <= sp;
            ras_snap <= {RAS[sp-2], RAS[sp-1]};
            sp <= next_sp;
            //pushing onto the stack 
            if (push) begin
                RAS[sp] <= if_actual_return_address; // from the IF stage
            end
        end
    end
  
endmodule 