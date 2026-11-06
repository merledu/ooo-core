# Place and route from the synthesis checkpoint: vivado -mode batch -source impl.tcl -tclargs [period ns]
set period [expr {[llength $argv] > 0 ? [lindex $argv 0] : 32.0}]
set out [file dirname [file normalize [info script]]]/build
open_checkpoint $out/post_synth.dcp
create_clock -name CLK -period $period [get_ports CLK]
opt_design
place_design
phys_opt_design
route_design
write_checkpoint -force $out/post_route.dcp
report_utilization -file $out/utilization_route.rpt
report_timing_summary -file $out/timing_route.rpt
report_timing -max_paths 10 -file $out/timing_paths_route.rpt
set wns [get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]]
puts [format "RESULT stage=route period=%.2f ns  WNS=%.3f ns  Fmax=%.1f MHz" $period $wns [expr {1000.0 / ($period - $wns)}]]
