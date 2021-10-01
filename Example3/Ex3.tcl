# Creating New Simulator
set ns [new Simulator]

# Setting up the traces
set f [open outEx3.tr w]
set nf [open outEx3.nam w]
$ns namtrace-all $nf
$ns trace-all $f

#To finish procedure
proc finish {} {
	global ns nf f
	$ns flush-trace
	puts "Simulation completed."
	close $f
	exec nam outEx3.nam &
	close $nf
	exit 0
}

# Create Nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

# Labelling
$n0 label "TCP Source"
$n1 label "UDP Source"
$n2 label "Router"
$n3 label "Destination"

#Setup Connections
$ns duplex-link $n0 $n2 10Mb 10ms DropTail
$ns duplex-link $n1 $n2 10Kb 100ms DropTail
$ns duplex-link $n2 $n3 10Kb 10ms DropTail

#$ns queue-limit $n0 $n1 10
#$ns queue-limit $n1 $n2 10

#Set up Transportation Level Connections
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n3 $sink0
$ns connect $tcp0 $sink0

set udp0 [new Agent/UDP]
$ns attach-agent $n1 $udp0
set null0 [new Agent/Null]
$ns attach-agent $n3 $null0
$ns connect $udp0 $null0

#Setup traffic sources
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0

$ftp0 set rate_ 0.01
$ftp0 set packetSize_ 200

$udp0 set rate_ 0.001
$udp0 set packetSize_ 300


# Setting colors
$ns color 1 "red"
$ns color 2 "blue"

$tcp0 set class_ 1
$udp0 set class_ 2

#Start up the sources
$ns at 0.1 "$cbr0 start"
$ns at 0.3 "$ftp0 start"
$ns at 5.0 "$ftp0 stop"
$ns at 5.0 "$cbr0 stop"
$ns at 6.0 "finish"
$ns run

