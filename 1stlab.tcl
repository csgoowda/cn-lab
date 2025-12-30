# Create simulator
set ns [new Simulator]

# Trace files
set tr [open out.tr w]
$ns trace-all $tr

set nam [open out.nam w]
$ns namtrace-all $nam

# Create 3 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

# Create duplex links
$ns duplex-link $n0 $n1 20Mb 10ms DropTail
$ns duplex-link $n1 $n2 5Mb 10ms DropTail

# Set small queue size
$ns queue-limit $n0 $n1 3
$ns queue-limit $n1 $n2 3

# TCP agent
set tcp [new Agent/TCP]
set sink [new Agent/TCPSink]

$ns attach-agent $n0 $tcp
$ns attach-agent $n2 $sink
$ns connect $tcp $sink

# CBR traffic
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $tcp

# Finish procedure
proc finish {} {
    global ns tr nam
    $ns flush-trace
    close $tr
    close $nam
    exec nam out.nam &
    exec echo "Packets dropped:"
    exec grep "^d" out.tr | wc -l
    exit 0
}

# Start & stop
$ns at 0.1 "$cbr start"
$ns at 1.0 "$cbr stop"
$ns at 1.5 "finish"

# Run simulation
$ns run
