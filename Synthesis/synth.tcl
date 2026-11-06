# Vivado (non-project) synthesis + implementation of the core for the Artix-7 A100T.
#   vivado -mode batch -source synth.tcl                     (synthesis, place and route)
#   vivado -mode batch -source synth.tcl -tclargs synth      (synthesis only)
#   vivado -mode batch -source synth.tcl -tclargs all 20.0   (clock period in ns, default 20)
# The core is built out of context (no I/O buffers): the numbers are those of the core itself.
set stage  [expr {[llength $argv] > 0 ? [lindex $argv 0] : "all"}]
set period [expr {[llength $argv] > 1 ? [lindex $argv 1] : 20.0}]
set part   xc7a100tcsg324-1
set here   [file dirname [file normalize [info script]]]
set design [file normalize $here/../Design]
set out    $here/build
file mkdir $out

set srcs {}
foreach f [lsort [glob $design/*.sv]] {
    if {![string match "tb_*" [file tail $f]]} { lappend srcs $f }
}
read_verilog -sv $srcs
# program in the instruction memory
set hex [file normalize $design/instructions.hex]

synth_design -top main_datapath -part $part -mode out_of_context -flatten_hierarchy rebuilt \
    -verilog_define SYNTHESIS -generic "HEX_FILE=\"$hex\""
create_clock -name CLK -period $period [get_ports CLK]
write_checkpoint -force $out/post_synth.dcp
report_utilization -file $out/utilization_synth.rpt
report_utilization -hierarchical -file $out/utilization_synth_hier.rpt
report_timing_summary -file $out/timing_synth.rpt
report_timing -max_paths 5 -file $out/timing_paths_synth.rpt

if {$stage ne "synth"} {
    opt_design
    place_design
    phys_opt_design
    route_design
    write_checkpoint -force $out/post_route.dcp
    report_utilization -file $out/utilization_route.rpt
    report_timing_summary -file $out/timing_route.rpt
    report_timing -max_paths 10 -file $out/timing_paths_route.rpt
}

set wns [get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]]
puts [format "RESULT stage=%s period=%.2f ns  WNS=%.3f ns  Fmax=%.1f MHz" $stage $period $wns [expr {1000.0 / ($period - $wns)}]]
