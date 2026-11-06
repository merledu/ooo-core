# Timing map of the core: which modules have paths that are too long for the target clock.
#   vivado -mode batch -source timing_map.tcl -tclargs [period ns] [checkpoint]
# Default: 6.67 ns (150 MHz) on build/post_synth.dcp. Writes build/timing_map_<checkpoint>_<period>*.rpt
set period [expr {[llength $argv] > 0 ? [lindex $argv 0] : 6.67}]
set here   [file dirname [file normalize [info script]]]
set dcp    [expr {[llength $argv] > 1 ? [lindex $argv 1] : "$here/build/post_synth.dcp"}]
set tag    [file rootname [file tail $dcp]]_${period}
set out    $here/build/timing_map_${tag}.rpt

open_checkpoint $dcp
create_clock -name CLK -period $period [get_ports CLK]

set fd [open $out w]
puts $fd "Timing map at $period ns ([format %.1f [expr {1000.0 / $period}]] MHz), checkpoint $dcp"
puts $fd ""

# worst path ending in each module (endpoint = register inside that module)
set paths [get_timing_paths -setup -max_paths 20000 -nworst 1 -unique_pins -slack_lesser_than 0]
puts $fd "failing endpoints (one path each): [llength $paths]"
puts $fd ""
array set worst {}
array set count {}
array set levels {}
array set src {}
foreach p $paths {
    set ep [get_property NAME [get_property ENDPOINT_PIN $p]]
    set parts [split $ep /]
    # module = first two hierarchy levels (stage/unit), or the first one for top level cells
    set mod [expr {[llength $parts] > 2 ? "[lindex $parts 0]/[lindex $parts 1]" : [lindex $parts 0]}]
    set slack [get_property SLACK $p]
    incr count($mod)
    if {![info exists worst($mod)] || $slack < $worst($mod)} {
        set worst($mod)  $slack
        set levels($mod) [get_property LOGIC_LEVELS $p]
        set src($mod)    [get_property NAME [get_property STARTPOINT_PIN $p]]
    }
}
puts $fd [format "%-55s %9s %9s %7s  %s" "module (endpoint)" "WNS ns" "failing" "levels" "worst path starts at"]
set rows {}
foreach mod [array names worst] { lappend rows [list $worst($mod) $mod] }
foreach row [lsort -real -index 0 $rows] {
    set mod [lindex $row 1]
    puts $fd [format "%-55s %9.3f %9d %7d  %s" $mod $worst($mod) $count($mod) $levels($mod) $src($mod)]
}
close $fd

# logic level distribution and the 50 worst paths with their full detail
report_design_analysis -logic_level_distribution -logic_level_dist_paths 5000 -file $here/build/timing_map_${tag}_levels.rpt
report_timing -max_paths 50 -nworst 1 -unique_pins -file $here/build/timing_map_${tag}_paths.rpt
# nets with the most loads (flush, stall, branch mask, CDB tags): long wires that synthesis estimates poorly
report_high_fanout_nets -max_nets 40 -timing -file $here/build/timing_map_${tag}_fanout.rpt
puts "written $out"
