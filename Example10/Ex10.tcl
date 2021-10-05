# Creating New Simulator
set ns [new Simulator]


# Setting up the traces
set f [open outEx10.tr w]
set nf [open outEx10.nam w]
$ns namtrace-all $nf
$ns trace-all $f

#To finish procedure
proc finish {} {
	global ns nf f
	$ns flush-trace
	puts "Simulation completed."
	close $f
	exec nam outEx10.nam &
	close $nf
	exit 0
}


#Creating six nodes
set node1 [$ns node]
set node2 [$ns node]
set node3 [$ns node]
set node4 [$ns node]

#Creating links between the nodes
$ns duplex-link $node1 $node2 1Mb 20ms FQ
$ns duplex-link $node1 $node3 1Mb 20ms FQ
$ns duplex-link $node1 $node4 1Mb 20ms FQ
$ns duplex-link $node2 $node3 1Mb 20ms FQ
$ns duplex-link $node2 $node4 1Mb 20ms FQ
$ns duplex-link $node3 $node4 1Mb 20ms FQ

#Creating a TCP agent and attaching it to node 1 
set tcp0 [new Agent/TCP]
$tcp0 set class_ 1
$ns attach-agent $node1 $tcp0

#Creating a TCPSink agent for TCP and attaching it to node 3 

set sink0 [new Agent/TCPSink]
$ns attach-agent $node3 $sink0

#Connecting the traffic sources with the traffic sink
$ns connect $tcp0 $sink0

#Creating a CBR traffic source and attach it to tcp 0 
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.05
$cbr0 attach-agent $tcp0

#Schedule events for the CBR agents
$ns at 0.5 "$cbr0 start"
$ns at 5.5 "$cbr0 stop"

#Here we call the finish procedure after 10 seconds of simulation time
$ns at 10.0 "finish"

#Finally run the simulation
$ns run



