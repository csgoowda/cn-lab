set ns [new Simulator]

set tr [open out.tr w]
$ns trace-all $tr

set nam [open out.nam w]
$ns namtrace-all $nam

set n0 [$ns node]
set n1 [$ns node]

$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns queue-limit $n0 $n1 10

set tcp0 [new Agent/TCP]
$tcp0 set window_ 4
$tcp0 set packetSize_ 512
$ns attach-agent $n0 $tcp0

set sink [new Agent/TCPSink]
$ns attach-agent $n1 $sink
$ns connect $tcp0 $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp0

$ns at 0.5 "$ftp start"
$ns at 8.0 "$ftp stop"

proc finish {} {
    global ns tr nam
    $ns flush-trace
    close $tr
    close $nam
    exec nam out.nam &
    exit 0
}

$ns at 8.5 "finish"
$ns run
