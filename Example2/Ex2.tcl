# Creating New Simulator
set ns [new Simulator]

# Setting up the traces
set f [open outEx2.tr w]
set nf [open outEx2.nam w]
$ns namtrace-all $nf
$ns trace-all $f

#To finish procedure
proc finish {} {
	global ns nf f
	$ns flush-trace
	puts "Simulation completed."
	close $f
	exec nam outEx2.nam &
	close $nf
	exit 0
}

# Create Nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

#Setup Connections
$ns duplex-link $n0 $n1 10Kb 100ms DropTail
$ns duplex-link $n1 $n2 5Mb 200ms DropTail
$ns queue-limit $n0 $n1 10
$ns queue-limit $n1 $n2 10

#Set up Transportation Level Connections
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n2 $sink0
$ns connect $tcp0 $sink0

#Setup traffic sources
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set rate_ 0.001
$ftp0 set packetSize_ 500

#Start up the sources
$ns at 0.1 "$ftp0 start"
$ns at 10.0 "$ftp0 stop"
$ns at 10.1 "finish"
$ns run

