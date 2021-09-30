# Creating New Simulator
set ns [new Simulator]

# Setting up the traces
set f [open outEx1.tr w]
set nf [open outEx1.nam w]
$ns namtrace-all $nf
$ns trace-all $f

#To finish procedure
proc finish {} {
	global ns nf f
	$ns flush-trace
	puts "Simulation completed."
	close $f
	exec nam outEx1.nam &
	close $nf
	exit 0
}

# Create Nodes
set n0 [$ns node]
set n1 [$ns node]

#Setup Connections
$ns duplex-link $n0 $n1 2Mb 5ms DropTail


#Set up Transportation Level Connections
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n1 $sink0
$ns connect $tcp0 $sink0

#Setup traffic sources
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set rate_ 0.01
$ftp0 set packetSize_ 200

#Start up the sources
$ns at 0.2 "$ftp0 start"
$ns at 3.0 "$ftp0 stop"
$ns at 3.1 "finish"
$ns run

