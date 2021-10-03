# Creating New Simulator
set ns [new Simulator]

# Setting up the traces
set f [open outEx6.tr w]
set nf [open outEx6.nam w]
$ns namtrace-all $nf
$ns trace-all $f

#To finish procedure
proc finish {} {
	global ns nf f
	$ns flush-trace
	puts "Simulation completed."
	exec nam outEx6.nam &
	close $nf
	close $f
	exit 0
}

#

#Create Nodes
#
set n0 [$ns node]
puts "n0: [$n0 id]"
set n1 [$ns node]
puts "n1:[$n1 id]"
set n2 [$ns node]
puts "n2: [$n2 id]"
set n3 [$ns node]
puts "n3: [$n3 id]"

#
#Setup Connections
#
$ns duplex-link $n0 $n2 200Mb 10ms DropTail
$ns duplex-link $n1 $n2 100Mb 5ms DropTail
$ns duplex-link $n1 $n3 1Mb 1000ms DropTail
$ns duplex-link $n2 $n3 1Mb 1000ms DropTail

$ns queue-limit $n0 $n2 10
$ns queue-limit $n1 $n2 10
$ns queue-limit $n1 $n3 10
$ns queue-limit $n2 $n3 10

#
#Set up Transportation Level Connections
#
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set null0 [new Agent/Null]
$ns attach-agent $n2 $null0

set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
#set null1 [new Agent/Null]
#$ns attach-agent $n2 $null1

set udp2 [new Agent/UDP]
$ns attach-agent $n2 $udp2
set null2 [new Agent/Null]
$ns attach-agent $n3 $null2

#
#Setup traffic sources
#
set cbr0 [new Application/Traffic/CBR]
$cbr0 set rate_ 0.05
$cbr0 set packetSize_ 500
$cbr0 attach-agent $udp0
$ns connect $udp0 $null0

set cbr1 [new Application/Traffic/CBR]
$cbr1 set rate_ 0.05
$cbr1 set packetSize_ 500
$cbr1 attach-agent $udp1
$ns connect $udp1 $null0

set cbr2 [new Application/Traffic/CBR]
$cbr2 set rate_ 0.05
$cbr2 set packetSize_ 500
$cbr2 attach-agent $udp2
$ns connect $udp2 $null2

#

#
#Start up the sources
#
$ns at 0.1 "$cbr0 start"
$ns at 5.0 "$cbr0 stop"
$ns at 0.1 "$cbr1 start"
$ns at 5.0 "$cbr1 stop"
$ns at 0.1 "$cbr2 start"
$ns at 5.0 "$cbr2 stop"
$ns at 6.0 "finish"
$ns run


