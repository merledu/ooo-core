// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtb_main_datapath.h for the primary calling header

#include "Vtb_main_datapath__pch.h"
#include "Vtb_main_datapath__Syms.h"
#include "Vtb_main_datapath___024root.h"

void Vtb_main_datapath___024root___ctor_var_reset(Vtb_main_datapath___024root* vlSelf);

Vtb_main_datapath___024root::Vtb_main_datapath___024root(Vtb_main_datapath__Syms* symsp, const char* v__name)
    : VerilatedModule{v__name}
    , __VdlySched{*symsp->_vm_contextp__}
    , vlSymsp{symsp}
 {
    // Reset structure values
    Vtb_main_datapath___024root___ctor_var_reset(this);
}

void Vtb_main_datapath___024root::__Vconfigure(bool first) {
    if (false && first) {}  // Prevent unused
}

Vtb_main_datapath___024root::~Vtb_main_datapath___024root() {
}
