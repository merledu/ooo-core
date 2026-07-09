// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtb_main_datapath__Syms.h"


void Vtb_main_datapath___024root__trace_chg_0_sub_0(Vtb_main_datapath___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vtb_main_datapath___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_main_datapath___024root__trace_chg_0\n"); );
    // Init
    Vtb_main_datapath___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_main_datapath___024root*>(voidSelf);
    Vtb_main_datapath__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vtb_main_datapath___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vtb_main_datapath___024root__trace_chg_0_sub_0(Vtb_main_datapath___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_main_datapath__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_main_datapath___024root__trace_chg_0_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    VlWide<6>/*191:0*/ __Vtemp_1;
    // Body
    if (VL_UNLIKELY((vlSelf->__Vm_traceActivity[1U] 
                     | vlSelf->__Vm_traceActivity[2U]))) {
        bufp->chgBit(oldp+0,(vlSelf->tb_main_datapath__DOT__reset));
        bufp->chgBit(oldp+1,(vlSelf->tb_main_datapath__DOT__flush));
        bufp->chgBit(oldp+2,(vlSelf->tb_main_datapath__DOT__actual_taken));
        bufp->chgBit(oldp+3,(vlSelf->tb_main_datapath__DOT__mispredict));
        bufp->chgBit(oldp+4,(vlSelf->tb_main_datapath__DOT__restore_ghr));
        bufp->chgBit(oldp+5,(vlSelf->tb_main_datapath__DOT__restore_ras));
        bufp->chgBit(oldp+6,(vlSelf->tb_main_datapath__DOT__update_pht));
        bufp->chgBit(oldp+7,(vlSelf->tb_main_datapath__DOT__update_btb));
        bufp->chgBit(oldp+8,(vlSelf->tb_main_datapath__DOT__update_ras));
        bufp->chgBit(oldp+9,(vlSelf->tb_main_datapath__DOT__ex_is_ret));
        bufp->chgBit(oldp+10,(vlSelf->tb_main_datapath__DOT__ex_is_branch));
        bufp->chgBit(oldp+11,(vlSelf->tb_main_datapath__DOT__ex_is_jalr));
        bufp->chgBit(oldp+12,(vlSelf->tb_main_datapath__DOT__branch_mispredicted));
        bufp->chgBit(oldp+13,(vlSelf->tb_main_datapath__DOT__dis_biq_dealloc));
        bufp->chgCData(oldp+14,(vlSelf->tb_main_datapath__DOT__rr_biq_id),5);
        bufp->chgBit(oldp+15,(vlSelf->tb_main_datapath__DOT__rr_slot_id));
        bufp->chgBit(oldp+16,(vlSelf->tb_main_datapath__DOT__cdb_done1));
        bufp->chgBit(oldp+17,(vlSelf->tb_main_datapath__DOT__cdb_done2));
        bufp->chgBit(oldp+18,(vlSelf->tb_main_datapath__DOT__cdb_wakeup1));
        bufp->chgBit(oldp+19,(vlSelf->tb_main_datapath__DOT__cdb_wakeup2));
        bufp->chgBit(oldp+20,(vlSelf->tb_main_datapath__DOT__cdb_branch_resolved));
        bufp->chgBit(oldp+21,(vlSelf->tb_main_datapath__DOT__cdb_branch_correct));
        bufp->chgBit(oldp+22,(vlSelf->tb_main_datapath__DOT__comm_free_push1));
        bufp->chgBit(oldp+23,(vlSelf->tb_main_datapath__DOT__comm_free_push2));
        bufp->chgCData(oldp+24,(vlSelf->tb_main_datapath__DOT__cdb_waked_reg1),6);
        bufp->chgCData(oldp+25,(vlSelf->tb_main_datapath__DOT__cdb_waked_reg2),6);
        bufp->chgCData(oldp+26,(vlSelf->tb_main_datapath__DOT__comm_free_reg1),6);
        bufp->chgCData(oldp+27,(vlSelf->tb_main_datapath__DOT__comm_free_reg2),6);
        bufp->chgCData(oldp+28,(vlSelf->tb_main_datapath__DOT__cdb_branch_tag),2);
        bufp->chgCData(oldp+29,(vlSelf->tb_main_datapath__DOT__cdb_rob_index1),6);
        bufp->chgCData(oldp+30,(vlSelf->tb_main_datapath__DOT__cdb_rob_index2),6);
        bufp->chgCData(oldp+31,(vlSelf->tb_main_datapath__DOT__cdb_branch_rob_index),6);
        bufp->chgBit(oldp+32,((1U & (~ (IData)(vlSelf->tb_main_datapath__DOT__ex_is_ret)))));
    }
    if (VL_UNLIKELY((vlSelf->__Vm_traceActivity[3U] 
                     | vlSelf->__Vm_traceActivity[5U]))) {
        bufp->chgWData(oldp+33,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_snap),192);
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
        bufp->chgWData(oldp+39,(__Vtemp_1),192);
        bufp->chgCData(oldp+45,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_head_ptr),6);
        bufp->chgCData(oldp+46,((0x3fU & (vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT____VdfgTmp_h7093c5e6__0[0U] 
                                          >> 4U))),6);
        bufp->chgBit(oldp+47,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT____Vcellinp__bs_instantiation__id_take_snap));
        bufp->chgCData(oldp+48,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__next_head),6);
        bufp->chgBit(oldp+49,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__valid_pop1));
        bufp->chgWData(oldp+50,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT__next_RMT),192);
        bufp->chgWData(oldp+56,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT__next_RMT_inst1),192);
    }
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[4U])) {
        bufp->chgBit(oldp+62,(vlSelf->tb_main_datapath__DOT__stall_frontend));
        bufp->chgBit(oldp+63,(vlSelf->tb_main_datapath__DOT__id_biq_pred_taken));
        bufp->chgIData(oldp+64,(vlSelf->tb_main_datapath__DOT__id_biq_pred_target),32);
        bufp->chgSData(oldp+65,(vlSelf->tb_main_datapath__DOT__id_biq_pht_index),9);
        bufp->chgSData(oldp+66,(vlSelf->tb_main_datapath__DOT__id_biq_restore_ghr),9);
        bufp->chgCData(oldp+67,(vlSelf->tb_main_datapath__DOT__id_biq_sp_snap),3);
        bufp->chgQData(oldp+68,(vlSelf->tb_main_datapath__DOT__id_biq_ras_snap),64);
        bufp->chgBit(oldp+70,(vlSelf->tb_main_datapath__DOT__commit_instr1));
        bufp->chgBit(oldp+71,(((1U < (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_count)) 
                               & ((vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__ROB
                                   [(0x3fU & ((IData)(1U) 
                                              + (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_head_ptr)))] 
                                   >> 0x11U) & (IData)(vlSelf->tb_main_datapath__DOT__commit_instr1)))));
        bufp->chgCData(oldp+72,((0x3fU & vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__ROB
                                 [(0x3fU & (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_head_ptr))])),6);
        bufp->chgCData(oldp+73,((0x3fU & vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__ROB
                                 [(0x3fU & ((IData)(1U) 
                                            + (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_head_ptr)))])),6);
        bufp->chgCData(oldp+74,((0x3fU & (vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__ROB
                                          [(0x3fU & (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_head_ptr))] 
                                          >> 6U))),6);
        bufp->chgCData(oldp+75,((0x3fU & (vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__ROB
                                          [(0x3fU & 
                                            ((IData)(1U) 
                                             + (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_head_ptr)))] 
                                          >> 6U))),6);
        bufp->chgCData(oldp+76,((0x1fU & (vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__ROB
                                          [(0x3fU & (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_head_ptr))] 
                                          >> 0xcU))),5);
        bufp->chgCData(oldp+77,((0x1fU & (vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__ROB
                                          [(0x3fU & 
                                            ((IData)(1U) 
                                             + (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_head_ptr)))] 
                                          >> 0xcU))),5);
        bufp->chgBit(oldp+78,(vlSelf->tb_main_datapath__DOT__iss_valid1));
        bufp->chgBit(oldp+79,(vlSelf->tb_main_datapath__DOT__iss_is_m_extension1));
        bufp->chgBit(oldp+80,(vlSelf->tb_main_datapath__DOT__iss_jump_reg1));
        bufp->chgBit(oldp+81,(vlSelf->tb_main_datapath__DOT__iss_jump1));
        bufp->chgBit(oldp+82,(vlSelf->tb_main_datapath__DOT__iss_branch1));
        bufp->chgBit(oldp+83,(vlSelf->tb_main_datapath__DOT__iss_instr1_regsrc1));
        bufp->chgBit(oldp+84,(vlSelf->tb_main_datapath__DOT__iss_instr1_regsrc2));
        bufp->chgBit(oldp+85,(vlSelf->tb_main_datapath__DOT__iss_immtype1));
        bufp->chgBit(oldp+86,(vlSelf->tb_main_datapath__DOT__iss_isimm1));
        bufp->chgBit(oldp+87,(vlSelf->tb_main_datapath__DOT__iss_retaddr1));
        bufp->chgBit(oldp+88,(vlSelf->tb_main_datapath__DOT__iss_upperimm1));
        bufp->chgBit(oldp+89,(vlSelf->tb_main_datapath__DOT__iss_regwrite1));
        bufp->chgBit(oldp+90,(vlSelf->tb_main_datapath__DOT__iss_memwrite1));
        bufp->chgBit(oldp+91,(vlSelf->tb_main_datapath__DOT__iss_memtoreg1));
        bufp->chgIData(oldp+92,(vlSelf->tb_main_datapath__DOT__iss_pc1),30);
        bufp->chgCData(oldp+93,(vlSelf->tb_main_datapath__DOT__iss_prd1),6);
        bufp->chgCData(oldp+94,(vlSelf->tb_main_datapath__DOT__iss_instr1_prs1),6);
        bufp->chgCData(oldp+95,(vlSelf->tb_main_datapath__DOT__iss_instr1_prs2),6);
        bufp->chgIData(oldp+96,(vlSelf->tb_main_datapath__DOT__iss_immediate1),21);
        bufp->chgCData(oldp+97,(vlSelf->tb_main_datapath__DOT__iss_alu_operation1),5);
        bufp->chgCData(oldp+98,(vlSelf->tb_main_datapath__DOT__iss_branch_tag1),2);
        bufp->chgCData(oldp+99,(vlSelf->tb_main_datapath__DOT__iss_branch_mask1),4);
        bufp->chgCData(oldp+100,(vlSelf->tb_main_datapath__DOT__iss_biq_address1),5);
        bufp->chgCData(oldp+101,(vlSelf->tb_main_datapath__DOT__iss_rob_index1),6);
        bufp->chgBit(oldp+102,(vlSelf->tb_main_datapath__DOT__iss_valid2));
        bufp->chgBit(oldp+103,(vlSelf->tb_main_datapath__DOT__iss_is_m_extension2));
        bufp->chgBit(oldp+104,(vlSelf->tb_main_datapath__DOT__iss_jump_reg2));
        bufp->chgBit(oldp+105,(vlSelf->tb_main_datapath__DOT__iss_jump2));
        bufp->chgBit(oldp+106,(vlSelf->tb_main_datapath__DOT__iss_branch2));
        bufp->chgBit(oldp+107,(vlSelf->tb_main_datapath__DOT__iss_instr2_regsrc1));
        bufp->chgBit(oldp+108,(vlSelf->tb_main_datapath__DOT__iss_instr2_regsrc2));
        bufp->chgBit(oldp+109,(vlSelf->tb_main_datapath__DOT__iss_immtype2));
        bufp->chgBit(oldp+110,(vlSelf->tb_main_datapath__DOT__iss_isimm2));
        bufp->chgBit(oldp+111,(vlSelf->tb_main_datapath__DOT__iss_retaddr2));
        bufp->chgBit(oldp+112,(vlSelf->tb_main_datapath__DOT__iss_upperimm2));
        bufp->chgBit(oldp+113,(vlSelf->tb_main_datapath__DOT__iss_regwrite2));
        bufp->chgBit(oldp+114,(vlSelf->tb_main_datapath__DOT__iss_memwrite2));
        bufp->chgBit(oldp+115,(vlSelf->tb_main_datapath__DOT__iss_memtoreg2));
        bufp->chgIData(oldp+116,(vlSelf->tb_main_datapath__DOT__iss_pc2),30);
        bufp->chgCData(oldp+117,(vlSelf->tb_main_datapath__DOT__iss_prd2),6);
        bufp->chgCData(oldp+118,(vlSelf->tb_main_datapath__DOT__iss_instr2_prs1),6);
        bufp->chgCData(oldp+119,(vlSelf->tb_main_datapath__DOT__iss_instr2_prs2),6);
        bufp->chgIData(oldp+120,(vlSelf->tb_main_datapath__DOT__iss_immediate2),21);
        bufp->chgCData(oldp+121,(vlSelf->tb_main_datapath__DOT__iss_alu_operation2),5);
        bufp->chgCData(oldp+122,(vlSelf->tb_main_datapath__DOT__iss_branch_tag2),2);
        bufp->chgCData(oldp+123,(vlSelf->tb_main_datapath__DOT__iss_branch_mask2),4);
        bufp->chgCData(oldp+124,(vlSelf->tb_main_datapath__DOT__iss_biq_address2),5);
        bufp->chgCData(oldp+125,(vlSelf->tb_main_datapath__DOT__iss_rob_index2),6);
        bufp->chgBit(oldp+126,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stall_frontend));
        bufp->chgBit(oldp+127,(((0xfU == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT__BMR)) 
                                | ((0x3fU & ((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__tail) 
                                             - (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__head))) 
                                   < (0x3fU & ((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__pop1) 
                                               + (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__pop2)))))));
        bufp->chgBit(oldp+128,(((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_full) 
                                | (0x3fU <= (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_count)))));
        bufp->chgCData(oldp+129,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_predecode_instr1),2);
        bufp->chgCData(oldp+130,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_predecode_instr2),2);
        bufp->chgIData(oldp+131,(((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__id_jump1)
                                   ? ((IData)(4U) + 
                                      (vlSelf->tb_main_datapath__DOT__dut__DOT__id_pc 
                                       << 2U)) : ((IData)(8U) 
                                                  + 
                                                  (vlSelf->tb_main_datapath__DOT__dut__DOT__id_pc 
                                                   << 2U)))),32);
        bufp->chgBit(oldp+132,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_valid1));
        bufp->chgBit(oldp+133,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_valid2));
        bufp->chgIData(oldp+134,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_pc),32);
        bufp->chgIData(oldp+135,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_pred_target1),32);
        bufp->chgBit(oldp+136,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_pred_taken1));
        bufp->chgBit(oldp+137,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_btb_hit1));
        bufp->chgSData(oldp+138,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_pht_index1),9);
        bufp->chgCData(oldp+139,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_sp_snap),3);
        bufp->chgQData(oldp+140,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_ras_snap),64);
        bufp->chgSData(oldp+142,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_prev_ghr),9);
        bufp->chgBit(oldp+143,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_valid1));
        bufp->chgBit(oldp+144,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_valid2));
        bufp->chgIData(oldp+145,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_pc),30);
        bufp->chgIData(oldp+146,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1),32);
        bufp->chgIData(oldp+147,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2),32);
        bufp->chgIData(oldp+148,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_pred_target1),32);
        bufp->chgBit(oldp+149,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_pred_taken1));
        bufp->chgBit(oldp+150,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_btb_hit1));
        bufp->chgSData(oldp+151,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_pht_index1),9);
        bufp->chgCData(oldp+152,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_sp_snap),3);
        bufp->chgQData(oldp+153,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_ras_snap),64);
        bufp->chgSData(oldp+155,(vlSelf->tb_main_datapath__DOT__dut__DOT__if_prev_ghr),9);
        bufp->chgBit(oldp+156,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_take_snap));
        bufp->chgBit(oldp+157,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_valid1));
        bufp->chgBit(oldp+158,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_valid2));
        bufp->chgIData(oldp+159,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_pc),30);
        bufp->chgCData(oldp+160,((0x1fU & (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__biq_tail_ptr))),5);
        bufp->chgCData(oldp+161,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_alu_operation1),5);
        bufp->chgCData(oldp+162,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_alu_operation2),5);
        bufp->chgBit(oldp+163,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_is_m_extension1));
        bufp->chgBit(oldp+164,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_is_m_extension2));
        bufp->chgCData(oldp+165,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_rs1_1),5);
        bufp->chgCData(oldp+166,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_rs2_1),5);
        bufp->chgCData(oldp+167,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_rd_1),5);
        bufp->chgCData(oldp+168,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_rs1_2),5);
        bufp->chgCData(oldp+169,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_rs2_2),5);
        bufp->chgCData(oldp+170,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_rd_2),5);
        bufp->chgBit(oldp+171,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_jump_reg1));
        bufp->chgBit(oldp+172,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_jump1));
        bufp->chgBit(oldp+173,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_branch1));
        bufp->chgBit(oldp+174,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_regsrc1_1));
        bufp->chgBit(oldp+175,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_regsrc2_1));
        bufp->chgBit(oldp+176,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_immtype1));
        bufp->chgBit(oldp+177,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_memwrite1));
        bufp->chgBit(oldp+178,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_regwrite1));
        bufp->chgBit(oldp+179,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_memtoreg1));
        bufp->chgBit(oldp+180,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_retaddr1));
        bufp->chgBit(oldp+181,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_isimm1));
        bufp->chgBit(oldp+182,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_upperimm1));
        bufp->chgIData(oldp+183,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_immout1),21);
        bufp->chgBit(oldp+184,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_jump_reg2));
        bufp->chgBit(oldp+185,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_jump2));
        bufp->chgBit(oldp+186,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_branch2));
        bufp->chgBit(oldp+187,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_regsrc1_2));
        bufp->chgBit(oldp+188,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_regsrc2_2));
        bufp->chgBit(oldp+189,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_immtype2));
        bufp->chgBit(oldp+190,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_memwrite2));
        bufp->chgBit(oldp+191,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_regwrite2));
        bufp->chgBit(oldp+192,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_memtoreg2));
        bufp->chgBit(oldp+193,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_retaddr2));
        bufp->chgBit(oldp+194,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_isimm2));
        bufp->chgBit(oldp+195,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_upperimm2));
        bufp->chgIData(oldp+196,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_immout2),21);
        bufp->chgCData(oldp+197,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_prd1),6);
        bufp->chgCData(oldp+198,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_prs1_1),6);
        bufp->chgCData(oldp+199,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_prs2_1),6);
        bufp->chgCData(oldp+200,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_old_prd1),6);
        bufp->chgCData(oldp+201,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_prd2),6);
        bufp->chgCData(oldp+202,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_prs1_2),6);
        bufp->chgCData(oldp+203,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_prs2_2),6);
        bufp->chgCData(oldp+204,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_old_prd2),6);
        bufp->chgBit(oldp+205,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_prs1_busy1));
        bufp->chgBit(oldp+206,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_prs2_busy1));
        bufp->chgBit(oldp+207,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_prs1_busy2));
        bufp->chgBit(oldp+208,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_prs2_busy2));
        bufp->chgCData(oldp+209,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT__current_btag),2);
        bufp->chgCData(oldp+210,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT__BMR),4);
        bufp->chgCData(oldp+211,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_biq_address),5);
        bufp->chgIData(oldp+212,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_pc),30);
        bufp->chgCData(oldp+213,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_rd_1),5);
        bufp->chgCData(oldp+214,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_rd_2),5);
        bufp->chgIData(oldp+215,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_immout1),21);
        bufp->chgIData(oldp+216,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_immout2),21);
        bufp->chgBit(oldp+217,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_is_m_extension1));
        bufp->chgBit(oldp+218,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_is_m_extension2));
        bufp->chgCData(oldp+219,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_alu_operation1),5);
        bufp->chgCData(oldp+220,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_alu_operation2),5);
        bufp->chgBit(oldp+221,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_valid1));
        bufp->chgBit(oldp+222,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_jump_reg1));
        bufp->chgBit(oldp+223,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_jump1));
        bufp->chgBit(oldp+224,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_branch1));
        bufp->chgBit(oldp+225,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_regsrc1_1));
        bufp->chgBit(oldp+226,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_regsrc2_1));
        bufp->chgBit(oldp+227,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_immtype1));
        bufp->chgBit(oldp+228,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_isimm1));
        bufp->chgBit(oldp+229,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_retaddr1));
        bufp->chgBit(oldp+230,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_upperimm1));
        bufp->chgBit(oldp+231,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_regwrite1));
        bufp->chgBit(oldp+232,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_memwrite1));
        bufp->chgBit(oldp+233,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_memtoreg1));
        bufp->chgBit(oldp+234,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_valid2));
        bufp->chgBit(oldp+235,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_jump_reg2));
        bufp->chgBit(oldp+236,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_jump2));
        bufp->chgBit(oldp+237,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_branch2));
        bufp->chgBit(oldp+238,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_regsrc1_2));
        bufp->chgBit(oldp+239,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_regsrc2_2));
        bufp->chgBit(oldp+240,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_immtype2));
        bufp->chgBit(oldp+241,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_isimm2));
        bufp->chgBit(oldp+242,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_retaddr2));
        bufp->chgBit(oldp+243,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_upperimm2));
        bufp->chgBit(oldp+244,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_regwrite2));
        bufp->chgBit(oldp+245,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_memwrite2));
        bufp->chgBit(oldp+246,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_memtoreg2));
        bufp->chgBit(oldp+247,((0x3fU <= (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_count))));
        bufp->chgBit(oldp+248,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_full));
        bufp->chgCData(oldp+249,((0x3fU & (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_tail_ptr))),6);
        bufp->chgCData(oldp+250,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__iq_alloc_index1),6);
        bufp->chgCData(oldp+251,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__iq_alloc_index2),6);
        bufp->chgBit(oldp+252,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__alloc1_found));
        bufp->chgBit(oldp+253,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__alloc2_found));
        bufp->chgBit(oldp+254,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__fast_wakeup1));
        bufp->chgBit(oldp+255,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__fast_wakeup2));
        bufp->chgCData(oldp+256,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__fast_waked_reg1),6);
        bufp->chgCData(oldp+257,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__fast_waked_reg2),6);
        bufp->chgCData(oldp+258,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__issue_index1),6);
        bufp->chgCData(oldp+259,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__issue_index2),6);
        bufp->chgBit(oldp+260,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__is_control_flow_instr));
        bufp->chgBit(oldp+261,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__issue1_found));
        bufp->chgBit(oldp+262,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__issue2_found));
        bufp->chgIData(oldp+263,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__unnamedblk2__DOT__i),32);
        bufp->chgIData(oldp+264,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__iq_instantiation__DOT__unnamedblk3__DOT__i),32);
        bufp->chgCData(oldp+265,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_head_ptr),7);
        bufp->chgCData(oldp+266,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_tail_ptr),7);
        bufp->chgCData(oldp+267,(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_count),7);
        bufp->chgCData(oldp+268,((0x7fU & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1)),7);
        bufp->chgCData(oldp+269,((0x7fU & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2)),7);
        bufp->chgCData(oldp+270,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__ALUOp_1),3);
        bufp->chgCData(oldp+271,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__ALUOp_2),3);
        bufp->chgIData(oldp+272,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__imm_out1),21);
        bufp->chgIData(oldp+273,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__imm_out2),21);
        bufp->chgCData(oldp+274,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__alu_operation1),5);
        bufp->chgCData(oldp+275,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__alu_operation2),5);
        bufp->chgBit(oldp+276,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__is_control_flow_instr));
        bufp->chgBit(oldp+277,((IData)((0x2000033U 
                                        == (0x200007fU 
                                            & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1)))));
        bufp->chgBit(oldp+278,((IData)((0x2000033U 
                                        == (0x200007fU 
                                            & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2)))));
        bufp->chgBit(oldp+279,(((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                       >> 6U)) && (
                                                   (1U 
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
        bufp->chgBit(oldp+280,(((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                       >> 6U)) && (
                                                   (1U 
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
        bufp->chgBit(oldp+281,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__Jump_1));
        bufp->chgBit(oldp+282,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__Jump_2));
        bufp->chgBit(oldp+283,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__Branch_1));
        bufp->chgBit(oldp+284,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__Branch_2));
        bufp->chgBit(oldp+285,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__RegSrc1_1));
        bufp->chgBit(oldp+286,(((0x40U & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1)
                                 ? ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                           >> 5U)) 
                                    && ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                  >> 4U))) 
                                        && ((1U & (~ 
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
                                                        & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1))))))
                                 : ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                           >> 5U)) 
                                    && ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                               >> 4U)) 
                                        && ((1U & (~ 
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
        bufp->chgBit(oldp+287,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__RegSrc1_2));
        bufp->chgBit(oldp+288,(((0x40U & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2)
                                 ? ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                           >> 5U)) 
                                    && ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                  >> 4U))) 
                                        && ((1U & (~ 
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
                                                        & vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2))))))
                                 : ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                           >> 5U)) 
                                    && ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                               >> 4U)) 
                                        && ((1U & (~ 
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
        bufp->chgBit(oldp+289,(((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                       >> 6U)) && (
                                                   (1U 
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
        bufp->chgBit(oldp+290,(((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                          >> 6U))) 
                                && ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                           >> 5U)) 
                                    && ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                               >> 4U)) 
                                        && ((1U & (~ 
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
        bufp->chgBit(oldp+291,(((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                          >> 6U))) 
                                && ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                           >> 5U)) 
                                    && ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                               >> 4U)) 
                                        && ((1U & (~ 
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
        bufp->chgBit(oldp+292,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__RegWrite_1));
        bufp->chgBit(oldp+293,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__RegWrite_2));
        bufp->chgBit(oldp+294,(((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                          >> 6U))) 
                                && ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                           >> 5U)) 
                                    && ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                  >> 4U))) 
                                        && ((1U & (~ 
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
        bufp->chgBit(oldp+295,(((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                          >> 6U))) 
                                && ((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                           >> 5U)) 
                                    && ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                  >> 4U))) 
                                        && ((1U & (~ 
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
        bufp->chgBit(oldp+296,(((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                          >> 6U))) 
                                && ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                              >> 5U))) 
                                    && ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                                  >> 4U))) 
                                        && ((1U & (~ 
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
        bufp->chgBit(oldp+297,(((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                          >> 6U))) 
                                && ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                              >> 5U))) 
                                    && ((1U & (~ (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                                  >> 4U))) 
                                        && ((1U & (~ 
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
        bufp->chgBit(oldp+298,(((1U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                       >> 6U)) && (
                                                   (1U 
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
        bufp->chgBit(oldp+299,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__Imm_1));
        bufp->chgBit(oldp+300,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__Imm_2));
        bufp->chgBit(oldp+301,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__imm_type1));
        bufp->chgBit(oldp+302,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__imm_type2));
        bufp->chgCData(oldp+303,((7U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                        >> 0xcU))),3);
        bufp->chgCData(oldp+304,((vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                  >> 0x19U)),7);
        bufp->chgCData(oldp+305,((7U & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                        >> 0xcU))),3);
        bufp->chgCData(oldp+306,((vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                  >> 0x19U)),7);
        bufp->chgWData(oldp+307,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [0U]),118);
        bufp->chgWData(oldp+311,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [1U]),118);
        bufp->chgWData(oldp+315,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [2U]),118);
        bufp->chgWData(oldp+319,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [3U]),118);
        bufp->chgWData(oldp+323,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [4U]),118);
        bufp->chgWData(oldp+327,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [5U]),118);
        bufp->chgWData(oldp+331,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [6U]),118);
        bufp->chgWData(oldp+335,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [7U]),118);
        bufp->chgWData(oldp+339,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [8U]),118);
        bufp->chgWData(oldp+343,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [9U]),118);
        bufp->chgWData(oldp+347,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [0xaU]),118);
        bufp->chgWData(oldp+351,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [0xbU]),118);
        bufp->chgWData(oldp+355,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [0xcU]),118);
        bufp->chgWData(oldp+359,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [0xdU]),118);
        bufp->chgWData(oldp+363,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [0xeU]),118);
        bufp->chgWData(oldp+367,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [0xfU]),118);
        bufp->chgWData(oldp+371,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [0x10U]),118);
        bufp->chgWData(oldp+375,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [0x11U]),118);
        bufp->chgWData(oldp+379,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [0x12U]),118);
        bufp->chgWData(oldp+383,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [0x13U]),118);
        bufp->chgWData(oldp+387,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [0x14U]),118);
        bufp->chgWData(oldp+391,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [0x15U]),118);
        bufp->chgWData(oldp+395,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [0x16U]),118);
        bufp->chgWData(oldp+399,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [0x17U]),118);
        bufp->chgWData(oldp+403,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [0x18U]),118);
        bufp->chgWData(oldp+407,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [0x19U]),118);
        bufp->chgWData(oldp+411,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [0x1aU]),118);
        bufp->chgWData(oldp+415,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [0x1bU]),118);
        bufp->chgWData(oldp+419,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [0x1cU]),118);
        bufp->chgWData(oldp+423,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [0x1dU]),118);
        bufp->chgWData(oldp+427,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [0x1eU]),118);
        bufp->chgWData(oldp+431,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__BIQ
                                 [0x1fU]),118);
        bufp->chgCData(oldp+435,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__biq_head_ptr),6);
        bufp->chgCData(oldp+436,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__biq_instantiation__DOT__biq_tail_ptr),6);
        bufp->chgCData(oldp+437,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__ig_instantiation1__DOT__opcode),7);
        bufp->chgCData(oldp+438,(vlSelf->tb_main_datapath__DOT__dut__DOT__id_stage_inst__DOT__ig_instantiation2__DOT__opcode),7);
        bufp->chgIData(oldp+439,((vlSelf->tb_main_datapath__DOT__dut__DOT__pd_pc 
                                  >> 2U)),30);
        bufp->chgIData(oldp+440,((0x3fffffffU & ((IData)(1U) 
                                                 + 
                                                 (vlSelf->tb_main_datapath__DOT__dut__DOT__pd_pc 
                                                  >> 2U)))),30);
        bufp->chgIData(oldp+441,(VL_SHIFTR_III(32,32,32, vlSelf->tb_main_datapath__DOT__dut__DOT__pd_pc, 2U)),32);
        bufp->chgIData(oldp+442,((0x3fffffffU & ((IData)(1U) 
                                                 + 
                                                 (vlSelf->tb_main_datapath__DOT__dut__DOT__pd_pc 
                                                  >> 2U)))),32);
        bufp->chgCData(oldp+443,((0x1fU & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr1 
                                           >> 7U))),5);
        bufp->chgCData(oldp+444,((0x1fU & (vlSelf->tb_main_datapath__DOT__dut__DOT__if_instr2 
                                           >> 7U))),5);
        bufp->chgSData(oldp+445,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ghr_out),9);
        bufp->chgSData(oldp+446,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__pht_index),9);
        bufp->chgBit(oldp+447,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__pred_taken));
        bufp->chgBit(oldp+448,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__btb_hit));
        bufp->chgBit(oldp+449,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__btb_is_branch));
        bufp->chgBit(oldp+450,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__is_return_instr));
        bufp->chgBit(oldp+451,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__squash_instruction));
        bufp->chgIData(oldp+452,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__pred_return_address),32);
        bufp->chgIData(oldp+453,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__pred_target_address),32);
        bufp->chgCData(oldp+454,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__sp_snap),3);
        bufp->chgQData(oldp+455,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_snap),64);
        bufp->chgIData(oldp+457,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__next_pc),32);
        bufp->chgBit(oldp+458,((3U == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__if_predecode_instr1))));
        bufp->chgBit(oldp+459,((3U == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__if_predecode_instr2))));
        bufp->chgIData(oldp+460,((vlSelf->tb_main_datapath__DOT__dut__DOT__pd_pc 
                                  >> 9U)),23);
        bufp->chgCData(oldp+461,((0x3fU & (vlSelf->tb_main_datapath__DOT__dut__DOT__pd_pc 
                                           >> 3U))),6);
        bufp->chgIData(oldp+462,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__btb_instantiation__DOT__unnamedblk1__DOT__i),32);
        bufp->chgIData(oldp+463,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_instantiation__DOT__RAS[0]),32);
        bufp->chgIData(oldp+464,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_instantiation__DOT__RAS[1]),32);
        bufp->chgIData(oldp+465,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_instantiation__DOT__RAS[2]),32);
        bufp->chgIData(oldp+466,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_instantiation__DOT__RAS[3]),32);
        bufp->chgIData(oldp+467,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_instantiation__DOT__RAS[4]),32);
        bufp->chgIData(oldp+468,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_instantiation__DOT__RAS[5]),32);
        bufp->chgIData(oldp+469,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_instantiation__DOT__RAS[6]),32);
        bufp->chgIData(oldp+470,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_instantiation__DOT__RAS[7]),32);
        bufp->chgCData(oldp+471,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_instantiation__DOT__sp),3);
        bufp->chgCData(oldp+472,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_instantiation__DOT__next_sp),3);
        bufp->chgBit(oldp+473,(vlSelf->tb_main_datapath__DOT__dut__DOT__pd_stage_inst__DOT__ras_instantiation__DOT__push));
        bufp->chgBit(oldp+474,((2U == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__if_predecode_instr1))));
        bufp->chgBit(oldp+475,((2U == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__if_predecode_instr2))));
        bufp->chgBit(oldp+476,((1U == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__if_predecode_instr1))));
        bufp->chgBit(oldp+477,((1U == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__if_predecode_instr2))));
        bufp->chgCData(oldp+478,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_freed_reg1),6);
        bufp->chgCData(oldp+479,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL
                                 [(0x1fU & ((IData)(1U) 
                                            + (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__head)))]),6);
        bufp->chgCData(oldp+480,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__routed_freed_reg2),6);
        bufp->chgBit(oldp+481,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__pop1));
        bufp->chgBit(oldp+482,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__pop2));
        bufp->chgBit(oldp+483,((0xfU == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT__BMR))));
        bufp->chgBit(oldp+484,(((0x3fU & ((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__tail) 
                                          - (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__head))) 
                                < (0x3fU & ((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__pop1) 
                                            + (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__pop2))))));
        bufp->chgBit(oldp+485,(((~ (IData)(vlSelf->tb_main_datapath__DOT__stall_frontend)) 
                                & (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__pop1))));
        bufp->chgBit(oldp+486,(((~ (IData)(vlSelf->tb_main_datapath__DOT__stall_frontend)) 
                                & (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__pop2))));
        bufp->chgWData(oldp+487,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT__BS
                                 [0U]),202);
        bufp->chgWData(oldp+494,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT__BS
                                 [1U]),202);
        bufp->chgWData(oldp+501,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT__BS
                                 [2U]),202);
        bufp->chgWData(oldp+508,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT__BS
                                 [3U]),202);
        bufp->chgIData(oldp+515,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT__unnamedblk1__DOT__i),32);
        bufp->chgIData(oldp+516,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__bs_instantiation__DOT__unnamedblk2__DOT__i),32);
        bufp->chgCData(oldp+517,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[0]),6);
        bufp->chgCData(oldp+518,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[1]),6);
        bufp->chgCData(oldp+519,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[2]),6);
        bufp->chgCData(oldp+520,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[3]),6);
        bufp->chgCData(oldp+521,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[4]),6);
        bufp->chgCData(oldp+522,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[5]),6);
        bufp->chgCData(oldp+523,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[6]),6);
        bufp->chgCData(oldp+524,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[7]),6);
        bufp->chgCData(oldp+525,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[8]),6);
        bufp->chgCData(oldp+526,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[9]),6);
        bufp->chgCData(oldp+527,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[10]),6);
        bufp->chgCData(oldp+528,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[11]),6);
        bufp->chgCData(oldp+529,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[12]),6);
        bufp->chgCData(oldp+530,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[13]),6);
        bufp->chgCData(oldp+531,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[14]),6);
        bufp->chgCData(oldp+532,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[15]),6);
        bufp->chgCData(oldp+533,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[16]),6);
        bufp->chgCData(oldp+534,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[17]),6);
        bufp->chgCData(oldp+535,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[18]),6);
        bufp->chgCData(oldp+536,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[19]),6);
        bufp->chgCData(oldp+537,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[20]),6);
        bufp->chgCData(oldp+538,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[21]),6);
        bufp->chgCData(oldp+539,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[22]),6);
        bufp->chgCData(oldp+540,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[23]),6);
        bufp->chgCData(oldp+541,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[24]),6);
        bufp->chgCData(oldp+542,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[25]),6);
        bufp->chgCData(oldp+543,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[26]),6);
        bufp->chgCData(oldp+544,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[27]),6);
        bufp->chgCData(oldp+545,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[28]),6);
        bufp->chgCData(oldp+546,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[29]),6);
        bufp->chgCData(oldp+547,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[30]),6);
        bufp->chgCData(oldp+548,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__FL[31]),6);
        bufp->chgCData(oldp+549,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__head),6);
        bufp->chgCData(oldp+550,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__tail),6);
        bufp->chgCData(oldp+551,((0x3fU & ((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__pop1) 
                                           + (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__pop2)))),6);
        bufp->chgIData(oldp+552,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT__unnamedblk1__DOT__i),32);
        bufp->chgBit(oldp+553,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT____Vcellinp__rmt_instantiation__reg_write1));
        bufp->chgBit(oldp+554,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT____Vcellinp__rmt_instantiation__reg_write2));
        bufp->chgWData(oldp+555,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT__RMT),192);
        bufp->chgQData(oldp+561,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT__busy_table),64);
        bufp->chgIData(oldp+563,(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT__unnamedblk1__DOT__i),32);
    }
    bufp->chgBit(oldp+564,(vlSelf->tb_main_datapath__DOT__CLK));
    bufp->chgBit(oldp+565,((IData)((((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_head_ptr) 
                                     >> 6U) ^ ((IData)(vlSelf->tb_main_datapath__DOT__cdb_branch_rob_index) 
                                               < (0x3fU 
                                                  & (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__dis_stage_inst__DOT__rob_instantiation__DOT__rob_head_ptr)))))));
    bufp->chgBit(oldp+566,(((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__pop2) 
                            & (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__fl_instantiation__DOT____VdfgTmp_h88188f2f__0))));
    bufp->chgBit(oldp+567,((((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_h7b899e3c__0) 
                             & ((IData)(vlSelf->tb_main_datapath__DOT__cdb_waked_reg1) 
                                == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_haa9ae981__0))) 
                            | ((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_h3f3ce8d6__0) 
                               & ((IData)(vlSelf->tb_main_datapath__DOT__cdb_waked_reg2) 
                                  == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_haa9ae981__0))))));
    bufp->chgBit(oldp+568,((((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_h7b899e3c__0) 
                             & ((IData)(vlSelf->tb_main_datapath__DOT__cdb_waked_reg1) 
                                == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_h0a75576f__0))) 
                            | ((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_h3f3ce8d6__0) 
                               & ((IData)(vlSelf->tb_main_datapath__DOT__cdb_waked_reg2) 
                                  == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_h0a75576f__0))))));
    bufp->chgBit(oldp+569,((((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_h7b899e3c__0) 
                             & ((IData)(vlSelf->tb_main_datapath__DOT__cdb_waked_reg1) 
                                == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_hbc67dbad__0))) 
                            | ((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_h3f3ce8d6__0) 
                               & ((IData)(vlSelf->tb_main_datapath__DOT__cdb_waked_reg2) 
                                  == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_hbc67dbad__0))))));
    bufp->chgBit(oldp+570,((((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_h7b899e3c__0) 
                             & ((IData)(vlSelf->tb_main_datapath__DOT__cdb_waked_reg1) 
                                == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_hcee7f012__0))) 
                            | ((IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_h3f3ce8d6__0) 
                               & ((IData)(vlSelf->tb_main_datapath__DOT__cdb_waked_reg2) 
                                  == (IData)(vlSelf->tb_main_datapath__DOT__dut__DOT__rn_stage_inst__DOT__rmt_instantiation__DOT____VdfgTmp_hcee7f012__0))))));
}

void Vtb_main_datapath___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_main_datapath___024root__trace_cleanup\n"); );
    // Init
    Vtb_main_datapath___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtb_main_datapath___024root*>(voidSelf);
    Vtb_main_datapath__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[2U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[3U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[4U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[5U] = 0U;
}
