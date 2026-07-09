// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtb_main_datapath__Syms.h"


VL_ATTR_COLD void Vtb_main_datapath___024root__trace_init_sub__TOP__0(Vtb_main_datapath___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_main_datapath__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_main_datapath___024root__trace_init_sub__TOP__0\n"); );
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->pushPrefix("tb_main_datapath", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+572,0,"XLEN",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+573,0,"OPCODE_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+574,0,"PHT_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+574,0,"GHR_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+575,0,"RAS_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+576,0,"INIT_IMMEDIATE_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+577,0,"BIQ_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+578,0,"PRF_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+579,0,"MAX_BRANCHES",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+580,0,"BTAG_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+581,0,"ROB_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+578,0,"ROB_PTR_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+565,0,"CLK",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+1,0,"reset",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+2,0,"flush",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+3,0,"actual_taken",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+4,0,"mispredict",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+5,0,"restore_ghr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+6,0,"restore_ras",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+7,0,"update_pht",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+8,0,"update_btb",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+9,0,"update_ras",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+10,0,"ex_is_ret",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+11,0,"ex_is_branch",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+12,0,"ex_is_jalr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+13,0,"branch_mispredicted",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+582,0,"actual_target_address",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+583,0,"ex_pc",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+584,0,"ghr_snap",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+585,0,"rb_pht_index",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+586,0,"rb_sp_snap",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declQuad(c+587,0,"rb_ras_snap",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBit(c+14,0,"dis_biq_dealloc",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+15,0,"rr_biq_id",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBit(c+16,0,"rr_slot_id",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+17,0,"cdb_done1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+18,0,"cdb_done2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+19,0,"cdb_wakeup1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+20,0,"cdb_wakeup2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+21,0,"cdb_branch_resolved",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+22,0,"cdb_branch_correct",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+23,0,"comm_free_push1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+24,0,"comm_free_push2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+25,0,"cdb_waked_reg1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+26,0,"cdb_waked_reg2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+27,0,"comm_free_reg1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+28,0,"comm_free_reg2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+29,0,"cdb_branch_tag",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+30,0,"cdb_rob_index1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+31,0,"cdb_rob_index2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+32,0,"cdb_branch_rob_index",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBit(c+63,0,"stall_frontend",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+589,0,"id_biq_valid",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+64,0,"id_biq_pred_taken",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+65,0,"id_biq_pred_target",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+66,0,"id_biq_pht_index",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+67,0,"id_biq_restore_ghr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+68,0,"id_biq_sp_snap",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declQuad(c+69,0,"id_biq_ras_snap",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBit(c+71,0,"commit_instr1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+72,0,"commit_instr2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+73,0,"dis_free_old_prd1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+74,0,"dis_free_old_prd2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+75,0,"comm_prd1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+76,0,"comm_prd2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+77,0,"comm_rd1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+78,0,"comm_rd2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBit(c+79,0,"iss_valid1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+80,0,"iss_is_m_extension1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+81,0,"iss_jump_reg1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+82,0,"iss_jump1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+83,0,"iss_branch1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+84,0,"iss_instr1_regsrc1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+85,0,"iss_instr1_regsrc2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+86,0,"iss_immtype1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+87,0,"iss_isimm1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+88,0,"iss_retaddr1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+89,0,"iss_upperimm1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+90,0,"iss_regwrite1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+91,0,"iss_memwrite1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+92,0,"iss_memtoreg1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+93,0,"iss_pc1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 29,0);
    tracep->declBus(c+94,0,"iss_prd1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+95,0,"iss_instr1_prs1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+96,0,"iss_instr1_prs2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+97,0,"iss_immediate1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBus(c+98,0,"iss_alu_operation1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+99,0,"iss_branch_tag1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+100,0,"iss_branch_mask1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+101,0,"iss_biq_address1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+102,0,"iss_rob_index1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBit(c+103,0,"iss_valid2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+104,0,"iss_is_m_extension2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+105,0,"iss_jump_reg2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+106,0,"iss_jump2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+107,0,"iss_branch2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+108,0,"iss_instr2_regsrc1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+109,0,"iss_instr2_regsrc2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+110,0,"iss_immtype2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+111,0,"iss_isimm2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+112,0,"iss_retaddr2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+113,0,"iss_upperimm2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+114,0,"iss_regwrite2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+115,0,"iss_memwrite2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+116,0,"iss_memtoreg2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+117,0,"iss_pc2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 29,0);
    tracep->declBus(c+118,0,"iss_prd2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+119,0,"iss_instr2_prs1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+120,0,"iss_instr2_prs2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+121,0,"iss_immediate2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBus(c+122,0,"iss_alu_operation2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+123,0,"iss_branch_tag2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+124,0,"iss_branch_mask2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+125,0,"iss_biq_address2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+126,0,"iss_rob_index2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->pushPrefix("dut", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+572,0,"XLEN",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+573,0,"OPCODE_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+574,0,"PHT_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+574,0,"GHR_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+575,0,"RAS_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+576,0,"INIT_IMMEDIATE_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+577,0,"BIQ_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+578,0,"PRF_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+579,0,"MAX_BRANCHES",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+580,0,"BTAG_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+581,0,"ROB_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+578,0,"ROB_PTR_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+581,0,"NUM_PHY_REG",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+572,0,"FL_ROWS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+577,0,"FL_INDEX_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+578,0,"FL_PTR_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+565,0,"CLK",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+1,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+2,0,"flush",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+3,0,"actual_taken",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+4,0,"mispredict",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+5,0,"restore_ghr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+6,0,"restore_ras",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+7,0,"update_pht",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+8,0,"update_btb",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+9,0,"update_ras",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+10,0,"ex_is_ret",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+11,0,"ex_is_branch",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+12,0,"ex_is_jalr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+13,0,"branch_mispredicted",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+582,0,"actual_target_address",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+583,0,"ex_pc",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+584,0,"ghr_snap",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+585,0,"rb_pht_index",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+586,0,"rb_sp_snap",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declQuad(c+587,0,"rb_ras_snap",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBit(c+14,0,"dis_biq_dealloc",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+15,0,"rr_biq_id",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBit(c+16,0,"rr_slot_id",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+17,0,"cdb_done1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+18,0,"cdb_done2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+19,0,"cdb_wakeup1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+20,0,"cdb_wakeup2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+23,0,"comm_free_push1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+24,0,"comm_free_push2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+21,0,"cdb_branch_resolved",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+22,0,"cdb_branch_correct",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+25,0,"cdb_waked_reg1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+26,0,"cdb_waked_reg2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+27,0,"comm_free_reg1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+28,0,"comm_free_reg2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+29,0,"cdb_branch_tag",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+30,0,"cdb_rob_index1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+31,0,"cdb_rob_index2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+32,0,"cdb_branch_rob_index",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBit(c+63,0,"stall_frontend",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+589,0,"id_biq_valid",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+64,0,"id_biq_pred_taken",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+65,0,"id_biq_pred_target",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+66,0,"id_biq_pht_index",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+67,0,"id_biq_restore_ghr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+68,0,"id_biq_sp_snap",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declQuad(c+69,0,"id_biq_ras_snap",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBit(c+71,0,"commit_instr1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+72,0,"commit_instr2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+73,0,"dis_free_old_prd1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+74,0,"dis_free_old_prd2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+75,0,"comm_prd1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+76,0,"comm_prd2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+77,0,"comm_rd1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+78,0,"comm_rd2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBit(c+79,0,"iss_valid1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+80,0,"iss_is_m_extension1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+81,0,"iss_jump_reg1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+82,0,"iss_jump1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+83,0,"iss_branch1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+84,0,"iss_instr1_regsrc1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+85,0,"iss_instr1_regsrc2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+86,0,"iss_immtype1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+87,0,"iss_isimm1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+88,0,"iss_retaddr1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+89,0,"iss_upperimm1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+90,0,"iss_regwrite1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+91,0,"iss_memwrite1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+92,0,"iss_memtoreg1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+93,0,"iss_pc1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 29,0);
    tracep->declBus(c+94,0,"iss_prd1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+95,0,"iss_instr1_prs1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+96,0,"iss_instr1_prs2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+97,0,"iss_immediate1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBus(c+98,0,"iss_alu_operation1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+99,0,"iss_branch_tag1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+100,0,"iss_branch_mask1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+101,0,"iss_biq_address1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+102,0,"iss_rob_index1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBit(c+103,0,"iss_valid2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+104,0,"iss_is_m_extension2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+105,0,"iss_jump_reg2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+106,0,"iss_jump2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+107,0,"iss_branch2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+108,0,"iss_instr2_regsrc1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+109,0,"iss_instr2_regsrc2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+110,0,"iss_immtype2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+111,0,"iss_isimm2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+112,0,"iss_retaddr2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+113,0,"iss_upperimm2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+114,0,"iss_regwrite2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+115,0,"iss_memwrite2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+116,0,"iss_memtoreg2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+117,0,"iss_pc2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 29,0);
    tracep->declBus(c+118,0,"iss_prd2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+119,0,"iss_instr2_prs1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+120,0,"iss_instr2_prs2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+121,0,"iss_immediate2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBus(c+122,0,"iss_alu_operation2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+123,0,"iss_branch_tag2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+124,0,"iss_branch_mask2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+125,0,"iss_biq_address2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+126,0,"iss_rob_index2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBit(c+127,0,"id_stall_frontend",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+128,0,"rn_stall_frontend",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+129,0,"dis_stall_frontend",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+130,0,"if_predecode_instr1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+131,0,"if_predecode_instr2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+590,0,"if_target_address",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+132,0,"spec_return_address",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+133,0,"pd_valid1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+134,0,"pd_valid2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+135,0,"pd_pc",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+136,0,"pd_pred_target1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+591,0,"pd_pred_target2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+137,0,"pd_pred_taken1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+592,0,"pd_pred_taken2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+138,0,"pd_btb_hit1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+593,0,"pd_btb_hit2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+139,0,"pd_pht_index1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+594,0,"pd_pht_index2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+140,0,"pd_sp_snap",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declQuad(c+141,0,"pd_ras_snap",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBus(c+143,0,"pd_prev_ghr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBit(c+144,0,"if_valid1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+145,0,"if_valid2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+146,0,"if_pc",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 29,0);
    tracep->declBus(c+147,0,"if_instr1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+148,0,"if_instr2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+149,0,"if_pred_target1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+595,0,"if_pred_target2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+150,0,"if_pred_taken1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+596,0,"if_pred_taken2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+151,0,"if_btb_hit1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+597,0,"if_btb_hit2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+152,0,"if_pht_index1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+598,0,"if_pht_index2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+153,0,"if_sp_snap",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declQuad(c+154,0,"if_ras_snap",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBus(c+156,0,"if_prev_ghr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBit(c+157,0,"id_take_snap",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+158,0,"id_valid1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+159,0,"id_valid2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+160,0,"id_pc",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 29,0);
    tracep->declBus(c+161,0,"id_biq_address",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+162,0,"id_alu_operation1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+163,0,"id_alu_operation2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBit(c+164,0,"id_is_m_extension1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+165,0,"id_is_m_extension2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+166,0,"id_rs1_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+167,0,"id_rs2_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+168,0,"id_rd_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+169,0,"id_rs1_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+170,0,"id_rs2_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+171,0,"id_rd_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBit(c+172,0,"id_jump_reg1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+173,0,"id_jump1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+174,0,"id_branch1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+175,0,"id_regsrc1_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+176,0,"id_regsrc2_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+177,0,"id_immtype1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+178,0,"id_memwrite1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+179,0,"id_regwrite1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+180,0,"id_memtoreg1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+181,0,"id_retaddr1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+182,0,"id_isimm1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+183,0,"id_upperimm1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+184,0,"id_immout1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBit(c+185,0,"id_jump_reg2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+186,0,"id_jump2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+187,0,"id_branch2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+188,0,"id_regsrc1_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+189,0,"id_regsrc2_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+190,0,"id_immtype2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+191,0,"id_memwrite2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+192,0,"id_regwrite2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+193,0,"id_memtoreg2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+194,0,"id_retaddr2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+195,0,"id_isimm2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+196,0,"id_upperimm2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+197,0,"id_immout2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBus(c+198,0,"rn_prd1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+199,0,"rn_prs1_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+200,0,"rn_prs2_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+201,0,"rn_old_prd1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+202,0,"rn_prd2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+203,0,"rn_prs1_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+204,0,"rn_prs2_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+205,0,"rn_old_prd2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBit(c+206,0,"rn_prs1_busy1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+207,0,"rn_prs2_busy1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+208,0,"rn_prs1_busy2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+209,0,"rn_prs2_busy2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+210,0,"rn_branch_tag",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+211,0,"rn_branch_mask",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+212,0,"rn_biq_address",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+213,0,"rn_pc",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 29,0);
    tracep->declBus(c+214,0,"rn_rd_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+215,0,"rn_rd_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+216,0,"rn_immout1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBus(c+217,0,"rn_immout2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBit(c+218,0,"rn_is_m_extension1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+219,0,"rn_is_m_extension2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+220,0,"rn_alu_operation1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+221,0,"rn_alu_operation2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBit(c+222,0,"rn_valid1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+223,0,"rn_jump_reg1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+224,0,"rn_jump1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+225,0,"rn_branch1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+226,0,"rn_regsrc1_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+227,0,"rn_regsrc2_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+228,0,"rn_immtype1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+229,0,"rn_isimm1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+230,0,"rn_retaddr1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+231,0,"rn_upperimm1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+232,0,"rn_regwrite1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+233,0,"rn_memwrite1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+234,0,"rn_memtoreg1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+235,0,"rn_valid2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+236,0,"rn_jump_reg2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+237,0,"rn_jump2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+238,0,"rn_branch2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+239,0,"rn_regsrc1_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+240,0,"rn_regsrc2_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+241,0,"rn_immtype2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+242,0,"rn_isimm2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+243,0,"rn_retaddr2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+244,0,"rn_upperimm2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+245,0,"rn_regwrite2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+246,0,"rn_memwrite2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+247,0,"rn_memtoreg2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->pushPrefix("dis_stage_inst", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+572,0,"XLEN",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+578,0,"PRF_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+577,0,"BIQ_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+581,0,"ROB_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+576,0,"INIT_IMMEDIATE_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+578,0,"ROB_PTR_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+579,0,"MAX_BRANCHES",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+580,0,"BTAG_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+565,0,"CLK",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+1,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+2,0,"flush",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+13,0,"branch_mispredicted",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+63,0,"stall_frontend",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+17,0,"cdb_done1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+18,0,"cdb_done2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+19,0,"cdb_wakeup1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+20,0,"cdb_wakeup2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+21,0,"cdb_branch_resolved",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+22,0,"cdb_branch_correct",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+25,0,"cdb_waked_reg1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+26,0,"cdb_waked_reg2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+29,0,"cdb_branch_tag",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+30,0,"cdb_rob_index1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+31,0,"cdb_rob_index2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+198,0,"rn_prd1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+199,0,"rn_prs1_1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+200,0,"rn_prs2_1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+201,0,"rn_old_prd1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+202,0,"rn_prd2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+203,0,"rn_prs1_2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+204,0,"rn_prs2_2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+205,0,"rn_old_prd2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBit(c+206,0,"rn_prs1_busy1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+207,0,"rn_prs2_busy1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+208,0,"rn_prs1_busy2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+209,0,"rn_prs2_busy2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+210,0,"rn_branch_tag",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+211,0,"rn_branch_mask",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+212,0,"rn_biq_address",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+213,0,"rn_pc",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 29,0);
    tracep->declBus(c+214,0,"rn_rd_1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+215,0,"rn_rd_2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+216,0,"rn_immout1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBus(c+217,0,"rn_immout2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBit(c+218,0,"rn_is_m_extension1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+219,0,"rn_is_m_extension2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+220,0,"rn_alu_operation1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+221,0,"rn_alu_operation2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBit(c+222,0,"rn_valid1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+223,0,"rn_jump_reg1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+224,0,"rn_jump1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+225,0,"rn_branch1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+226,0,"rn_regsrc1_1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+227,0,"rn_regsrc2_1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+228,0,"rn_immtype1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+229,0,"rn_isimm1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+230,0,"rn_retaddr1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+231,0,"rn_upperimm1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+232,0,"rn_regwrite1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+233,0,"rn_memwrite1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+234,0,"rn_memtoreg1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+235,0,"rn_valid2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+236,0,"rn_jump_reg2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+237,0,"rn_jump2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+238,0,"rn_branch2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+239,0,"rn_regsrc1_2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+240,0,"rn_regsrc2_2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+241,0,"rn_immtype2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+242,0,"rn_isimm2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+243,0,"rn_retaddr2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+244,0,"rn_upperimm2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+245,0,"rn_regwrite2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+246,0,"rn_memwrite2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+247,0,"rn_memtoreg2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+32,0,"cdb_branch_rob_index",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBit(c+129,0,"dis_stall_frontend",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+71,0,"commit_instr1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+72,0,"commit_instr2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+73,0,"dis_free_old_prd1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+74,0,"dis_free_old_prd2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+75,0,"comm_prd1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+76,0,"comm_prd2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+77,0,"comm_rd1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+78,0,"comm_rd2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBit(c+79,0,"iss_valid1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+80,0,"iss_is_m_extension1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+81,0,"iss_jump_reg1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+82,0,"iss_jump1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+83,0,"iss_branch1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+84,0,"iss_instr1_regsrc1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+85,0,"iss_instr1_regsrc2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+86,0,"iss_immtype1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+87,0,"iss_isimm1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+88,0,"iss_retaddr1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+89,0,"iss_upperimm1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+90,0,"iss_regwrite1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+91,0,"iss_memwrite1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+92,0,"iss_memtoreg1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+93,0,"iss_pc1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 29,0);
    tracep->declBus(c+94,0,"iss_prd1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+95,0,"iss_instr1_prs1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+96,0,"iss_instr1_prs2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+97,0,"iss_immediate1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBus(c+98,0,"iss_alu_operation1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+99,0,"iss_branch_tag1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+100,0,"iss_branch_mask1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+101,0,"iss_biq_address1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+102,0,"iss_rob_index1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBit(c+103,0,"iss_valid2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+104,0,"iss_is_m_extension2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+105,0,"iss_jump_reg2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+106,0,"iss_jump2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+107,0,"iss_branch2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+108,0,"iss_instr2_regsrc1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+109,0,"iss_instr2_regsrc2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+110,0,"iss_immtype2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+111,0,"iss_isimm2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+112,0,"iss_retaddr2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+113,0,"iss_upperimm2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+114,0,"iss_regwrite2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+115,0,"iss_memwrite2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+116,0,"iss_memtoreg2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+117,0,"iss_pc2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 29,0);
    tracep->declBus(c+118,0,"iss_prd2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+119,0,"iss_instr2_prs1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+120,0,"iss_instr2_prs2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+121,0,"iss_immediate2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBus(c+122,0,"iss_alu_operation2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+123,0,"iss_branch_tag2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+124,0,"iss_branch_mask2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+125,0,"iss_biq_address2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+126,0,"iss_rob_index2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBit(c+248,0,"rob_full",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+249,0,"iq_full",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+250,0,"current_rob_index",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->pushPrefix("iq_instantiation", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+572,0,"XLEN",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+578,0,"PRF_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+576,0,"INIT_IMMEDIATE_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+579,0,"MAX_BRANCHES",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+580,0,"BTAG_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+577,0,"BIQ_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+581,0,"IQ_ROWS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+578,0,"IQ_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+581,0,"ROB_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+578,0,"ROB_PTR_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+565,0,"CLK",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+1,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+248,0,"rob_full",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+2,0,"flush",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+19,0,"cdb_wakeup1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+20,0,"cdb_wakeup2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+21,0,"cdb_branch_resolved",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+22,0,"cdb_branch_correct",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+198,0,"rn_prd1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+199,0,"rn_prs1_1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+200,0,"rn_prs2_1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+25,0,"cdb_waked_reg1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+26,0,"cdb_waked_reg2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+202,0,"rn_prd2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+203,0,"rn_prs1_2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+204,0,"rn_prs2_2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBit(c+206,0,"rn_prs1_busy1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+207,0,"rn_prs2_busy1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+208,0,"rn_prs1_busy2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+209,0,"rn_prs2_busy2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+210,0,"rn_branch_tag",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+29,0,"cdb_branch_tag",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+211,0,"rn_branch_mask",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+212,0,"rn_biq_address",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+213,0,"rn_pc",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 29,0);
    tracep->declBus(c+216,0,"rn_immout1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBus(c+217,0,"rn_immout2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBus(c+220,0,"rn_alu_operation1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+221,0,"rn_alu_operation2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBit(c+218,0,"rn_is_m_extension1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+219,0,"rn_is_m_extension2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+222,0,"rn_valid1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+223,0,"rn_jump_reg1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+224,0,"rn_jump1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+225,0,"rn_branch1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+226,0,"rn_regsrc1_1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+227,0,"rn_regsrc2_1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+228,0,"rn_immtype1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+229,0,"rn_isimm1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+230,0,"rn_retaddr1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+231,0,"rn_upperimm1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+232,0,"rn_regwrite1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+233,0,"rn_memwrite1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+234,0,"rn_memtoreg1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+235,0,"rn_valid2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+236,0,"rn_jump_reg2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+237,0,"rn_jump2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+238,0,"rn_branch2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+239,0,"rn_regsrc1_2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+240,0,"rn_regsrc2_2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+241,0,"rn_immtype2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+242,0,"rn_isimm2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+243,0,"rn_retaddr2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+244,0,"rn_upperimm2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+245,0,"rn_regwrite2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+246,0,"rn_memwrite2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+247,0,"rn_memtoreg2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+250,0,"current_rob_index",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBit(c+249,0,"iq_full",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+79,0,"iss_valid1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+80,0,"iss_is_m_extension1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+81,0,"iss_jump_reg1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+82,0,"iss_jump1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+83,0,"iss_branch1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+84,0,"iss_instr1_regsrc1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+85,0,"iss_instr1_regsrc2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+86,0,"iss_immtype1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+87,0,"iss_isimm1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+88,0,"iss_retaddr1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+89,0,"iss_upperimm1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+90,0,"iss_regwrite1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+91,0,"iss_memwrite1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+92,0,"iss_memtoreg1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+93,0,"iss_pc1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 29,0);
    tracep->declBus(c+94,0,"iss_prd1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+95,0,"iss_instr1_prs1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+96,0,"iss_instr1_prs2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+97,0,"iss_immediate1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBus(c+98,0,"iss_alu_operation1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+99,0,"iss_branch_tag1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+100,0,"iss_branch_mask1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+101,0,"iss_biq_address1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+102,0,"iss_rob_index1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBit(c+103,0,"iss_valid2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+104,0,"iss_is_m_extension2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+105,0,"iss_jump_reg2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+106,0,"iss_jump2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+107,0,"iss_branch2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+108,0,"iss_instr2_regsrc1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+109,0,"iss_instr2_regsrc2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+110,0,"iss_immtype2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+111,0,"iss_isimm2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+112,0,"iss_retaddr2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+113,0,"iss_upperimm2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+114,0,"iss_regwrite2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+115,0,"iss_memwrite2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+116,0,"iss_memtoreg2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+117,0,"iss_pc2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 29,0);
    tracep->declBus(c+118,0,"iss_prd2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+119,0,"iss_instr2_prs1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+120,0,"iss_instr2_prs2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+121,0,"iss_immediate2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBus(c+122,0,"iss_alu_operation2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+123,0,"iss_branch_tag2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+124,0,"iss_branch_mask2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+125,0,"iss_biq_address2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+126,0,"iss_rob_index2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+251,0,"iq_alloc_index1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+252,0,"iq_alloc_index2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBit(c+253,0,"alloc1_found",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+254,0,"alloc2_found",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+255,0,"fast_wakeup1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+256,0,"fast_wakeup2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+257,0,"fast_waked_reg1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+258,0,"fast_waked_reg2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+259,0,"issue_index1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+260,0,"issue_index2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBit(c+261,0,"is_control_flow_instr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+262,0,"issue1_found",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+263,0,"issue2_found",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->pushPrefix("unnamedblk1", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+599,0,"i",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INT, false,-1, 31,0);
    tracep->popPrefix();
    tracep->pushPrefix("unnamedblk2", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+264,0,"i",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INT, false,-1, 31,0);
    tracep->popPrefix();
    tracep->pushPrefix("unnamedblk3", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+265,0,"i",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INT, false,-1, 31,0);
    tracep->popPrefix();
    tracep->pushPrefix("unnamedblk4", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+599,0,"i",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INT, false,-1, 31,0);
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->pushPrefix("rob_instantiation", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+578,0,"PRF_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+581,0,"ROB_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+578,0,"ROB_PTR_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+565,0,"CLK",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+1,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+63,0,"stall_frontend",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+13,0,"branch_mispredicted",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+222,0,"rn_valid1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+235,0,"rn_valid2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+17,0,"cdb_done1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+18,0,"cdb_done2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+214,0,"rn_rd1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+215,0,"rn_rd2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+198,0,"rn_prd1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+202,0,"rn_prd2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+201,0,"rn_old_prd1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+205,0,"rn_old_prd2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+30,0,"cdb_rob_index1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+31,0,"cdb_rob_index2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+32,0,"cdb_branch_rob_index",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBit(c+248,0,"rob_full",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+71,0,"commit_instr1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+72,0,"commit_instr2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+250,0,"current_rob_index",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+73,0,"dis_free_old_prd1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+74,0,"dis_free_old_prd2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+75,0,"comm_prd1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+76,0,"comm_prd2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+77,0,"comm_rd1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+78,0,"comm_rd2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+266,0,"rob_head_ptr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+267,0,"rob_tail_ptr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+268,0,"rob_count",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBit(c+71,0,"completed1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+72,0,"completed2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+566,0,"branch_wrap_bit",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->pushPrefix("id_stage_inst", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+573,0,"OPCODE_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+574,0,"PHT_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+574,0,"GHR_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+572,0,"XLEN",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+575,0,"RAS_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+576,0,"INIT_IMMEDIATE_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+577,0,"BIQ_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+565,0,"CLK",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+1,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+2,0,"flush",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+14,0,"dis_biq_dealloc",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+150,0,"if_pred_taken",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+63,0,"stall_frontend",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+144,0,"if_valid1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+145,0,"if_valid2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+147,0,"if_instr1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+148,0,"if_instr2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+149,0,"if_pred_target",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+146,0,"if_pc",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 29,0);
    tracep->declBus(c+15,0,"rr_biq_id",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+152,0,"if_pht_index",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+153,0,"if_sp_snap",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declQuad(c+154,0,"if_ras_snap",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBus(c+156,0,"if_prev_ghr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+68,0,"id_biq_sp_snap",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declQuad(c+69,0,"id_biq_ras_snap",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBit(c+127,0,"id_stall_frontend",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+157,0,"id_take_snap",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+158,0,"id_valid1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+159,0,"id_valid2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+166,0,"id_rs1_1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+167,0,"id_rs2_1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+168,0,"id_rd_1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+169,0,"id_rs1_2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+170,0,"id_rs2_2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+171,0,"id_rd_2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+184,0,"id_immout1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBus(c+197,0,"id_immout2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBus(c+161,0,"id_biq_address",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+65,0,"id_biq_pred_target",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+160,0,"id_pc",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 29,0);
    tracep->declBus(c+67,0,"id_biq_restore_ghr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+66,0,"id_biq_pht_index",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+162,0,"id_alu_operation1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+163,0,"id_alu_operation2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBit(c+164,0,"id_is_m_extension1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+165,0,"id_is_m_extension2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+172,0,"id_jump_reg1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+185,0,"id_jump_reg2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+173,0,"id_jump1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+186,0,"id_jump2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+174,0,"id_branch1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+187,0,"id_branch2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+175,0,"id_regsrc1_1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+177,0,"id_immtype1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+178,0,"id_memwrite1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+190,0,"id_immtype2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+589,0,"id_biq_valid",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+64,0,"id_biq_pred_taken",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+176,0,"id_regsrc2_1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+188,0,"id_regsrc1_2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+189,0,"id_regsrc2_2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+183,0,"id_upperimm1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+196,0,"id_upperimm2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+179,0,"id_regwrite1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+192,0,"id_regwrite2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+191,0,"id_memwrite2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+180,0,"id_memtoreg1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+193,0,"id_memtoreg2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+181,0,"id_retaddr1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+194,0,"id_retaddr2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+182,0,"id_isimm1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+195,0,"id_isimm2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+269,0,"opcode_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+270,0,"opcode_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+271,0,"ALUOp_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBus(c+272,0,"ALUOp_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBus(c+273,0,"imm_out1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBus(c+274,0,"imm_out2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBus(c+275,0,"alu_operation1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+276,0,"alu_operation2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBit(c+277,0,"is_control_flow_instr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+278,0,"is_m_extension1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+279,0,"is_m_extension2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+280,0,"JumpReg_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+281,0,"JumpReg_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+282,0,"Jump_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+283,0,"Jump_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+284,0,"Branch_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+285,0,"Branch_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+286,0,"RegSrc1_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+287,0,"RegSrc2_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+288,0,"RegSrc1_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+289,0,"RegSrc2_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+290,0,"RetAddr_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+291,0,"UpperImm_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+292,0,"UpperImm_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+293,0,"RegWrite_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+294,0,"RegWrite_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+295,0,"MemWrite_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+296,0,"MemWrite_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+297,0,"MemToReg_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+298,0,"MemToReg_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+299,0,"RetAddr_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+300,0,"Imm_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+301,0,"Imm_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+302,0,"imm_type1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+303,0,"imm_type2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->pushPrefix("alucu_instantiation1", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+271,0,"ALUOp",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBus(c+304,0,"func3",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBus(c+305,0,"func7",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+275,0,"ALUOperation",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->popPrefix();
    tracep->pushPrefix("alucu_instantiation2", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+272,0,"ALUOp",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBus(c+306,0,"func3",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBus(c+307,0,"func7",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+276,0,"ALUOperation",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->popPrefix();
    tracep->pushPrefix("biq_instantiation", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+577,0,"BIQ_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+572,0,"XLEN",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+574,0,"PHT_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+574,0,"GHR_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+575,0,"RAS_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+565,0,"CLK",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+1,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+14,0,"biq_dealloc",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+2,0,"flush",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+277,0,"biq_alloc",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+150,0,"pred_taken",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+149,0,"pred_target",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+15,0,"biq_id",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+152,0,"pht_index",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+156,0,"prev_ghr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+153,0,"sp_snap",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declQuad(c+154,0,"ras_snap",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBit(c+64,0,"biq_pred_taken",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+127,0,"stall_frontend",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+161,0,"biq_address",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+65,0,"biq_pred_target",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+67,0,"biq_restore_ghr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+68,0,"biq_sp_snap",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declQuad(c+69,0,"biq_ras_snap",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBus(c+66,0,"biq_pht_index",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->pushPrefix("BIQ", VerilatedTracePrefixType::ARRAY_UNPACKED);
    tracep->declArray(c+308,0,"[0]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+312,0,"[1]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+316,0,"[2]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+320,0,"[3]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+324,0,"[4]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+328,0,"[5]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+332,0,"[6]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+336,0,"[7]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+340,0,"[8]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+344,0,"[9]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+348,0,"[10]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+352,0,"[11]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+356,0,"[12]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+360,0,"[13]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+364,0,"[14]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+368,0,"[15]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+372,0,"[16]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+376,0,"[17]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+380,0,"[18]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+384,0,"[19]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+388,0,"[20]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+392,0,"[21]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+396,0,"[22]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+400,0,"[23]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+404,0,"[24]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+408,0,"[25]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+412,0,"[26]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+416,0,"[27]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+420,0,"[28]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+424,0,"[29]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+428,0,"[30]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->declArray(c+432,0,"[31]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 117,0);
    tracep->popPrefix();
    tracep->declBus(c+15,0,"biq_read_address",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+436,0,"biq_head_ptr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+437,0,"biq_tail_ptr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBit(c+127,0,"biq_full",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->popPrefix();
    tracep->pushPrefix("cu_instantiation1", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+573,0,"OPCODE_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+269,0,"opcode",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+305,0,"funct7",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+271,0,"ALUOp",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBit(c+278,0,"is_m_extension",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+280,0,"JumpReg",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+282,0,"Jump",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+284,0,"Branch",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+286,0,"RegSrc1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+287,0,"RegSrc2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+291,0,"UpperImm",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+293,0,"RegWrite",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+295,0,"MemWrite",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+297,0,"MemToReg",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+290,0,"RetAddr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+300,0,"imm",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->popPrefix();
    tracep->pushPrefix("cu_instantiation2", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+573,0,"OPCODE_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+270,0,"opcode",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+307,0,"funct7",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+272,0,"ALUOp",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBit(c+279,0,"is_m_extension",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+281,0,"JumpReg",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+283,0,"Jump",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+285,0,"Branch",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+288,0,"RegSrc1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+289,0,"RegSrc2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+292,0,"UpperImm",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+294,0,"RegWrite",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+296,0,"MemWrite",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+298,0,"MemToReg",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+299,0,"RetAddr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+301,0,"imm",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->popPrefix();
    tracep->pushPrefix("ig_instantiation1", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+572,0,"XLEN",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+573,0,"OPCODE_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+576,0,"INIT_IMMEDIATE_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+147,0,"instruction",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+273,0,"immediate_output",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBit(c+302,0,"imm_type",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+438,0,"opcode",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->popPrefix();
    tracep->pushPrefix("ig_instantiation2", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+572,0,"XLEN",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+573,0,"OPCODE_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+576,0,"INIT_IMMEDIATE_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+148,0,"instruction",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+274,0,"immediate_output",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBit(c+303,0,"imm_type",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+439,0,"opcode",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->pushPrefix("if_stage_inst", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+574,0,"PHT_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+574,0,"GHR_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+572,0,"XLEN",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+575,0,"RAS_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+565,0,"CLK",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+1,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+2,0,"flush",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+133,0,"pd_valid1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+134,0,"pd_valid2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+63,0,"stall_frontend",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+137,0,"pd_pred_taken",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+138,0,"pd_btb_hit",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+135,0,"pd_pc",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+136,0,"pd_pred_target",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+139,0,"pd_pht_index",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+140,0,"pd_sp_snap",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declQuad(c+141,0,"pd_ras_snap",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBus(c+143,0,"pd_prev_ghr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBit(c+150,0,"if_pred_taken",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+151,0,"if_btb_hit",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+144,0,"if_valid1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+145,0,"if_valid2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+130,0,"if_predecode_instr1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+131,0,"if_predecode_instr2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+147,0,"if_instr1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+148,0,"if_instr2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+149,0,"if_pred_target",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+146,0,"if_pc",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 29,0);
    tracep->declBus(c+152,0,"if_pht_index",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+153,0,"if_sp_snap",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declQuad(c+154,0,"if_ras_snap",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBus(c+156,0,"if_prev_ghr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+440,0,"instr1_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 29,0);
    tracep->declBus(c+441,0,"instr2_addr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 29,0);
    tracep->pushPrefix("im_instantiation", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+572,0,"XLEN",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+600,0,"MEM_ROWS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+565,0,"CLK",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+442,0,"instr1_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+443,0,"instr2_addr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+147,0,"instr_1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+148,0,"instr_2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->popPrefix();
    tracep->pushPrefix("predecode_instantiation", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+269,0,"opcode1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+270,0,"opcode2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 6,0);
    tracep->declBus(c+444,0,"rd1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+445,0,"rd2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+130,0,"predecode_instr1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+131,0,"predecode_instr2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->pushPrefix("pd_stage_inst", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+574,0,"PHT_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+574,0,"GHR_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+572,0,"XLEN",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+575,0,"RAS_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+565,0,"CLK",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+1,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+63,0,"stall_frontend",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+3,0,"ex_actual_taken",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+5,0,"restore_ghr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+6,0,"restore_ras",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+7,0,"update_pht",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+12,0,"ex_is_jalr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+10,0,"ex_is_ret",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+11,0,"ex_is_branch",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+4,0,"flush",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+130,0,"if_predecode_instr1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+131,0,"if_predecode_instr2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+582,0,"ex_actual_target_address",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+590,0,"if_target_address",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+135,0,"if_pc",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+583,0,"ex_pc",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+584,0,"ghr_snap",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+585,0,"rb_pht_index",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+586,0,"rb_sp_snap",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declQuad(c+587,0,"rb_ras_snap",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBit(c+137,0,"pd_pred_taken",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+138,0,"pd_btb_hit",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+133,0,"pd_valid1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+134,0,"pd_valid2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+135,0,"pd_pc",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+136,0,"pd_pred_target",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+139,0,"pd_pht_index",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+140,0,"pd_sp_snap",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declQuad(c+141,0,"pd_ras_snap",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBus(c+143,0,"pd_prev_ghr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+446,0,"ghr_out",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+446,0,"prev_ghr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+447,0,"pht_index",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBit(c+448,0,"pred_taken",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+449,0,"btb_hit",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+450,0,"btb_is_branch",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+451,0,"is_return_instr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+452,0,"squash_instruction",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+453,0,"pred_return_address",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+454,0,"pred_target_address",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+455,0,"sp_snap",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declQuad(c+456,0,"ras_snap",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBus(c+458,0,"next_pc",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->pushPrefix("btb_instantiation", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+581,0,"BTB_ROWS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+572,0,"XLEN",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+578,0,"BTB_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+601,0,"TAG_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+565,0,"CLK",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+1,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+459,0,"if_is_jal1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+460,0,"if_is_jal2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+3,0,"ex_is_taken_branch",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+12,0,"ex_is_jalr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+33,0,"ex_is_not_ret",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+135,0,"pd_pc",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+135,0,"if_pc",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+583,0,"ex_pc",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+602,0,"ex_target_address",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 29,0);
    tracep->declBus(c+603,0,"if_target_address",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 29,0);
    tracep->declBit(c+449,0,"btb_hit",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+452,0,"squash_instruction",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+450,0,"btb_is_branch",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+454,0,"pred_target_address",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+461,0,"pd_tag",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 22,0);
    tracep->declBus(c+461,0,"if_tag",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 22,0);
    tracep->declBus(c+604,0,"ex_tag",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 22,0);
    tracep->declBus(c+462,0,"btb_read_address",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+605,0,"ex_btb_write_address",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+462,0,"if_btb_write_address",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->pushPrefix("unnamedblk1", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+463,0,"i",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INT, false,-1, 31,0);
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->pushPrefix("ghr_instantiation", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+574,0,"GHR_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+565,0,"CLK",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+1,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+63,0,"stall_frontend",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+5,0,"restore_ghr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+3,0,"ex_actual_taken",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+11,0,"ex_is_branch",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+584,0,"ghr_snap",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+446,0,"ghr_out",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+446,0,"prev_ghr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBit(c+606,0,"pred_taken",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->popPrefix();
    tracep->pushPrefix("pc_instantiation", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+572,0,"XLEN",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+565,0,"CLK",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+1,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+4,0,"flush",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+63,0,"stall_frontend",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+451,0,"is_return_instr",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+449,0,"btb_hit",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+448,0,"pht_pred_taken",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+450,0,"btb_is_branch",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+453,0,"ras_target_address",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+454,0,"btb_target_address",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+582,0,"ex_actual_target_address",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+458,0,"next_pc",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->popPrefix();
    tracep->pushPrefix("pht_instantiation", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+574,0,"PHT_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+580,0,"COUNTER_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+565,0,"CLK",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+1,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+3,0,"ex_actual_taken",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+7,0,"update_pht",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+447,0,"pht_index",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBus(c+585,0,"rb_pht_index",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 8,0);
    tracep->declBit(c+448,0,"pred_taken",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->popPrefix();
    tracep->pushPrefix("ras_instantiation", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+575,0,"RAS_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+572,0,"XLEN",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+607,0,"RAS_LEN",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+565,0,"CLK",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+1,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+63,0,"stall_frontend",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+6,0,"restore_ras",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+130,0,"if_predecode_instr1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+131,0,"if_predecode_instr2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+590,0,"if_actual_return_address",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+586,0,"rb_sp_snap",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declQuad(c+587,0,"rb_ras_snap",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBit(c+451,0,"is_return_instr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+453,0,"pred_return_address",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+455,0,"sp_snap",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declQuad(c+456,0,"ras_snap",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->pushPrefix("RAS", VerilatedTracePrefixType::ARRAY_UNPACKED);
    for (int i = 0; i < 8; ++i) {
        tracep->declBus(c+464+i*1,0,"",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, true,(i+0), 31,0);
    }
    tracep->popPrefix();
    tracep->declBus(c+472,0,"sp",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBus(c+473,0,"next_sp",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 2,0);
    tracep->declBit(c+451,0,"pop",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+474,0,"push",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+475,0,"if_is_call1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+476,0,"if_is_call2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+477,0,"if_is_ret1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+478,0,"if_is_ret2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->pushPrefix("rn_stage_inst", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+578,0,"PRF_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+576,0,"INIT_IMMEDIATE_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+579,0,"MAX_BRANCHES",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+580,0,"BTAG_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+577,0,"BIQ_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+572,0,"XLEN",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+581,0,"NUM_PHY_REG",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+572,0,"FL_ROWS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+577,0,"FL_INDEX_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+578,0,"FL_PTR_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+565,0,"CLK",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+1,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+2,0,"flush",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+157,0,"id_take_snap",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+158,0,"id_valid1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+159,0,"id_valid2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+63,0,"stall_frontend",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+19,0,"cdb_wakeup1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+20,0,"cdb_wakeup2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+23,0,"comm_free_push1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+24,0,"comm_free_push2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+21,0,"cdb_branch_resolved",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+164,0,"id_is_m_extension1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+165,0,"id_is_m_extension2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+172,0,"id_jump_reg1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+185,0,"id_jump_reg2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+173,0,"id_jump1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+186,0,"id_jump2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+174,0,"id_branch1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+187,0,"id_branch2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+175,0,"id_regsrc1_1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+177,0,"id_immtype1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+178,0,"id_memwrite1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+190,0,"id_immtype2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+176,0,"id_regsrc2_1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+188,0,"id_regsrc1_2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+189,0,"id_regsrc2_2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+183,0,"id_upperimm1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+196,0,"id_upperimm2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+179,0,"id_regwrite1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+192,0,"id_regwrite2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+191,0,"id_memwrite2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+180,0,"id_memtoreg1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+193,0,"id_memtoreg2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+181,0,"id_retaddr1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+194,0,"id_retaddr2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+182,0,"id_isimm1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+195,0,"id_isimm2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+25,0,"cdb_waked_reg1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+26,0,"cdb_waked_reg2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+27,0,"comm_free_reg1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+28,0,"comm_free_reg2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+29,0,"cdb_branch_tag",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+166,0,"id_rs1_1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+167,0,"id_rs2_1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+168,0,"id_rd_1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+169,0,"id_rs1_2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+170,0,"id_rs2_2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+171,0,"id_rd_2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+184,0,"id_immout1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBus(c+197,0,"id_immout2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBus(c+161,0,"id_biq_address",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+160,0,"id_pc",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 29,0);
    tracep->declBus(c+162,0,"id_alu_operation1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+163,0,"id_alu_operation2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBit(c+128,0,"rn_stall_frontend",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+198,0,"rn_prd1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+199,0,"rn_prs1_1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+200,0,"rn_prs2_1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+201,0,"rn_old_prd1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+202,0,"rn_prd2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+203,0,"rn_prs1_2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+204,0,"rn_prs2_2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+205,0,"rn_old_prd2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBit(c+206,0,"rn_prs1_busy1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+207,0,"rn_prs2_busy1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+208,0,"rn_prs1_busy2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+209,0,"rn_prs2_busy2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+210,0,"rn_branch_tag",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+211,0,"rn_branch_mask",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+212,0,"rn_biq_address",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+213,0,"rn_pc",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 29,0);
    tracep->declBus(c+214,0,"rn_rd_1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+215,0,"rn_rd_2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+216,0,"rn_immout1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBus(c+217,0,"rn_immout2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 20,0);
    tracep->declBit(c+218,0,"rn_is_m_extension1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+219,0,"rn_is_m_extension2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+220,0,"rn_alu_operation1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+221,0,"rn_alu_operation2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBit(c+222,0,"rn_valid1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+223,0,"rn_jump_reg1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+224,0,"rn_jump1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+225,0,"rn_branch1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+226,0,"rn_regsrc1_1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+227,0,"rn_regsrc2_1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+228,0,"rn_immtype1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+229,0,"rn_isimm1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+230,0,"rn_retaddr1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+231,0,"rn_upperimm1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+232,0,"rn_regwrite1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+233,0,"rn_memwrite1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+234,0,"rn_memtoreg1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+235,0,"rn_valid2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+236,0,"rn_jump_reg2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+237,0,"rn_jump2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+238,0,"rn_branch2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+239,0,"rn_regsrc1_2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+240,0,"rn_regsrc2_2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+241,0,"rn_immtype2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+242,0,"rn_isimm2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+243,0,"rn_retaddr2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+244,0,"rn_upperimm2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+245,0,"rn_regwrite2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+246,0,"rn_memwrite2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+247,0,"rn_memtoreg2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+479,0,"fl_freed_reg1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+480,0,"fl_freed_reg2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declArray(c+34,0,"rmt_snap",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 191,0);
    tracep->declArray(c+40,0,"bs_rmt_snap",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 191,0);
    tracep->declBus(c+46,0,"fl_head_ptr",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+47,0,"bs_head_ptr_snap",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+479,0,"routed_freed_reg1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+481,0,"routed_freed_reg2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBit(c+482,0,"pop1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+483,0,"pop2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+484,0,"bs_full",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+485,0,"fl_empty",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->pushPrefix("bs_instantiation", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+578,0,"PRF_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+581,0,"NUM_PHY_REG",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+579,0,"MAX_BRANCHES",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+580,0,"BTAG_SIZE",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+572,0,"FL_ROWS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+577,0,"FL_INDEX_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+578,0,"FL_PTR_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+565,0,"CLK",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+1,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+2,0,"flush",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+48,0,"id_take_snap",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+21,0,"cdb_branch_resolved",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+486,0,"pop1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+487,0,"pop2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+174,0,"id_branch1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+173,0,"id_jump1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+158,0,"id_valid1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+29,0,"cdb_branch_tag",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declArray(c+34,0,"rmt_snap",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 191,0);
    tracep->declBus(c+46,0,"freelist_head_snap",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBit(c+484,0,"bs_full",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declArray(c+40,0,"bs_rmt_snap",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 191,0);
    tracep->declBus(c+47,0,"bs_freelist_head_snap",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+210,0,"bs_branch_tag",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->declBus(c+211,0,"bs_branch_mask",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->pushPrefix("BS", VerilatedTracePrefixType::ARRAY_UNPACKED);
    tracep->declArray(c+488,0,"[0]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 201,0);
    tracep->declArray(c+495,0,"[1]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 201,0);
    tracep->declArray(c+502,0,"[2]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 201,0);
    tracep->declArray(c+509,0,"[3]",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 201,0);
    tracep->popPrefix();
    tracep->declBus(c+211,0,"BMR",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 3,0);
    tracep->declBus(c+210,0,"current_btag",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 1,0);
    tracep->pushPrefix("unnamedblk1", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+516,0,"i",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INT, false,-1, 31,0);
    tracep->popPrefix();
    tracep->pushPrefix("unnamedblk2", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+517,0,"i",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INT, false,-1, 31,0);
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->pushPrefix("fl_instantiation", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+578,0,"PRF_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+581,0,"NUM_PHY_REG",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+572,0,"FL_ROWS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+577,0,"FL_INDEX_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+578,0,"FL_PTR_WIDTH",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+565,0,"CLK",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+1,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+2,0,"flush",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+63,0,"stall_frontend",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+23,0,"push1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+24,0,"push2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+482,0,"pop1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+483,0,"pop2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+174,0,"id_branch1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+173,0,"id_jump1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+158,0,"id_valid1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+27,0,"comm_free_reg1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+28,0,"comm_free_reg2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+47,0,"bs_head_ptr_snap",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+479,0,"fl_freed_reg1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+480,0,"fl_freed_reg2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+46,0,"fl_head_ptr",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBit(c+485,0,"fl_empty",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->pushPrefix("FL", VerilatedTracePrefixType::ARRAY_UNPACKED);
    for (int i = 0; i < 32; ++i) {
        tracep->declBus(c+518+i*1,0,"",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, true,(i+0), 5,0);
    }
    tracep->popPrefix();
    tracep->declBus(c+550,0,"head",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+49,0,"next_head",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+551,0,"tail",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBit(c+50,0,"valid_pop1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+567,0,"valid_pop2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+552,0,"registers_required",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->pushPrefix("unnamedblk1", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+553,0,"i",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INT, false,-1, 31,0);
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->pushPrefix("rmt_instantiation", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+578,0,"PRF_ADDRESS",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBus(c+581,0,"NUM_PHY_REG",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::PARAMETER, VerilatedTraceSigType::LOGIC, false,-1, 31,0);
    tracep->declBit(c+565,0,"CLK",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+1,0,"reset",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+2,0,"restore_rmt",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+63,0,"stall_frontend",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+554,0,"reg_write1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+555,0,"reg_write2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+19,0,"cdb_wakeup1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+20,0,"cdb_wakeup2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+174,0,"id_branch1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+173,0,"id_jump1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+158,0,"id_valid1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+159,0,"id_valid2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+168,0,"rd1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+166,0,"rs1_1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+167,0,"rs2_1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+171,0,"rd2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+169,0,"rs1_2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+170,0,"rs2_2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 4,0);
    tracep->declBus(c+479,0,"fl_freed_reg1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+481,0,"fl_freed_reg2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+25,0,"cdb_waked_reg1",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+26,0,"cdb_waked_reg2",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declArray(c+40,0,"bs_rmt_snap",-1, VerilatedTraceSigDirection::INPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 191,0);
    tracep->declBit(c+206,0,"prs1_busy1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+207,0,"prs2_busy1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+208,0,"prs1_busy2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+209,0,"prs2_busy2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBus(c+198,0,"prd1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+199,0,"prs1_1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+200,0,"prs2_1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+201,0,"old_prd1",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+202,0,"prd2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+203,0,"prs1_2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+204,0,"prs2_2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declBus(c+205,0,"old_prd2",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 5,0);
    tracep->declArray(c+34,0,"rmt_snap",-1, VerilatedTraceSigDirection::OUTPUT, VerilatedTraceSigKind::WIRE, VerilatedTraceSigType::LOGIC, false,-1, 191,0);
    tracep->declArray(c+556,0,"RMT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 191,0);
    tracep->declArray(c+51,0,"next_RMT",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 191,0);
    tracep->declArray(c+57,0,"next_RMT_inst1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 191,0);
    tracep->declQuad(c+562,0,"busy_table",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1, 63,0);
    tracep->declBit(c+568,0,"wake_rs1_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+569,0,"wake_rs1_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+570,0,"wake_rs2_1",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->declBit(c+571,0,"wake_rs2_2",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::LOGIC, false,-1);
    tracep->pushPrefix("unnamedblk1", VerilatedTracePrefixType::SCOPE_MODULE);
    tracep->declBus(c+564,0,"i",-1, VerilatedTraceSigDirection::NONE, VerilatedTraceSigKind::VAR, VerilatedTraceSigType::INT, false,-1, 31,0);
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->popPrefix();
    tracep->popPrefix();
}

VL_ATTR_COLD void Vtb_main_datapath___024root__trace_init_top(Vtb_main_datapath___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_main_datapath__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_main_datapath___024root__trace_init_top\n"); );
    // Body
    Vtb_main_datapath___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vtb_main_datapath___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
VL_ATTR_COLD void Vtb_main_datapath___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vtb_main_datapath___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vtb_main_datapath___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vtb_main_datapath___024root__trace_register(Vtb_main_datapath___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_main_datapath__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_main_datapath___024root__trace_register\n"); );
    // Body
    tracep->addConstCb(&Vtb_main_datapath___024root__trace_const_0, 0U, vlSelf);
    tracep->addFullCb(&Vtb_main_datapath___024root__trace_full_0, 0U, vlSelf);
    tracep->addChgCb(&Vtb_main_datapath___024root__trace_chg_0, 0U, vlSelf);
    tracep->addCleanupCb(&Vtb_main_datapath___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vtb_main_datapath___024root__trace_const_0_sub_0(Vtb_main_datapath___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vtb_main_datapath___024root__trace_const_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_main_datapath___024root__trace_const_0\n"); );
    // Init
    Vtb_main_datapath___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_main_datapath___024root*>(voidSelf);
    Vtb_main_datapath__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vtb_main_datapath___024root__trace_const_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vtb_main_datapath___024root__trace_const_0_sub_0(Vtb_main_datapath___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_main_datapath__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_main_datapath___024root__trace_const_0_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullIData(oldp+572,(0x20U),32);
    bufp->fullIData(oldp+573,(7U),32);
    bufp->fullIData(oldp+574,(9U),32);
    bufp->fullIData(oldp+575,(3U),32);
    bufp->fullIData(oldp+576,(0x15U),32);
    bufp->fullIData(oldp+577,(5U),32);
    bufp->fullIData(oldp+578,(6U),32);
    bufp->fullIData(oldp+579,(4U),32);
    bufp->fullIData(oldp+580,(2U),32);
    bufp->fullIData(oldp+581,(0x40U),32);
    bufp->fullIData(oldp+582,(vlSelf->tb_main_datapath__DOT__actual_target_address),32);
    bufp->fullIData(oldp+583,(vlSelf->tb_main_datapath__DOT__ex_pc),32);
    bufp->fullSData(oldp+584,(vlSelf->tb_main_datapath__DOT__ghr_snap),9);
    bufp->fullSData(oldp+585,(vlSelf->tb_main_datapath__DOT__rb_pht_index),9);
    bufp->fullCData(oldp+586,(vlSelf->tb_main_datapath__DOT__rb_sp_snap),3);
    bufp->fullQData(oldp+587,(vlSelf->tb_main_datapath__DOT__rb_ras_snap),64);
    bufp->fullBit(oldp+589,(vlSelf->tb_main_datapath__DOT__id_biq_valid));
    bufp->fullIData(oldp+590,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_target_address),32);
    bufp->fullIData(oldp+591,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_pred_target2),32);
    bufp->fullBit(oldp+592,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_pred_taken2));
    bufp->fullBit(oldp+593,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_btb_hit2));
    bufp->fullSData(oldp+594,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_pht_index2),9);
    bufp->fullIData(oldp+595,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_pred_target2),32);
    bufp->fullBit(oldp+596,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_pred_taken2));
    bufp->fullBit(oldp+597,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_btb_hit2));
    bufp->fullSData(oldp+598,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_pht_index2),9);
    bufp->fullIData(oldp+599,(0x40U),32);
    bufp->fullIData(oldp+600,(0x64U),32);
    bufp->fullIData(oldp+601,(0x17U),32);
    bufp->fullIData(oldp+602,((vlSelf->tb_main_datapath__DOT__actual_target_address 
                               >> 2U)),30);
    bufp->fullIData(oldp+603,((vlSelf->tb_main_datapath__DOT__dut__DOT__if_target_address 
                               >> 2U)),30);
    bufp->fullIData(oldp+604,((vlSelf->tb_main_datapath__DOT__ex_pc 
                               >> 9U)),23);
    bufp->fullCData(oldp+605,((0x3fU & (vlSelf->tb_main_datapath__DOT__ex_pc 
                                        >> 3U))),6);
    bufp->fullBit(oldp+606,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ghr_instantiation__DOT__pred_taken));
    bufp->fullIData(oldp+607,(8U),32);
}

VL_ATTR_COLD void Vtb_main_datapath___024root__trace_full_0_sub_0(Vtb_main_datapath___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vtb_main_datapath___024root__trace_full_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_main_datapath___024root__trace_full_0\n"); );
    // Init
    Vtb_main_datapath___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_main_datapath___024root*>(voidSelf);
    Vtb_main_datapath__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vtb_main_datapath___024root__trace_full_0_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vtb_main_datapath___024root__trace_full_0_sub_0(Vtb_main_datapath___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_main_datapath__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_main_datapath___024root__trace_full_0_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    VlWide<6>/*191:0*/ __Vtemp_1;
    // Body
    bufp->fullBit(oldp+1,(vlSelf->tb_main_datapath__DOT__reset));
    bufp->fullBit(oldp+2,(vlSelf->tb_main_datapath__DOT__flush));
    bufp->fullBit(oldp+3,(vlSelf->tb_main_datapath__DOT__actual_taken));
    bufp->fullBit(oldp+4,(vlSelf->tb_main_datapath__DOT__mispredict));
    bufp->fullBit(oldp+5,(vlSelf->tb_main_datapath__DOT__restore_ghr));
    bufp->fullBit(oldp+6,(vlSelf->tb_main_datapath__DOT__restore_ras));
    bufp->fullBit(oldp+7,(vlSelf->tb_main_datapath__DOT__update_pht));
    bufp->fullBit(oldp+8,(vlSelf->tb_main_datapath__DOT__update_btb));
    bufp->fullBit(oldp+9,(vlSelf->tb_main_datapath__DOT__update_ras));
    bufp->fullBit(oldp+10,(vlSelf->tb_main_datapath__DOT__ex_is_ret));
    bufp->fullBit(oldp+11,(vlSelf->tb_main_datapath__DOT__ex_is_branch));
    bufp->fullBit(oldp+12,(vlSelf->tb_main_datapath__DOT__ex_is_jalr));
    bufp->fullBit(oldp+13,(vlSelf->tb_main_datapath__DOT__branch_mispredicted));
    bufp->fullBit(oldp+14,(vlSelf->tb_main_datapath__DOT__dis_biq_dealloc));
    bufp->fullCData(oldp+15,(vlSelf->tb_main_datapath__DOT__rr_biq_id),5);
    bufp->fullBit(oldp+16,(vlSelf->tb_main_datapath__DOT__rr_slot_id));
    bufp->fullBit(oldp+17,(vlSelf->tb_main_datapath__DOT__cdb_done1));
    bufp->fullBit(oldp+18,(vlSelf->tb_main_datapath__DOT__cdb_done2));
    bufp->fullBit(oldp+19,(vlSelf->tb_main_datapath__DOT__cdb_wakeup1));
    bufp->fullBit(oldp+20,(vlSelf->tb_main_datapath__DOT__cdb_wakeup2));
    bufp->fullBit(oldp+21,(vlSelf->tb_main_datapath__DOT__cdb_branch_resolved));
    bufp->fullBit(oldp+22,(vlSelf->tb_main_datapath__DOT__cdb_branch_correct));
    bufp->fullBit(oldp+23,(vlSelf->tb_main_datapath__DOT__comm_free_push1));
    bufp->fullBit(oldp+24,(vlSelf->tb_main_datapath__DOT__comm_free_push2));
    bufp->fullCData(oldp+25,(vlSelf->tb_main_datapath__DOT__cdb_waked_reg1),6);
    bufp->fullCData(oldp+26,(vlSelf->tb_main_datapath__DOT__cdb_waked_reg2),6);
    bufp->fullCData(oldp+27,(vlSelf->tb_main_datapath__DOT__comm_free_reg1),6);
    bufp->fullCData(oldp+28,(vlSelf->tb_main_datapath__DOT__comm_free_reg2),6);
    bufp->fullCData(oldp+29,(vlSelf->tb_main_datapath__DOT__cdb_branch_tag),2);
    bufp->fullCData(oldp+30,(vlSelf->tb_main_datapath__DOT__cdb_rob_index1),6);
    bufp->fullCData(oldp+31,(vlSelf->tb_main_datapath__DOT__cdb_rob_index2),6);
    bufp->fullCData(oldp+32,(vlSelf->tb_main_datapath__DOT__cdb_branch_rob_index),6);
    bufp->fullBit(oldp+33,((1U & (~ (IData)(vlSelf->tb_main_datapath__DOT__ex_is_ret)))));
    bufp->fullWData(oldp+34,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_snap),192);
    __Vtemp_1[0U] = ((vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT____VdfgTmp_h7093c5e6__0[1U] 
                      << 0x16U) | (vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT____VdfgTmp_h7093c5e6__0[0U] 
                                   >> 0xaU));
    __Vtemp_1[1U] = ((vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT____VdfgTmp_h7093c5e6__0[2U] 
                      << 0x16U) | (vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT____VdfgTmp_h7093c5e6__0[1U] 
                                   >> 0xaU));
    __Vtemp_1[2U] = ((vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT____VdfgTmp_h7093c5e6__0[3U] 
                      << 0x16U) | (vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT____VdfgTmp_h7093c5e6__0[2U] 
                                   >> 0xaU));
    __Vtemp_1[3U] = ((vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT____VdfgTmp_h7093c5e6__0[4U] 
                      << 0x16U) | (vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT____VdfgTmp_h7093c5e6__0[3U] 
                                   >> 0xaU));
    __Vtemp_1[4U] = ((vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT____VdfgTmp_h7093c5e6__0[5U] 
                      << 0x16U) | (vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT____VdfgTmp_h7093c5e6__0[4U] 
                                   >> 0xaU));
    __Vtemp_1[5U] = ((vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT____VdfgTmp_h7093c5e6__0[6U] 
                      << 0x16U) | (vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT____VdfgTmp_h7093c5e6__0[5U] 
                                   >> 0xaU));
    bufp->fullWData(oldp+40,(__Vtemp_1),192);
    bufp->fullCData(oldp+46,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_head_ptr),6);
    bufp->fullCData(oldp+47,((0x3fU & (vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT____VdfgTmp_h7093c5e6__0[0U] 
                                       >> 4U))),6);
    bufp->fullBit(oldp+48,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT____Vcellinp__bs_instantiation__id_take_snap));
    bufp->fullCData(oldp+49,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__next_head),6);
    bufp->fullBit(oldp+50,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__valid_pop1));
    bufp->fullWData(oldp+51,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT__next_RMT),192);
    bufp->fullWData(oldp+57,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT__next_RMT_inst1),192);
    bufp->fullBit(oldp+63,(vlSelf->tb_main_datapath__DOT__stall_frontend));
    bufp->fullBit(oldp+64,(vlSelf->tb_main_datapath__DOT__id_biq_pred_taken));
    bufp->fullIData(oldp+65,(vlSelf->tb_main_datapath__DOT__id_biq_pred_target),32);
    bufp->fullSData(oldp+66,(vlSelf->tb_main_datapath__DOT__id_biq_pht_index),9);
    bufp->fullSData(oldp+67,(vlSelf->tb_main_datapath__DOT__id_biq_restore_ghr),9);
    bufp->fullCData(oldp+68,(vlSelf->tb_main_datapath__DOT__id_biq_sp_snap),3);
    bufp->fullQData(oldp+69,(vlSelf->tb_main_datapath__DOT__id_biq_ras_snap),64);
    bufp->fullBit(oldp+71,(vlSelf->tb_main_datapath__DOT__commit_instr1));
    bufp->fullBit(oldp+72,(((1U < (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_count)) 
                            & ((vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__ROB
                                [(0x3fU & ((IData)(1U) 
                                           + (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_head_ptr)))] 
                                >> 0x11U) & (IData)(vlSelf->tb_main_datapath__DOT__commit_instr1)))));
    bufp->fullCData(oldp+73,((0x3fU & vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__ROB
                              [(0x3fU & (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_head_ptr))])),6);
    bufp->fullCData(oldp+74,((0x3fU & vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__ROB
                              [(0x3fU & ((IData)(1U) 
                                         + (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_head_ptr)))])),6);
    bufp->fullCData(oldp+75,((0x3fU & (vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__ROB
                                       [(0x3fU & (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_head_ptr))] 
                                       >> 6U))),6);
    bufp->fullCData(oldp+76,((0x3fU & (vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__ROB
                                       [(0x3fU & ((IData)(1U) 
                                                  + (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_head_ptr)))] 
                                       >> 6U))),6);
    bufp->fullCData(oldp+77,((0x1fU & (vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__ROB
                                       [(0x3fU & (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_head_ptr))] 
                                       >> 0xcU))),5);
    bufp->fullCData(oldp+78,((0x1fU & (vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__ROB
                                       [(0x3fU & ((IData)(1U) 
                                                  + (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_head_ptr)))] 
                                       >> 0xcU))),5);
    bufp->fullBit(oldp+79,(vlSelf->tb_main_datapath__DOT__iss_valid1));
    bufp->fullBit(oldp+80,(vlSelf->tb_main_datapath__DOT__iss_is_m_extension1));
    bufp->fullBit(oldp+81,(vlSelf->tb_main_datapath__DOT__iss_jump_reg1));
    bufp->fullBit(oldp+82,(vlSelf->tb_main_datapath__DOT__iss_jump1));
    bufp->fullBit(oldp+83,(vlSelf->tb_main_datapath__DOT__iss_branch1));
    bufp->fullBit(oldp+84,(vlSelf->tb_main_datapath__DOT__iss_instr1_regsrc1));
    bufp->fullBit(oldp+85,(vlSelf->tb_main_datapath__DOT__iss_instr1_regsrc2));
    bufp->fullBit(oldp+86,(vlSelf->tb_main_datapath__DOT__iss_immtype1));
    bufp->fullBit(oldp+87,(vlSelf->tb_main_datapath__DOT__iss_isimm1));
    bufp->fullBit(oldp+88,(vlSelf->tb_main_datapath__DOT__iss_retaddr1));
    bufp->fullBit(oldp+89,(vlSelf->tb_main_datapath__DOT__iss_upperimm1));
    bufp->fullBit(oldp+90,(vlSelf->tb_main_datapath__DOT__iss_regwrite1));
    bufp->fullBit(oldp+91,(vlSelf->tb_main_datapath__DOT__iss_memwrite1));
    bufp->fullBit(oldp+92,(vlSelf->tb_main_datapath__DOT__iss_memtoreg1));
    bufp->fullIData(oldp+93,(vlSelf->tb_main_datapath__DOT__iss_pc1),30);
    bufp->fullCData(oldp+94,(vlSelf->tb_main_datapath__DOT__iss_prd1),6);
    bufp->fullCData(oldp+95,(vlSelf->tb_main_datapath__DOT__iss_instr1_prs1),6);
    bufp->fullCData(oldp+96,(vlSelf->tb_main_datapath__DOT__iss_instr1_prs2),6);
    bufp->fullIData(oldp+97,(vlSelf->tb_main_datapath__DOT__iss_immediate1),21);
    bufp->fullCData(oldp+98,(vlSelf->tb_main_datapath__DOT__iss_alu_operation1),5);
    bufp->fullCData(oldp+99,(vlSelf->tb_main_datapath__DOT__iss_branch_tag1),2);
    bufp->fullCData(oldp+100,(vlSelf->tb_main_datapath__DOT__iss_branch_mask1),4);
    bufp->fullCData(oldp+101,(vlSelf->tb_main_datapath__DOT__iss_biq_address1),5);
    bufp->fullCData(oldp+102,(vlSelf->tb_main_datapath__DOT__iss_rob_index1),6);
    bufp->fullBit(oldp+103,(vlSelf->tb_main_datapath__DOT__iss_valid2));
    bufp->fullBit(oldp+104,(vlSelf->tb_main_datapath__DOT__iss_is_m_extension2));
    bufp->fullBit(oldp+105,(vlSelf->tb_main_datapath__DOT__iss_jump_reg2));
    bufp->fullBit(oldp+106,(vlSelf->tb_main_datapath__DOT__iss_jump2));
    bufp->fullBit(oldp+107,(vlSelf->tb_main_datapath__DOT__iss_branch2));
    bufp->fullBit(oldp+108,(vlSelf->tb_main_datapath__DOT__iss_instr2_regsrc1));
    bufp->fullBit(oldp+109,(vlSelf->tb_main_datapath__DOT__iss_instr2_regsrc2));
    bufp->fullBit(oldp+110,(vlSelf->tb_main_datapath__DOT__iss_immtype2));
    bufp->fullBit(oldp+111,(vlSelf->tb_main_datapath__DOT__iss_isimm2));
    bufp->fullBit(oldp+112,(vlSelf->tb_main_datapath__DOT__iss_retaddr2));
    bufp->fullBit(oldp+113,(vlSelf->tb_main_datapath__DOT__iss_upperimm2));
    bufp->fullBit(oldp+114,(vlSelf->tb_main_datapath__DOT__iss_regwrite2));
    bufp->fullBit(oldp+115,(vlSelf->tb_main_datapath__DOT__iss_memwrite2));
    bufp->fullBit(oldp+116,(vlSelf->tb_main_datapath__DOT__iss_memtoreg2));
    bufp->fullIData(oldp+117,(vlSelf->tb_main_datapath__DOT__iss_pc2),30);
    bufp->fullCData(oldp+118,(vlSelf->tb_main_datapath__DOT__iss_prd2),6);
    bufp->fullCData(oldp+119,(vlSelf->tb_main_datapath__DOT__iss_instr2_prs1),6);
    bufp->fullCData(oldp+120,(vlSelf->tb_main_datapath__DOT__iss_instr2_prs2),6);
    bufp->fullIData(oldp+121,(vlSelf->tb_main_datapath__DOT__iss_immediate2),21);
    bufp->fullCData(oldp+122,(vlSelf->tb_main_datapath__DOT__iss_alu_operation2),5);
    bufp->fullCData(oldp+123,(vlSelf->tb_main_datapath__DOT__iss_branch_tag2),2);
    bufp->fullCData(oldp+124,(vlSelf->tb_main_datapath__DOT__iss_branch_mask2),4);
    bufp->fullCData(oldp+125,(vlSelf->tb_main_datapath__DOT__iss_biq_address2),5);
    bufp->fullCData(oldp+126,(vlSelf->tb_main_datapath__DOT__iss_rob_index2),6);
    bufp->fullBit(oldp+127,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stall_frontend));
    bufp->fullBit(oldp+128,(((0xfU == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT__BMR)) 
                             | ((0x3fU & ((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__tail) 
                                          - (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__head))) 
                                < (0x3fU & ((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__pop1) 
                                            + (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__pop2)))))));
    bufp->fullBit(oldp+129,(((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_full) 
                             | (0x3fU <= (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_count)))));
    bufp->fullCData(oldp+130,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_predecode_instr1),2);
    bufp->fullCData(oldp+131,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_predecode_instr2),2);
    bufp->fullIData(oldp+132,(((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__id_jump1)
                                ? ((IData)(4U) + (vlSelf->tb_main_datapath__DOT__dut__DOT__id_pc 
                                                  << 2U))
                                : ((IData)(8U) + (vlSelf->tb_main_datapath__DOT__dut__DOT__id_pc 
                                                  << 2U)))),32);
    bufp->fullBit(oldp+133,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_valid1));
    bufp->fullBit(oldp+134,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_valid2));
    bufp->fullIData(oldp+135,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_pc),32);
    bufp->fullIData(oldp+136,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_pred_target1),32);
    bufp->fullBit(oldp+137,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_pred_taken1));
    bufp->fullBit(oldp+138,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_btb_hit1));
    bufp->fullSData(oldp+139,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_pht_index1),9);
    bufp->fullCData(oldp+140,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_sp_snap),3);
    bufp->fullQData(oldp+141,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_ras_snap),64);
    bufp->fullSData(oldp+143,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_prev_ghr),9);
    bufp->fullBit(oldp+144,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_valid1));
    bufp->fullBit(oldp+145,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_valid2));
    bufp->fullIData(oldp+146,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_pc),30);
    bufp->fullIData(oldp+147,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1),32);
    bufp->fullIData(oldp+148,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2),32);
    bufp->fullIData(oldp+149,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_pred_target1),32);
    bufp->fullBit(oldp+150,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_pred_taken1));
    bufp->fullBit(oldp+151,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_btb_hit1));
    bufp->fullSData(oldp+152,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_pht_index1),9);
    bufp->fullCData(oldp+153,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_sp_snap),3);
    bufp->fullQData(oldp+154,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_ras_snap),64);
    bufp->fullSData(oldp+156,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_prev_ghr),9);
    bufp->fullBit(oldp+157,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_take_snap));
    bufp->fullBit(oldp+158,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_valid1));
    bufp->fullBit(oldp+159,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_valid2));
    bufp->fullIData(oldp+160,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_pc),30);
    bufp->fullCData(oldp+161,((0x1fU & (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__biq_tail_ptr))),5);
    bufp->fullCData(oldp+162,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_alu_operation1),5);
    bufp->fullCData(oldp+163,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_alu_operation2),5);
    bufp->fullBit(oldp+164,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_is_m_extension1));
    bufp->fullBit(oldp+165,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_is_m_extension2));
    bufp->fullCData(oldp+166,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_rs1_1),5);
    bufp->fullCData(oldp+167,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_rs2_1),5);
    bufp->fullCData(oldp+168,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_rd_1),5);
    bufp->fullCData(oldp+169,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_rs1_2),5);
    bufp->fullCData(oldp+170,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_rs2_2),5);
    bufp->fullCData(oldp+171,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_rd_2),5);
    bufp->fullBit(oldp+172,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_jump_reg1));
    bufp->fullBit(oldp+173,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_jump1));
    bufp->fullBit(oldp+174,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_branch1));
    bufp->fullBit(oldp+175,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_regsrc1_1));
    bufp->fullBit(oldp+176,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_regsrc2_1));
    bufp->fullBit(oldp+177,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_immtype1));
    bufp->fullBit(oldp+178,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_memwrite1));
    bufp->fullBit(oldp+179,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_regwrite1));
    bufp->fullBit(oldp+180,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_memtoreg1));
    bufp->fullBit(oldp+181,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_retaddr1));
    bufp->fullBit(oldp+182,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_isimm1));
    bufp->fullBit(oldp+183,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_upperimm1));
    bufp->fullIData(oldp+184,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_immout1),21);
    bufp->fullBit(oldp+185,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_jump_reg2));
    bufp->fullBit(oldp+186,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_jump2));
    bufp->fullBit(oldp+187,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_branch2));
    bufp->fullBit(oldp+188,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_regsrc1_2));
    bufp->fullBit(oldp+189,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_regsrc2_2));
    bufp->fullBit(oldp+190,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_immtype2));
    bufp->fullBit(oldp+191,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_memwrite2));
    bufp->fullBit(oldp+192,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_regwrite2));
    bufp->fullBit(oldp+193,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_memtoreg2));
    bufp->fullBit(oldp+194,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_retaddr2));
    bufp->fullBit(oldp+195,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_isimm2));
    bufp->fullBit(oldp+196,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_upperimm2));
    bufp->fullIData(oldp+197,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_immout2),21);
    bufp->fullCData(oldp+198,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_prd1),6);
    bufp->fullCData(oldp+199,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_prs1_1),6);
    bufp->fullCData(oldp+200,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_prs2_1),6);
    bufp->fullCData(oldp+201,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_old_prd1),6);
    bufp->fullCData(oldp+202,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_prd2),6);
    bufp->fullCData(oldp+203,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_prs1_2),6);
    bufp->fullCData(oldp+204,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_prs2_2),6);
    bufp->fullCData(oldp+205,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_old_prd2),6);
    bufp->fullBit(oldp+206,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_prs1_busy1));
    bufp->fullBit(oldp+207,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_prs2_busy1));
    bufp->fullBit(oldp+208,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_prs1_busy2));
    bufp->fullBit(oldp+209,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_prs2_busy2));
    bufp->fullCData(oldp+210,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT__current_btag),2);
    bufp->fullCData(oldp+211,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT__BMR),4);
    bufp->fullCData(oldp+212,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_biq_address),5);
    bufp->fullIData(oldp+213,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_pc),30);
    bufp->fullCData(oldp+214,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_rd_1),5);
    bufp->fullCData(oldp+215,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_rd_2),5);
    bufp->fullIData(oldp+216,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_immout1),21);
    bufp->fullIData(oldp+217,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_immout2),21);
    bufp->fullBit(oldp+218,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_is_m_extension1));
    bufp->fullBit(oldp+219,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_is_m_extension2));
    bufp->fullCData(oldp+220,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_alu_operation1),5);
    bufp->fullCData(oldp+221,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_alu_operation2),5);
    bufp->fullBit(oldp+222,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_valid1));
    bufp->fullBit(oldp+223,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_jump_reg1));
    bufp->fullBit(oldp+224,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_jump1));
    bufp->fullBit(oldp+225,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_branch1));
    bufp->fullBit(oldp+226,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_regsrc1_1));
    bufp->fullBit(oldp+227,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_regsrc2_1));
    bufp->fullBit(oldp+228,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_immtype1));
    bufp->fullBit(oldp+229,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_isimm1));
    bufp->fullBit(oldp+230,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_retaddr1));
    bufp->fullBit(oldp+231,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_upperimm1));
    bufp->fullBit(oldp+232,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_regwrite1));
    bufp->fullBit(oldp+233,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_memwrite1));
    bufp->fullBit(oldp+234,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_memtoreg1));
    bufp->fullBit(oldp+235,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_valid2));
    bufp->fullBit(oldp+236,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_jump_reg2));
    bufp->fullBit(oldp+237,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_jump2));
    bufp->fullBit(oldp+238,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_branch2));
    bufp->fullBit(oldp+239,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_regsrc1_2));
    bufp->fullBit(oldp+240,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_regsrc2_2));
    bufp->fullBit(oldp+241,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_immtype2));
    bufp->fullBit(oldp+242,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_isimm2));
    bufp->fullBit(oldp+243,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_retaddr2));
    bufp->fullBit(oldp+244,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_upperimm2));
    bufp->fullBit(oldp+245,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_regwrite2));
    bufp->fullBit(oldp+246,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_memwrite2));
    bufp->fullBit(oldp+247,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_memtoreg2));
    bufp->fullBit(oldp+248,((0x3fU <= (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_count))));
    bufp->fullBit(oldp+249,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_full));
    bufp->fullCData(oldp+250,((0x3fU & (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_tail_ptr))),6);
    bufp->fullCData(oldp+251,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__iq_alloc_index1),6);
    bufp->fullCData(oldp+252,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__iq_alloc_index2),6);
    bufp->fullBit(oldp+253,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__alloc1_found));
    bufp->fullBit(oldp+254,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__alloc2_found));
    bufp->fullBit(oldp+255,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__fast_wakeup1));
    bufp->fullBit(oldp+256,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__fast_wakeup2));
    bufp->fullCData(oldp+257,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__fast_waked_reg1),6);
    bufp->fullCData(oldp+258,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__fast_waked_reg2),6);
    bufp->fullCData(oldp+259,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__issue_index1),6);
    bufp->fullCData(oldp+260,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__issue_index2),6);
    bufp->fullBit(oldp+261,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__is_control_flow_instr));
    bufp->fullBit(oldp+262,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__issue1_found));
    bufp->fullBit(oldp+263,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__issue2_found));
    bufp->fullIData(oldp+264,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__unnamedblk2__DOT__i),32);
    bufp->fullIData(oldp+265,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__unnamedblk3__DOT__i),32);
    bufp->fullCData(oldp+266,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_head_ptr),7);
    bufp->fullCData(oldp+267,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_tail_ptr),7);
    bufp->fullCData(oldp+268,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_count),7);
    bufp->fullCData(oldp+269,((0x7fU & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1)),7);
    bufp->fullCData(oldp+270,((0x7fU & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2)),7);
    bufp->fullCData(oldp+271,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__ALUOp_1),3);
    bufp->fullCData(oldp+272,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__ALUOp_2),3);
    bufp->fullIData(oldp+273,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__imm_out1),21);
    bufp->fullIData(oldp+274,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__imm_out2),21);
    bufp->fullCData(oldp+275,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__alu_operation1),5);
    bufp->fullCData(oldp+276,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__alu_operation2),5);
    bufp->fullBit(oldp+277,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__is_control_flow_instr));
    bufp->fullBit(oldp+278,((IData)((0x2000033U == 
                                     (0x200007fU & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1)))));
    bufp->fullBit(oldp+279,((IData)((0x2000033U == 
                                     (0x200007fU & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2)))));
    bufp->fullBit(oldp+280,(((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                    >> 6U)) && ((1U 
                                                 & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                    >> 5U)) 
                                                && ((1U 
                                                     & (~ 
                                                        (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                         >> 4U))) 
                                                    && ((1U 
                                                         & (~ 
                                                            (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                             >> 3U))) 
                                                        && ((1U 
                                                             & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                                >> 2U)) 
                                                            && ((1U 
                                                                 & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                                    >> 1U)) 
                                                                && (1U 
                                                                    & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1)))))))));
    bufp->fullBit(oldp+281,(((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                    >> 6U)) && ((1U 
                                                 & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                    >> 5U)) 
                                                && ((1U 
                                                     & (~ 
                                                        (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                         >> 4U))) 
                                                    && ((1U 
                                                         & (~ 
                                                            (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                             >> 3U))) 
                                                        && ((1U 
                                                             & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                                >> 2U)) 
                                                            && ((1U 
                                                                 & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                                    >> 1U)) 
                                                                && (1U 
                                                                    & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2)))))))));
    bufp->fullBit(oldp+282,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__Jump_1));
    bufp->fullBit(oldp+283,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__Jump_2));
    bufp->fullBit(oldp+284,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__Branch_1));
    bufp->fullBit(oldp+285,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__Branch_2));
    bufp->fullBit(oldp+286,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__RegSrc1_1));
    bufp->fullBit(oldp+287,(((0x40U & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1)
                              ? ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                        >> 5U)) && 
                                 ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                            >> 4U))) 
                                  && ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                >> 3U))) 
                                      && ((1U & (~ 
                                                 (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                  >> 2U))) 
                                          && ((1U & 
                                               (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                >> 1U)) 
                                              && (1U 
                                                  & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1))))))
                              : ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                        >> 5U)) && 
                                 ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                         >> 4U)) && 
                                  ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                             >> 3U))) 
                                   && ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                 >> 2U))) 
                                       && ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                  >> 1U)) 
                                           && (1U & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1)))))))));
    bufp->fullBit(oldp+288,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__RegSrc1_2));
    bufp->fullBit(oldp+289,(((0x40U & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2)
                              ? ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                        >> 5U)) && 
                                 ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                            >> 4U))) 
                                  && ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                >> 3U))) 
                                      && ((1U & (~ 
                                                 (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                  >> 2U))) 
                                          && ((1U & 
                                               (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                >> 1U)) 
                                              && (1U 
                                                  & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2))))))
                              : ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                        >> 5U)) && 
                                 ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                         >> 4U)) && 
                                  ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                             >> 3U))) 
                                   && ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                 >> 2U))) 
                                       && ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                  >> 1U)) 
                                           && (1U & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2)))))))));
    bufp->fullBit(oldp+290,(((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                    >> 6U)) && ((1U 
                                                 & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                    >> 5U)) 
                                                && ((1U 
                                                     & (~ 
                                                        (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                         >> 4U))) 
                                                    && ((8U 
                                                         & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1)
                                                         ? 
                                                        ((1U 
                                                          & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                             >> 2U)) 
                                                         && ((1U 
                                                              & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                                 >> 1U)) 
                                                             && (1U 
                                                                 & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1)))
                                                         : 
                                                        ((1U 
                                                          & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                             >> 2U)) 
                                                         && ((1U 
                                                              & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                                 >> 1U)) 
                                                             && (1U 
                                                                 & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1)))))))));
    bufp->fullBit(oldp+291,(((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                       >> 6U))) && 
                             ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                     >> 5U)) && ((1U 
                                                  & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                     >> 4U)) 
                                                 && ((1U 
                                                      & (~ 
                                                         (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                          >> 3U))) 
                                                     && ((1U 
                                                          & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                             >> 2U)) 
                                                         && ((1U 
                                                              & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                                 >> 1U)) 
                                                             && (1U 
                                                                 & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1)))))))));
    bufp->fullBit(oldp+292,(((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                       >> 6U))) && 
                             ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                     >> 5U)) && ((1U 
                                                  & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                     >> 4U)) 
                                                 && ((1U 
                                                      & (~ 
                                                         (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                          >> 3U))) 
                                                     && ((1U 
                                                          & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                             >> 2U)) 
                                                         && ((1U 
                                                              & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                                 >> 1U)) 
                                                             && (1U 
                                                                 & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2)))))))));
    bufp->fullBit(oldp+293,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__RegWrite_1));
    bufp->fullBit(oldp+294,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__RegWrite_2));
    bufp->fullBit(oldp+295,(((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                       >> 6U))) && 
                             ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                     >> 5U)) && ((1U 
                                                  & (~ 
                                                     (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                      >> 4U))) 
                                                 && ((1U 
                                                      & (~ 
                                                         (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                          >> 3U))) 
                                                     && ((1U 
                                                          & (~ 
                                                             (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                              >> 2U))) 
                                                         && ((1U 
                                                              & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                                 >> 1U)) 
                                                             && (1U 
                                                                 & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1)))))))));
    bufp->fullBit(oldp+296,(((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                       >> 6U))) && 
                             ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                     >> 5U)) && ((1U 
                                                  & (~ 
                                                     (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                      >> 4U))) 
                                                 && ((1U 
                                                      & (~ 
                                                         (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                          >> 3U))) 
                                                     && ((1U 
                                                          & (~ 
                                                             (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                              >> 2U))) 
                                                         && ((1U 
                                                              & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                                 >> 1U)) 
                                                             && (1U 
                                                                 & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2)))))))));
    bufp->fullBit(oldp+297,(((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                       >> 6U))) && 
                             ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                        >> 5U))) && 
                              ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                         >> 4U))) && 
                               ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                          >> 3U))) 
                                && ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                              >> 2U))) 
                                    && ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                               >> 1U)) 
                                        && (1U & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1)))))))));
    bufp->fullBit(oldp+298,(((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                       >> 6U))) && 
                             ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                        >> 5U))) && 
                              ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                         >> 4U))) && 
                               ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                          >> 3U))) 
                                && ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                              >> 2U))) 
                                    && ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                               >> 1U)) 
                                        && (1U & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2)))))))));
    bufp->fullBit(oldp+299,(((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                    >> 6U)) && ((1U 
                                                 & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                    >> 5U)) 
                                                && ((1U 
                                                     & (~ 
                                                        (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                         >> 4U))) 
                                                    && ((8U 
                                                         & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2)
                                                         ? 
                                                        ((1U 
                                                          & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                             >> 2U)) 
                                                         && ((1U 
                                                              & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                                 >> 1U)) 
                                                             && (1U 
                                                                 & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2)))
                                                         : 
                                                        ((1U 
                                                          & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                             >> 2U)) 
                                                         && ((1U 
                                                              & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                                 >> 1U)) 
                                                             && (1U 
                                                                 & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2)))))))));
    bufp->fullBit(oldp+300,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__Imm_1));
    bufp->fullBit(oldp+301,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__Imm_2));
    bufp->fullBit(oldp+302,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__imm_type1));
    bufp->fullBit(oldp+303,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__imm_type2));
    bufp->fullCData(oldp+304,((7U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                     >> 0xcU))),3);
    bufp->fullCData(oldp+305,((vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                               >> 0x19U)),7);
    bufp->fullCData(oldp+306,((7U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                     >> 0xcU))),3);
    bufp->fullCData(oldp+307,((vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                               >> 0x19U)),7);
    bufp->fullWData(oldp+308,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [0U]),118);
    bufp->fullWData(oldp+312,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [1U]),118);
    bufp->fullWData(oldp+316,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [2U]),118);
    bufp->fullWData(oldp+320,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [3U]),118);
    bufp->fullWData(oldp+324,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [4U]),118);
    bufp->fullWData(oldp+328,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [5U]),118);
    bufp->fullWData(oldp+332,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [6U]),118);
    bufp->fullWData(oldp+336,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [7U]),118);
    bufp->fullWData(oldp+340,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [8U]),118);
    bufp->fullWData(oldp+344,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [9U]),118);
    bufp->fullWData(oldp+348,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [0xaU]),118);
    bufp->fullWData(oldp+352,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [0xbU]),118);
    bufp->fullWData(oldp+356,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [0xcU]),118);
    bufp->fullWData(oldp+360,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [0xdU]),118);
    bufp->fullWData(oldp+364,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [0xeU]),118);
    bufp->fullWData(oldp+368,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [0xfU]),118);
    bufp->fullWData(oldp+372,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [0x10U]),118);
    bufp->fullWData(oldp+376,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [0x11U]),118);
    bufp->fullWData(oldp+380,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [0x12U]),118);
    bufp->fullWData(oldp+384,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [0x13U]),118);
    bufp->fullWData(oldp+388,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [0x14U]),118);
    bufp->fullWData(oldp+392,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [0x15U]),118);
    bufp->fullWData(oldp+396,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [0x16U]),118);
    bufp->fullWData(oldp+400,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [0x17U]),118);
    bufp->fullWData(oldp+404,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [0x18U]),118);
    bufp->fullWData(oldp+408,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [0x19U]),118);
    bufp->fullWData(oldp+412,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [0x1aU]),118);
    bufp->fullWData(oldp+416,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [0x1bU]),118);
    bufp->fullWData(oldp+420,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [0x1cU]),118);
    bufp->fullWData(oldp+424,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [0x1dU]),118);
    bufp->fullWData(oldp+428,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [0x1eU]),118);
    bufp->fullWData(oldp+432,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                              [0x1fU]),118);
    bufp->fullCData(oldp+436,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__biq_head_ptr),6);
    bufp->fullCData(oldp+437,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__biq_tail_ptr),6);
    bufp->fullCData(oldp+438,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__ig_instantiation1__DOT__opcode),7);
    bufp->fullCData(oldp+439,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__ig_instantiation2__DOT__opcode),7);
    bufp->fullIData(oldp+440,((vlSelf->tb_main_datapath__DOT__dut__DOT__pd_pc 
                               >> 2U)),30);
    bufp->fullIData(oldp+441,((0x3fffffffU & ((IData)(1U) 
                                              + (vlSelf->tb_main_datapath__DOT__dut__DOT__pd_pc 
                                                 >> 2U)))),30);
    bufp->fullIData(oldp+442,(VL_SHIFTR_III(32,32,32, vlSelf->tb_main_datapath__DOT__dut__DOT__pd_pc, 2U)),32);
    bufp->fullIData(oldp+443,((0x3fffffffU & ((IData)(1U) 
                                              + (vlSelf->tb_main_datapath__DOT__dut__DOT__pd_pc 
                                                 >> 2U)))),32);
    bufp->fullCData(oldp+444,((0x1fU & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                        >> 7U))),5);
    bufp->fullCData(oldp+445,((0x1fU & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                        >> 7U))),5);
    bufp->fullSData(oldp+446,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ghr_out),9);
    bufp->fullSData(oldp+447,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__pht_index),9);
    bufp->fullBit(oldp+448,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__pred_taken));
    bufp->fullBit(oldp+449,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__btb_hit));
    bufp->fullBit(oldp+450,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__btb_is_branch));
    bufp->fullBit(oldp+451,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__is_return_instr));
    bufp->fullBit(oldp+452,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__squash_instruction));
    bufp->fullIData(oldp+453,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__pred_return_address),32);
    bufp->fullIData(oldp+454,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__pred_target_address),32);
    bufp->fullCData(oldp+455,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__sp_snap),3);
    bufp->fullQData(oldp+456,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_snap),64);
    bufp->fullIData(oldp+458,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__next_pc),32);
    bufp->fullBit(oldp+459,((3U == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__if_predecode_instr1))));
    bufp->fullBit(oldp+460,((3U == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__if_predecode_instr2))));
    bufp->fullIData(oldp+461,((vlSelf->tb_main_datapath__DOT__dut__DOT__pd_pc 
                               >> 9U)),23);
    bufp->fullCData(oldp+462,((0x3fU & (vlSelf->tb_main_datapath__DOT__dut__DOT__pd_pc 
                                        >> 3U))),6);
    bufp->fullIData(oldp+463,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__btb_instantiation__DOT__unnamedblk1__DOT__i),32);
    bufp->fullIData(oldp+464,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_instantiation__DOT__RAS[0]),32);
    bufp->fullIData(oldp+465,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_instantiation__DOT__RAS[1]),32);
    bufp->fullIData(oldp+466,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_instantiation__DOT__RAS[2]),32);
    bufp->fullIData(oldp+467,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_instantiation__DOT__RAS[3]),32);
    bufp->fullIData(oldp+468,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_instantiation__DOT__RAS[4]),32);
    bufp->fullIData(oldp+469,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_instantiation__DOT__RAS[5]),32);
    bufp->fullIData(oldp+470,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_instantiation__DOT__RAS[6]),32);
    bufp->fullIData(oldp+471,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_instantiation__DOT__RAS[7]),32);
    bufp->fullCData(oldp+472,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_instantiation__DOT__sp),3);
    bufp->fullCData(oldp+473,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_instantiation__DOT__next_sp),3);
    bufp->fullBit(oldp+474,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_instantiation__DOT__push));
    bufp->fullBit(oldp+475,((2U == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__if_predecode_instr1))));
    bufp->fullBit(oldp+476,((2U == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__if_predecode_instr2))));
    bufp->fullBit(oldp+477,((1U == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__if_predecode_instr1))));
    bufp->fullBit(oldp+478,((1U == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__if_predecode_instr2))));
    bufp->fullCData(oldp+479,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_freed_reg1),6);
    bufp->fullCData(oldp+480,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL
                              [(0x1fU & ((IData)(1U) 
                                         + (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__head)))]),6);
    bufp->fullCData(oldp+481,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__routed_freed_reg2),6);
    bufp->fullBit(oldp+482,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__pop1));
    bufp->fullBit(oldp+483,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__pop2));
    bufp->fullBit(oldp+484,((0xfU == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT__BMR))));
    bufp->fullBit(oldp+485,(((0x3fU & ((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__tail) 
                                       - (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__head))) 
                             < (0x3fU & ((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__pop1) 
                                         + (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__pop2))))));
    bufp->fullBit(oldp+486,(((~ (IData)(vlSelf->tb_main_datapath__DOT__stall_frontend)) 
                             & (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__pop1))));
    bufp->fullBit(oldp+487,(((~ (IData)(vlSelf->tb_main_datapath__DOT__stall_frontend)) 
                             & (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__pop2))));
    bufp->fullWData(oldp+488,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT__BS
                              [0U]),202);
    bufp->fullWData(oldp+495,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT__BS
                              [1U]),202);
    bufp->fullWData(oldp+502,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT__BS
                              [2U]),202);
    bufp->fullWData(oldp+509,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT__BS
                              [3U]),202);
    bufp->fullIData(oldp+516,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT__unnamedblk1__DOT__i),32);
    bufp->fullIData(oldp+517,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT__unnamedblk2__DOT__i),32);
    bufp->fullCData(oldp+518,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[0]),6);
    bufp->fullCData(oldp+519,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[1]),6);
    bufp->fullCData(oldp+520,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[2]),6);
    bufp->fullCData(oldp+521,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[3]),6);
    bufp->fullCData(oldp+522,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[4]),6);
    bufp->fullCData(oldp+523,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[5]),6);
    bufp->fullCData(oldp+524,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[6]),6);
    bufp->fullCData(oldp+525,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[7]),6);
    bufp->fullCData(oldp+526,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[8]),6);
    bufp->fullCData(oldp+527,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[9]),6);
    bufp->fullCData(oldp+528,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[10]),6);
    bufp->fullCData(oldp+529,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[11]),6);
    bufp->fullCData(oldp+530,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[12]),6);
    bufp->fullCData(oldp+531,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[13]),6);
    bufp->fullCData(oldp+532,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[14]),6);
    bufp->fullCData(oldp+533,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[15]),6);
    bufp->fullCData(oldp+534,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[16]),6);
    bufp->fullCData(oldp+535,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[17]),6);
    bufp->fullCData(oldp+536,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[18]),6);
    bufp->fullCData(oldp+537,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[19]),6);
    bufp->fullCData(oldp+538,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[20]),6);
    bufp->fullCData(oldp+539,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[21]),6);
    bufp->fullCData(oldp+540,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[22]),6);
    bufp->fullCData(oldp+541,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[23]),6);
    bufp->fullCData(oldp+542,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[24]),6);
    bufp->fullCData(oldp+543,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[25]),6);
    bufp->fullCData(oldp+544,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[26]),6);
    bufp->fullCData(oldp+545,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[27]),6);
    bufp->fullCData(oldp+546,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[28]),6);
    bufp->fullCData(oldp+547,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[29]),6);
    bufp->fullCData(oldp+548,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[30]),6);
    bufp->fullCData(oldp+549,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[31]),6);
    bufp->fullCData(oldp+550,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__head),6);
    bufp->fullCData(oldp+551,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__tail),6);
    bufp->fullCData(oldp+552,((0x3fU & ((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__pop1) 
                                        + (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__pop2)))),6);
    bufp->fullIData(oldp+553,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__unnamedblk1__DOT__i),32);
    bufp->fullBit(oldp+554,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT____Vcellinp__rmt_instantiation__reg_write1));
    bufp->fullBit(oldp+555,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT____Vcellinp__rmt_instantiation__reg_write2));
    bufp->fullWData(oldp+556,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT__RMT),192);
    bufp->fullQData(oldp+562,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT__busy_table),64);
    bufp->fullIData(oldp+564,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT__unnamedblk1__DOT__i),32);
    bufp->fullBit(oldp+565,(vlSelf->tb_main_datapath__DOT__CLK));
    bufp->fullBit(oldp+566,((IData)((((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_head_ptr) 
                                      >> 6U) ^ ((IData)(vlSelf->tb_main_datapath__DOT__cdb_branch_rob_index) 
                                                < (0x3fU 
                                                   & (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_head_ptr)))))));
    bufp->fullBit(oldp+567,(((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__pop2) 
                             & (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT____VdfgTmp_h88188f2f__0))));
    bufp->fullBit(oldp+568,((((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_h7b899e3c__0) 
                              & ((IData)(vlSelf->tb_main_datapath__DOT__cdb_waked_reg1) 
                                 == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_haa9ae981__0))) 
                             | ((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_h3f3ce8d6__0) 
                                & ((IData)(vlSelf->tb_main_datapath__DOT__cdb_waked_reg2) 
                                   == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_haa9ae981__0))))));
    bufp->fullBit(oldp+569,((((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_h7b899e3c__0) 
                              & ((IData)(vlSelf->tb_main_datapath__DOT__cdb_waked_reg1) 
                                 == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_h0a75576f__0))) 
                             | ((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_h3f3ce8d6__0) 
                                & ((IData)(vlSelf->tb_main_datapath__DOT__cdb_waked_reg2) 
                                   == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_h0a75576f__0))))));
    bufp->fullBit(oldp+570,((((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_h7b899e3c__0) 
                              & ((IData)(vlSelf->tb_main_datapath__DOT__cdb_waked_reg1) 
                                 == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_hbc67dbad__0))) 
                             | ((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_h3f3ce8d6__0) 
                                & ((IData)(vlSelf->tb_main_datapath__DOT__cdb_waked_reg2) 
                                   == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_hbc67dbad__0))))));
    bufp->fullBit(oldp+571,((((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_h7b899e3c__0) 
                              & ((IData)(vlSelf->tb_main_datapath__DOT__cdb_waked_reg1) 
                                 == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_hcee7f012__0))) 
                             | ((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_h3f3ce8d6__0) 
                                & ((IData)(vlSelf->tb_main_datapath__DOT__cdb_waked_reg2) 
                                   == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_hcee7f012__0))))));
}
