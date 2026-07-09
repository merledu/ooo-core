module IG #(
    parameter INIT_IMMEDIATE_SIZE = 21,
    parameter XLEN = 32
) (
    input logic [INIT_IMMEDIATE_SIZE-1:0] iss_immediate1, iss_immediate2,
    input logic iss_immtype1, iss_immtype2,
    output logic [XLEN-1:0] rr_immediate1, rr_immediate2
);
    always_comb begin
        //immediate generation for 1st instruction
        if (iss_immtype1 == 1'b0) begin
            rr_immediate1 = {{11{iss_immediate1[20]}}, iss_immediate1};
        end 
    
        else begin
            rr_immediate1 = {iss_immediate1[20:1], 12'b0};
        end
        //immediate generation for 2nd instruction
        if (iss_immtype2 == 1'b0) begin
            rr_immediate2 = {{11{iss_immediate2[20]}}, iss_immediate2};
        end 
    
        else begin
            rr_immediate2 = {iss_immediate2[20:1], 12'b0};
        end
    end
endmodule
