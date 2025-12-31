set ns [new Simulator]

set tr [open sliding_window.tr w]
$ns trace-all $tr

set nam [open sliding_window.nam w]
$ns namtrace-all $nam

proc finish {} {
    global ns tr nam
    $ns flush-trace
    close $tr
    close $nam
    exec nam sliding_window.nam &
    exit 0
}

set n0 [$ns node]
set n1 [$ns node]

$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns queue-limit $n0 $n1 10

set tcp [new Agent/TCP]
$tcp set window_ 5
$tcp set packetSize_ 512
$ns attach-agent $n0 $tcp

set sink [new Agent/TCPSink]
$ns attach-agent $n1 $sink
$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp

$ns at 0.5 "$ftp start"
$ns at 6.0 "$ftp stop"
$ns at 6.5 "finish"

$ns run
