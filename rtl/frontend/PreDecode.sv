module PreDecode(
    input logic [6:0] opcode1, opcode2, 
    input logic [4:0] rd1, rd2, rs1_1, rs1_2,
    output logic [1:0] predecode_instr1, predecode_instr2, //00: other, 01: ret, 10: call, 11: jal
    output logic predecode_direct1, predecode_direct2      //jal (target known in fetch stage)
);

    //x1 and x5 are the link registers of the RISC-V calling convention
    function automatic logic is_link(input logic [4:0] r);
        return (r == 5'd1) || (r == 5'd5);
    endfunction

    function automatic logic [1:0] predecode(input logic [6:0] opcode, input logic [4:0] rd, input logic [4:0] rs1);
        if (opcode == 7'b1101111) begin
            return is_link(rd) ? 2'b10 : 2'b11; //call : jal
        end
        else if (opcode == 7'b1100111) begin
            if (is_link(rd))       return 2'b10; //indirect call
            else if (is_link(rs1)) return 2'b01; //ret
            else                   return 2'b00; //other indirect jump
        end
        else begin
            return 2'b00; //other
        end
    endfunction

    always_comb begin
        //1st instruction of bundle
        predecode_instr1  = predecode(opcode1, rd1, rs1_1);
        predecode_direct1 = (opcode1 == 7'b1101111);

        //2nd instruction of bundle 
        predecode_instr2  = predecode(opcode2, rd2, rs1_2);
        predecode_direct2 = (opcode2 == 7'b1101111);
    end
    
endmodule
