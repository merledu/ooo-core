// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_main_datapath.h for the primary calling header

#include "Vtb_main_datapath__pch.h"
#include "Vtb_main_datapath__Syms.h"
#include "Vtb_main_datapath___024root.h"

VL_INLINE_OPT VlCoroutine Vtb_main_datapath___024root___eval_initial__TOP__Vtiming__0(Vtb_main_datapath___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_main_datapath__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_main_datapath___024root___eval_initial__TOP__Vtiming__0\n"); );
    // Init
    VlWide<3>/*95:0*/ __Vtemp_1;
    // Body
    __Vtemp_1[0U] = 0x2e766364U;
    __Vtemp_1[1U] = 0x666f726dU;
    __Vtemp_1[2U] = 0x77617665U;
    vlSymsp->_vm_contextp__->dumpfile(VL_CVT_PACK_STR_NW(3, __Vtemp_1));
    vlSymsp->_traceDumpOpen();
    vlSelf->tb_main_datapath__DOT__CLK = 0U;
    vlSelf->tb_main_datapath__DOT__reset = 1U;
    vlSelf->tb_main_datapath__DOT__flush = 0U;
    vlSelf->tb_main_datapath__DOT__actual_taken = 0U;
    vlSelf->tb_main_datapath__DOT__mispredict = 0U;
    vlSelf->tb_main_datapath__DOT__restore_ghr = 0U;
    vlSelf->tb_main_datapath__DOT__restore_ras = 0U;
    vlSelf->tb_main_datapath__DOT__update_pht = 0U;
    vlSelf->tb_main_datapath__DOT__update_btb = 0U;
    vlSelf->tb_main_datapath__DOT__update_ras = 0U;
    vlSelf->tb_main_datapath__DOT__ex_is_ret = 0U;
    vlSelf->tb_main_datapath__DOT__ex_is_branch = 0U;
    vlSelf->tb_main_datapath__DOT__ex_is_jalr = 0U;
    vlSelf->tb_main_datapath__DOT__branch_mispredicted = 0U;
    vlSelf->tb_main_datapath__DOT__dis_biq_dealloc = 0U;
    vlSelf->tb_main_datapath__DOT__rr_slot_id = 0U;
    vlSelf->tb_main_datapath__DOT__rr_biq_id = 0U;
    vlSelf->tb_main_datapath__DOT__cdb_done1 = 0U;
    vlSelf->tb_main_datapath__DOT__cdb_done2 = 0U;
    vlSelf->tb_main_datapath__DOT__cdb_wakeup1 = 0U;
    vlSelf->tb_main_datapath__DOT__cdb_wakeup2 = 0U;
    vlSelf->tb_main_datapath__DOT__comm_free_push1 = 0U;
    vlSelf->tb_main_datapath__DOT__comm_free_push2 = 0U;
    vlSelf->tb_main_datapath__DOT__cdb_branch_resolved = 0U;
    vlSelf->tb_main_datapath__DOT__cdb_branch_correct = 0U;
    vlSelf->tb_main_datapath__DOT__cdb_waked_reg1 = 0U;
    vlSelf->tb_main_datapath__DOT__cdb_waked_reg2 = 0U;
    vlSelf->tb_main_datapath__DOT__comm_free_reg1 = 0U;
    vlSelf->tb_main_datapath__DOT__comm_free_reg2 = 0U;
    vlSelf->tb_main_datapath__DOT__cdb_branch_tag = 0U;
    vlSelf->tb_main_datapath__DOT__cdb_rob_index1 = 0U;
    vlSelf->tb_main_datapath__DOT__cdb_rob_index2 = 0U;
    vlSelf->tb_main_datapath__DOT__cdb_branch_rob_index = 0U;
    co_await vlSelf->__VdlySched.delay(0xaULL, nullptr, 
                                       "/home/mutahir/Documents/SV/ooo-core/Design/tb_main_datapath.sv", 
                                       107);
    vlSelf->__Vm_traceActivity[2U] = 1U;
    vlSelf->tb_main_datapath__DOT__reset = 0U;
    co_await vlSelf->__VdlySched.delay(0x3cULL, nullptr, 
                                       "/home/mutahir/Documents/SV/ooo-core/Design/tb_main_datapath.sv", 
                                       108);
    vlSelf->__Vm_traceActivity[2U] = 1U;
    vlSelf->tb_main_datapath__DOT__cdb_wakeup1 = 1U;
    vlSelf->tb_main_datapath__DOT__cdb_waked_reg1 = 1U;
    co_await vlSelf->__VdlySched.delay(0xaULL, nullptr, 
                                       "/home/mutahir/Documents/SV/ooo-core/Design/tb_main_datapath.sv", 
                                       112);
    vlSelf->__Vm_traceActivity[2U] = 1U;
    vlSelf->tb_main_datapath__DOT__cdb_wakeup1 = 0U;
    co_await vlSelf->__VdlySched.delay(0x64ULL, nullptr, 
                                       "/home/mutahir/Documents/SV/ooo-core/Design/tb_main_datapath.sv", 
                                       115);
    vlSelf->__Vm_traceActivity[2U] = 1U;
    VL_FINISH_MT("/home/mutahir/Documents/SV/ooo-core/Design/tb_main_datapath.sv", 115, "");
    vlSelf->__Vm_traceActivity[2U] = 1U;
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtb_main_datapath___024root___dump_triggers__act(Vtb_main_datapath___024root* vlSelf);
#endif  // VL_DEBUG

void Vtb_main_datapath___024root___eval_triggers__act(Vtb_main_datapath___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtb_main_datapath__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtb_main_datapath___024root___eval_triggers__act\n"); );
    // Body
    vlSelf->__VactTriggered.set(0U, ((IData)(vlSelf->tb_main_datapath__DOT__CLK) 
                                     & (~ (IData)(vlSelf->__Vtrigprevexpr___TOP__tb_main_datapath__DOT__CLK__0))));
    vlSelf->__VactTriggered.set(1U, vlSelf->__VdlySched.awaitingCurrentTime());
    vlSelf->__Vtrigprevexpr___TOP__tb_main_datapath__DOT__CLK__0 
        = vlSelf->tb_main_datapath__DOT__CLK;
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtb_main_datapath___024root___dump_triggers__act(vlSelf);
    }
#endif
}
