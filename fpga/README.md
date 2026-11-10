# FPGA

Vivado scripts for the Artix-7 **xc7a100tcsg324-1**. The core is built out of context (no I/O buffers), so the
numbers are those of the core itself. Every script reads the RTL from `../rtl/rtl.f`; the instruction memory is
initialised with `../sim/smoke/instructions.hex`. Output goes to `fpga/build/` (ignored by git).

```bash
cd fpga
vivado -mode batch -source synth.tcl                         # synthesis + place and route, 20 ns clock
vivado -mode batch -source synth.tcl -tclargs synth          # synthesis only
vivado -mode batch -source synth.tcl -tclargs all 6.67       # clock period in ns
vivado -mode batch -source impl.tcl -tclargs 32.0            # place and route from build/post_synth.dcp
vivado -mode batch -source synth_module.tcl -tclargs LSQ     # one module on its own
vivado -mode batch -source timing_map.tcl -tclargs 6.67      # which modules fail 150 MHz
vivado -mode batch -source timing_modules.tcl -tclargs 6.67  # worst path into every module
```

Each run ends with a `RESULT` line (WNS and Fmax). Measured numbers go in [`../docs/scorecard.md`](../docs/scorecard.md).
