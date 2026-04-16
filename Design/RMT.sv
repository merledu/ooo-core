module RMT #(
    parameter PRF_ADDRESS = 6,
    parameter NUM_PHY_REG = 1 << PRF_ADDRESS
) (
    input logic CLK, reset, restore_rmt, reg_write1, reg_write2, wakeup1, wakeup2,
    input logic [4:0] rd1, rs1_1, rs2_1,
    input logic [4:0] rd2, rs1_2, rs2_2,
    input logic [PRF_ADDRESS-1:0] freed_reg1, freed_reg2, waked_reg1, waked_reg2,
    input logic [PRF_ADDRESS-1:0] bs_rmt_snap [0:31],
    input logic [NUM_PHY_REG-1:0] bs_busy_table_snap,
    output logic prs1_busy1, prs2_busy1, prs1_busy2, prs2_busy2,
    output logic [PRF_ADDRESS-1:0] prd1, prs1_1, prs2_1,
    output logic [PRF_ADDRESS-1:0] prd2, prs1_2, prs2_2,
    output logic [PRF_ADDRESS-1:0] rmt_snap [0:31],
    output logic [NUM_PHY_REG-1:0] busy_table_snap
);
    logic [PRF_ADDRESS-1:0] RMT [0:31];
    logic [NUM_PHY_REG-1:0] busy_table;

    logic wake_rs1_1, wake_rs1_2, wake_rs2_1, wake_rs2_2;

    assign busy_table_snap = busy_table;
    assign rmt_snap = RMT;

    assign wake_rs1_1 = (((waked_reg1 != '0) && wakeup1 && (waked_reg1 == RMT[rs1_1])) ||
                         ((waked_reg2 != '0) && wakeup2 && (waked_reg2 == RMT[rs1_1])));

    assign wake_rs2_1 = (((waked_reg1 != '0) && wakeup1 && (waked_reg1 == RMT[rs2_1])) ||
                         ((waked_reg2 != '0) && wakeup2 && (waked_reg2 == RMT[rs2_1]))); 

    assign wake_rs1_2 = (((waked_reg1 != '0) && wakeup1 && (waked_reg1 == RMT[rs1_2])) ||
                         ((waked_reg2 != '0) && wakeup2 && (waked_reg2 == RMT[rs1_2])));

    assign wake_rs2_2 = (((waked_reg1 != '0) && wakeup1 && (waked_reg1 == RMT[rs2_2])) ||
                         ((waked_reg2 != '0) && wakeup2 && (waked_reg2 == RMT[rs2_2]))); 

    always_ff @(posedge CLK) begin

        if (reset) begin    
            for (int i = 0; i < 32; i++) begin
                RMT[i] <= i;          
            end
            busy_table <= 0;
        end
        
        else begin
            if (restore_rmt) begin
                RMT <= bs_rmt_snap;
                busy_table <= bs_busy_table_snap;
            end
            else begin
                //updating Rename Map Table
                if (reg_write1 && (rd1 != 5'b0)) begin
                    RMT[rd1] <= freed_reg1;
                    busy_table[freed_reg1] <= 1;      
                end
                if (reg_write2 && (rd2 != 5'b0)) begin
                    RMT[rd2] <= freed_reg2;
                    busy_table[freed_reg2] <= 1;   
                end
            end
            //updating busy table from CDB
            if (wakeup1 && (waked_reg1 != '0)) begin
                busy_table[waked_reg1] <= 0;
            end
            if (wakeup2 && (waked_reg2 != '0)) begin
                busy_table[waked_reg2] <= 0;
            end
            
            
            //renaming instruction1
            
            prd1 <= (rd1!= 5'b0)? freed_reg1 : '0;


            prs1_1 <= RMT[rs1_1];
            prs1_busy1 <= (!wake_rs1_1 && busy_table[RMT[rs1_1]]); 

            prs2_1 <= RMT[rs2_1];
            prs2_busy1 <= (!wake_rs2_1 && busy_table[RMT[rs2_1]]); 

            //renaming instruction2
            prd2 <= (rd2!= 5'b0)? freed_reg2 : '0;

            if (reg_write1 && (rd1 == rs1_2) && (rs1_2 != 5'b0)) begin
                prs1_2 <= freed_reg1;
                prs1_busy2 <= 1;
            end
            else begin
                prs1_2 <= RMT[rs1_2];
                prs1_busy2 <= (!wake_rs1_2 && busy_table[RMT[rs1_2]]); 
            end

            if (reg_write1 && (rd1 == rs2_2) && (rs2_2 != 5'b0)) begin
                prs2_2 <= freed_reg1;
                prs2_busy2 <= 1;
            end
            else begin
                prs2_2 <= RMT[rs2_2];
                prs2_busy2 <= (!wake_rs2_2 && busy_table[RMT[rs2_2]]); 
            end
        end
    end

endmodule