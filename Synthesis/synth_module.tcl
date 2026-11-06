# Out-of-context synthesis of one module: vivado -mode batch -source synth_module.tcl -tclargs <module> [period ns]
set top    [lindex $argv 0]
set period [expr {[llength $argv] > 1 ? [lindex $argv 1] : 20.0}]
set here   [file dirname [file normalize [info script]]]
set design [file normalize $here/../Design]
set out    $here/build/modules
file mkdir $out
set srcs {}
foreach f [lsort [glob $design/*.sv]] {
    if {![string match "tb_*" [file tail $f]]} { lappend srcs $f }
}
read_verilog -sv $srcs
synth_design -top $top -part xc7a100tcsg324-1 -mode out_of_context -verilog_define SYNTHESIS
create_clock -name CLK -period $period [get_ports CLK]
report_utilization -file $out/${top}_utilization.rpt
report_timing -max_paths 3 -file $out/${top}_timing.rpt
set wns [get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]]
set luts [llength [get_cells -hier -filter {REF_NAME =~ LUT*}]]
set ffs  [llength [get_cells -hier -filter {REF_NAME =~ FD*}]]
puts [format "RESULT %s LUT=%d FF=%d reg-to-reg delay=%.2f ns" $top $luts $ffs [expr {$period - $wns}]]
