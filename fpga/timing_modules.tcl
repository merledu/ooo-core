# Worst path into every module of the core, with the cells it goes through.
#   vivado -mode batch -source timing_modules.tcl -tclargs [period ns] [checkpoint]
# Writes build/timing_modules_<checkpoint>_<period>.rpt (summary) and ..._detail.rpt (one path per module)
set period [expr {[llength $argv] > 0 ? [lindex $argv 0] : 6.67}]
set here   [file dirname [file normalize [info script]]]
set dcp    [expr {[llength $argv] > 1 ? [lindex $argv 1] : "$here/build/post_synth.dcp"}]
set tag    [file rootname [file tail $dcp]]_${period}

open_checkpoint $dcp
create_clock -name CLK -period $period [get_ports CLK]

# modules: the stage instances and the instances directly inside them
set mods {}
foreach c [get_cells -filter {IS_PRIMITIVE == 0}] {
    lappend mods [get_property NAME $c]
    foreach s [get_cells -quiet -filter {IS_PRIMITIVE == 0} "[get_property NAME $c]/*"] {
        lappend mods [get_property NAME $s]
    }
}

set fd  [open $here/build/timing_modules_${tag}.rpt w]
set fdd [open $here/build/timing_modules_${tag}_detail.rpt w]
puts $fd "Worst path ending in each module at $period ns ([format %.1f [expr {1000.0 / $period}]] MHz)"
puts $fd [format "%-50s %8s %8s %6s %7s  %s" module WNS failing levels fanout "starts at"]
set rows {}
foreach m $mods {
    set regs [get_cells -quiet -hier -filter "NAME =~ $m/* && IS_SEQUENTIAL"]
    if {[llength $regs] == 0} continue
    set p [get_timing_paths -quiet -setup -to $regs -max_paths 1]
    if {[llength $p] == 0} continue
    set slack [get_property SLACK $p]
    if {$slack eq "" || $slack >= 0} continue
    set nfail [llength [get_timing_paths -quiet -setup -to $regs -max_paths 100000 -nworst 1 -unique_pins -slack_lesser_than 0]]
    set fo 0
    foreach n [get_nets -quiet -of_objects $p] { set f [get_property FLAT_PIN_COUNT $n]; if {$f > $fo} { set fo $f } }
    lappend rows [list $slack $m $nfail [get_property LOGIC_LEVELS $p] $fo [get_property NAME [get_property STARTPOINT_PIN $p]] $p]
}
foreach r [lsort -real -index 0 $rows] {
    lassign $r slack m nfail lv fo sp p
    puts $fd [format "%-50s %8.3f %8d %6d %7d  %s" $m $slack $nfail $lv $fo $sp]
}
close $fd
# full report of each module's worst path (shows which logic the path goes through)
close $fdd
file delete $here/build/timing_modules_${tag}_detail.rpt
foreach r [lsort -real -index 0 $rows] {
    report_timing -of_objects [lindex $r 6] -append -file $here/build/timing_modules_${tag}_detail.rpt
}
report_design_analysis -logic_level_distribution -logic_level_dist_paths 100000 -file $here/build/timing_modules_${tag}_levels.rpt
puts "written $here/build/timing_modules_${tag}.rpt"
