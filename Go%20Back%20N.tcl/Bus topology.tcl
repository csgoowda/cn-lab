set ns [new Simulator]

set tr [open out.tr w]
$ns trace-all $tr

set nam [open out.nam w]
$ns namtrace-all $nam

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

set lan_nodes "$n0 $n1 $n2 $n3 $n4"
$ns newLan $lan_nodes 10Mb 10ms LL Queue/DropTail Mac/802_3 Channel

set tcp [new Agent/TCP]
set sink [new Agent/TCPSink]

$ns attach-agent $n0 $tcp
$ns attach-agent $n3 $sink
$ns connect $tcp $sink

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $tcp

$ns at 0.2 "$cbr start"
$ns at 2.2 "$cbr stop"

proc finish {} {
    global ns tr nam
    $ns flush-trace
    close $tr
    close $nam
    exec nam out.nam &
    exit 0
}

$ns at 2.6 "finish"
$ns run
