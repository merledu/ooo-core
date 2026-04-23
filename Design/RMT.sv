module RMT #(
    parameter PRF_ADDRESS = 6,
    parameter NUM_PHY_REG = 1 << PRF_ADDRESS
) (
    input logic CLK, reset, restore_rmt, stall_frontend, reg_write1, reg_write2, cdb_wakeup1, cdb_wakeup2,
    input logic id_branch1, id_jump1, id_valid1, id_valid2,
    input logic [4:0] rd1, rs1_1, rs2_1,
    input logic [4:0] rd2, rs1_2, rs2_2,
    input logic [PRF_ADDRESS-1:0] fl_freed_reg1, fl_freed_reg2, cdb_waked_reg1, cdb_waked_reg2,
    input logic [31:0][PRF_ADDRESS-1:0] bs_rmt_snap,
    output logic prs1_busy1, prs2_busy1, prs1_busy2, prs2_busy2,
    output logic [PRF_ADDRESS-1:0] prd1, prs1_1, prs2_1, old_prd1,
    output logic [PRF_ADDRESS-1:0] prd2, prs1_2, prs2_2, old_prd2,
    output logic [31:0][PRF_ADDRESS-1:0] rmt_snap
);

   logic [31:0][PRF_ADDRESS-1:0] RMT;
    logic [31:0][PRF_ADDRESS-1:0] next_RMT;
    logic [31:0][PRF_ADDRESS-1:0] next_RMT_inst1;
    logic [NUM_PHY_REG-1:0] busy_table;

    logic wake_rs1_1, wake_rs1_2, wake_rs2_1, wake_rs2_2;

    assign wake_rs1_1 = (((cdb_waked_reg1 != '0) && cdb_wakeup1 && (cdb_waked_reg1 == RMT[rs1_1])) ||
                         ((cdb_waked_reg2 != '0) && cdb_wakeup2 && (cdb_waked_reg2 == RMT[rs1_1])));

    assign wake_rs2_1 = (((cdb_waked_reg1 != '0) && cdb_wakeup1 && (cdb_waked_reg1 == RMT[rs2_1])) ||
                         ((cdb_waked_reg2 != '0) && cdb_wakeup2 && (cdb_waked_reg2 == RMT[rs2_1]))); 

    assign wake_rs1_2 = (((cdb_waked_reg1 != '0) && cdb_wakeup1 && (cdb_waked_reg1 == RMT[rs1_2])) ||
                         ((cdb_waked_reg2 != '0) && cdb_wakeup2 && (cdb_waked_reg2 == RMT[rs1_2])));

    assign wake_rs2_2 = (((cdb_waked_reg1 != '0) && cdb_wakeup1 && (cdb_waked_reg1 == RMT[rs2_2])) ||
                         ((cdb_waked_reg2 != '0) && cdb_wakeup2 && (cdb_waked_reg2 == RMT[rs2_2]))); 

    always_comb begin
        // Calculate the state after Instruction 1
        next_RMT_inst1 = RMT;

        if (restore_rmt) begin
            next_RMT_inst1 = bs_rmt_snap;
        end
        else if (reg_write1 && (rd1 != 5'b0) && !stall_frontend && id_valid1) begin
            next_RMT_inst1[rd1] = fl_freed_reg1;
        end

        // Calculate the NORMAL state (Inst 1 + Inst 2)
        // THIS MUST HAPPEN UNCONDITIONALLY! (Removed the 'else begin' wrapper)
        next_RMT = next_RMT_inst1; 
        
        if (!restore_rmt && reg_write2 && (rd2 != 5'b0) && !stall_frontend && id_valid2) begin
            next_RMT[rd2] = fl_freed_reg2;
        end

        // Conditional Snapshot MUST HAPPEN UNCONDITIONALLY!
        if ((id_branch1 || id_jump1) && id_valid1) begin
            rmt_snap = next_RMT_inst1; 
        end else begin
            rmt_snap = next_RMT;
        end
    end

    always_ff @(posedge CLK) begin
        if (reset) begin    
            for (int i = 0; i < 32; i++) begin
                RMT[i] <= PRF_ADDRESS'(i);   
            end
            old_prd1 <= '0;
            old_prd2 <= '0;
            busy_table <= 0;
            prd1 <= '0; 
            prd2 <= '0;
            prs1_1 <= '0; 
            prs2_1 <= '0; 
            prs1_2 <= '0; 
            prs2_2 <= '0;
            prs1_busy1 <= 0; 
            prs2_busy1 <= 0; 
            prs1_busy2 <= 0; 
            prs2_busy2 <= 0;
        end
        else begin
            // 1. CDB Wakeups happen NO MATTER WHAT
            if (cdb_wakeup1 && (cdb_waked_reg1 != '0)) begin
                busy_table[cdb_waked_reg1] <= 0;
            end
            if (cdb_wakeup2 && (cdb_waked_reg2 != '0)) begin
                busy_table[cdb_waked_reg2] <= 0;
            end

            // 2. Map Table Update (Flushes bypass stalls)
            if (restore_rmt || !stall_frontend) begin
                RMT <= next_RMT;
            end

            // 3. Busy Table New Allocations
            if (reg_write1 && (rd1 != 5'b0) && !stall_frontend && id_valid1 && !restore_rmt) begin
                busy_table[fl_freed_reg1] <= 1;      
            end
            if (reg_write2 && (rd2 != 5'b0) && !stall_frontend && id_valid2 && !restore_rmt) begin
                busy_table[fl_freed_reg2] <= 1;   
            end
            
            // 4. Output Pipeline Registers (Only update if not stalled!)
            if (!stall_frontend) begin
                old_prd1 <= RMT[rd1];
                old_prd2 <= (reg_write1 && (rd1 == rd2) && (rd1 != 5'b0) && id_valid1) ? fl_freed_reg1 : RMT[rd2];
                
                prd1 <= (rd1!= 5'b0)? fl_freed_reg1 : '0;
                prd2 <= (rd2!= 5'b0)? fl_freed_reg2 : '0;

                prs1_1 <= RMT[rs1_1];
                prs1_busy1 <= (!wake_rs1_1 && busy_table[RMT[rs1_1]]); 

                prs2_1 <= RMT[rs2_1];
                prs2_busy1 <= (!wake_rs2_1 && busy_table[RMT[rs2_1]]); 

                if (reg_write1 && (rd1 == rs1_2) && (rs1_2 != 5'b0) && id_valid1) begin
                    prs1_2 <= fl_freed_reg1;
                    prs1_busy2 <= 1;
                end else begin
                    prs1_2 <= RMT[rs1_2];
                    prs1_busy2 <= (!wake_rs1_2 && busy_table[RMT[rs1_2]]); 
                end

                if (reg_write1 && (rd1 == rs2_2) && (rs2_2 != 5'b0) && id_valid1) begin
                    prs2_2 <= fl_freed_reg1;
                    prs2_busy2 <= 1;
                end else begin
                    prs2_2 <= RMT[rs2_2];
                    prs2_busy2 <= (!wake_rs2_2 && busy_table[RMT[rs2_2]]); 
                end
            end

        end
    end

endmodule