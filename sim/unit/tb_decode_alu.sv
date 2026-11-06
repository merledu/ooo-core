// Unit test of the decode + execute data path: CU, ALUCU, IG21 (decode), IG (immediate expansion) and ALU.
// Every RV32I computational instruction, branch condition and jump link value is checked against a model,
// with the operand selection done exactly like EX_Stage does it.
module tb_decode_alu;
    logic [31:0] instr, rs1, rs2, pc;
    logic [2:0] ALUOp;
    logic is_m, JumpReg, Jump, Branch, RegSrc1, RegSrc2, UpperImm, RegWrite, MemWrite, MemToReg, RetAddr, isimm, valid_opcode, UseRs1, UseRs2;
    logic [4:0] alu_op;
    logic [20:0] imm21, imm21_b;
    logic imm_type, imm_type_b;
    logic [31:0] imm, imm_b, a, b, result;

    CU cu (.opcode(instr[6:0]), .funct7(instr[31:25]), .ALUOp(ALUOp), .is_m_extension(is_m), .JumpReg(JumpReg), .Jump(Jump),
           .Branch(Branch), .RegSrc1(RegSrc1), .RegSrc2(RegSrc2), .UpperImm(UpperImm), .RegWrite(RegWrite), .MemWrite(MemWrite),
           .MemToReg(MemToReg), .RetAddr(RetAddr), .imm(isimm), .valid_opcode(valid_opcode), .UseRs1(UseRs1), .UseRs2(UseRs2));
    ALUCU alucu (.ALUOp(ALUOp), .func3(instr[14:12]), .func7(instr[31:25]), .ALUOperation(alu_op));
    IG21 ig21 (.instruction(instr), .immediate_output(imm21), .imm_type(imm_type));
    IG ig (.iss_immediate1(imm21), .iss_immediate2(imm21), .iss_immtype1(imm_type), .iss_immtype2(imm_type), .rr_immediate1(imm), .rr_immediate2(imm_b));
    ALU alu (.valid(1'b1), .dataA(a), .dataB(b), .rr_alu_operation(alu_op), .alu_result(result));

    // operand selection of EX_Stage
    assign a = UpperImm ? 32'b0 : (RegSrc1 ? rs1 : pc);
    assign b = RetAddr ? 32'd4 : (RegSrc2 ? rs2 : imm);

    int errors = 0, tests = 0;

    task automatic check(input string name, input logic [31:0] got, input logic [31:0] expected);
        tests++;
        if (got !== expected) begin
            errors++;
            if (errors < 30) $display("FAIL %s instr=%h rs1=%h rs2=%h pc=%h got=%h expected=%h", name, instr, rs1, rs2, pc, got, expected);
        end
    endtask

    function automatic logic [31:0] rnd();
        logic [31:0] c [8] = '{32'h0, 32'h1, 32'hFFFFFFFF, 32'h80000000, 32'h7FFFFFFF, 32'h1F, 32'h20, 32'hFFFFFFE0};
        return ($urandom_range(3) == 0) ? c[$urandom_range(7)] : $urandom;
    endfunction

    logic [31:0] i_imm, s_imm, b_imm, u_imm, j_imm;
    logic [2:0] f3;
    logic [31:0] expected;
    logic taken;

    initial begin
        repeat (20000) begin
            rs1 = rnd(); rs2 = rnd(); pc = {$urandom, 2'b00};
            instr = $urandom;
            f3 = instr[14:12];
            i_imm = {{20{instr[31]}}, instr[31:20]};
            s_imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            b_imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
            u_imm = {instr[31:12], 12'b0};
            j_imm = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
            case ($urandom_range(8))
                0: begin // R type (RV32I)
                    instr[6:0] = 7'b0110011; instr[31:25] = (f3 == 3'b000 || f3 == 3'b101) ? {1'b0, instr[30], 5'b0} : 7'b0;
                    #1;
                    case (f3)
                        3'b000: expected = instr[30] ? rs1 - rs2 : rs1 + rs2;
                        3'b001: expected = rs1 << rs2[4:0];
                        3'b010: expected = {31'b0, $signed(rs1) < $signed(rs2)};
                        3'b011: expected = {31'b0, rs1 < rs2};
                        3'b100: expected = rs1 ^ rs2;
                        3'b101: expected = instr[30] ? $unsigned($signed(rs1) >>> rs2[4:0]) : rs1 >> rs2[4:0];
                        3'b110: expected = rs1 | rs2;
                        default: expected = rs1 & rs2;
                    endcase
                    check("R-type", result, expected);
                    check("R-type ctrl", {28'b0, RegWrite, is_m, UseRs1, UseRs2}, 32'b1011);
                end
                1: begin // I type
                    instr[6:0] = 7'b0010011;
                    if (f3 == 3'b001) instr[31:25] = 7'b0;
                    if (f3 == 3'b101) instr[31:25] = {1'b0, instr[30], 5'b0};
                    i_imm = {{20{instr[31]}}, instr[31:20]};
                    #1;
                    case (f3)
                        3'b000: expected = rs1 + i_imm;
                        3'b001: expected = rs1 << instr[24:20];
                        3'b010: expected = {31'b0, $signed(rs1) < $signed(i_imm)};
                        3'b011: expected = {31'b0, rs1 < i_imm};
                        3'b100: expected = rs1 ^ i_imm;
                        3'b101: expected = instr[30] ? $unsigned($signed(rs1) >>> instr[24:20]) : rs1 >> instr[24:20];
                        3'b110: expected = rs1 | i_imm;
                        default: expected = rs1 & i_imm;
                    endcase
                    check("I-type", result, expected);
                    check("I-type ctrl", {28'b0, RegWrite, is_m, UseRs1, UseRs2}, 32'b1010);
                end
                2: begin // load address
                    instr[6:0] = 7'b0000011; #1;
                    check("load address", result, rs1 + i_imm);
                    check("load ctrl", {27'b0, RegWrite, MemToReg, MemWrite, UseRs1, UseRs2}, 32'b11010);
                end
                3: begin // store address
                    instr[6:0] = 7'b0100011; #1;
                    check("store address", result, rs1 + s_imm);
                    check("store ctrl", {27'b0, RegWrite, MemToReg, MemWrite, UseRs1, UseRs2}, 32'b00111);
                end
                4: begin // conditional branch: bit 0 of the ALU result = taken, target = pc + imm
                    instr[6:0] = 7'b1100011;
                    if (f3 == 3'b010 || f3 == 3'b011) instr[14:12] = 3'b000;
                    f3 = instr[14:12];
                    if ($urandom_range(3) == 0) rs2 = rs1;
                    #1;
                    case (f3)
                        3'b000: taken = (rs1 == rs2);
                        3'b001: taken = (rs1 != rs2);
                        3'b100: taken = ($signed(rs1) < $signed(rs2));
                        3'b101: taken = ($signed(rs1) >= $signed(rs2));
                        3'b110: taken = (rs1 < rs2);
                        default: taken = (rs1 >= rs2);
                    endcase
                    check("branch condition", {31'b0, result[0]}, {31'b0, taken});
                    check("branch target", pc + imm, pc + b_imm);
                    check("branch ctrl", {26'b0, Branch, Jump, JumpReg, RegWrite, UseRs1, UseRs2}, 32'b100011);
                end
                5: begin // jal: link = pc + 4, target = pc + imm
                    instr[6:0] = 7'b1101111; #1;
                    check("jal link", result, pc + 4);
                    check("jal target", pc + imm, pc + j_imm);
                    check("jal ctrl", {26'b0, Branch, Jump, JumpReg, RegWrite, UseRs1, UseRs2}, 32'b110100);
                end
                6: begin // jalr: link = pc + 4, target = rs1 + imm
                    instr[6:0] = 7'b1100111; instr[14:12] = 3'b000; #1;
                    check("jalr link", result, pc + 4);
                    check("jalr target", rs1 + imm, rs1 + i_imm);
                    check("jalr ctrl", {26'b0, Branch, Jump, JumpReg, RegWrite, UseRs1, UseRs2}, 32'b111110);
                end
                7: begin // lui
                    instr[6:0] = 7'b0110111; #1;
                    check("lui", result, u_imm);
                    check("lui ctrl", {29'b0, RegWrite, UseRs1, UseRs2}, 32'b100);
                end
                default: begin // auipc
                    instr[6:0] = 7'b0010111; #1;
                    check("auipc", result, pc + u_imm);
                    check("auipc ctrl", {29'b0, RegWrite, UseRs1, UseRs2}, 32'b100);
                end
            endcase
        end

        // M extension decode (the operation itself is tested in tb_muldiv)
        for (int f = 0; f < 8; f++) begin
            logic [4:0] code [8] = '{5'b10000, 5'b10001, 5'b10010, 5'b10011, 5'b10100, 5'b10101, 5'b11010, 5'b11011};
            instr = {7'b0000001, 10'b0, 3'(f), 5'b0, 7'b0110011}; #1;
            check("M decode", {26'b0, is_m, alu_op}, {26'b0, 1'b1, code[f]});
        end
        // unsupported opcodes are not valid
        instr = 32'h00000073; #1; check("ecall not valid", {31'b0, valid_opcode}, 32'b0);
        instr = 32'h00000000; #1; check("zero not valid", {31'b0, valid_opcode}, 32'b0);

        if (errors == 0) $display("PASS tb_decode_alu (%0d checks)", tests);
        else             $display("FAIL tb_decode_alu: %0d errors in %0d checks", errors, tests);
        $finish;
    end
endmodule
