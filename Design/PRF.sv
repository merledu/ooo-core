module PRF #(
    parameter PRF_ADDRESS = 6,
    parameter XLEN = 32,
    parameter REG_COUNT = (1<< PRF_ADDRESS)
) (
    input logic CLK, reset, cdb_regwrite1, cdb_regwrite2,
    input logic [PRF_ADDRESS-1:0] iss_instr1_prs1, iss_instr1_prs2, 
    input logic [PRF_ADDRESS-1:0] iss_instr2_prs1, iss_instr2_prs2, 
    input logic [PRF_ADDRESS-1:0] cdb_write_address1, cdb_write_address2,
    input logic [XLEN-1:0] cdb_write_data1, cdb_write_data2,
    output logic [XLEN-1:0] rr_instr1_read_data1, rr_instr1_read_data2, 
    output logic [XLEN-1:0] rr_instr2_read_data1, rr_instr2_read_data2
);
    logic [XLEN-1:0] PRF [REG_COUNT-1:0];

    // reading from register file
    always_ff @(posedge CLK) begin
        rr_instr1_read_data1 <= PRF[iss_instr1_prs1];
        rr_instr1_read_data2 <= PRF[iss_instr1_prs2];
        rr_instr2_read_data1 <= PRF[iss_instr2_prs1];
        rr_instr2_read_data2 <= PRF[iss_instr2_prs2];
    end
                
    always @(posedge CLK or posedge reset) begin
        if (reset) begin
            PRF <= '{default:0};
        end
        else begin
             if (cdb_regwrite1 && (cdb_write_address1 != 0)) begin
                PRF[cdb_write_address1] <= cdb_write_data1;
             end
             if (cdb_regwrite2 && (cdb_write_address2 != 0)) begin
                PRF[cdb_write_address2] <= cdb_write_data2;
             end
        end
    end
            
endmodule
