#Vishvesh Busa
#131062
#Assignment-1
#Computer Networks_5th Sem

#setting new Simulator
set ns [new Simulator]

#defining different colors to different paths
$ns color 1 Blue
$ns color 2 Purple
$ns color 3 Orange

#Tracefile, winfile and nam file
set tracefile1 [open out.tr w]
set winfile [open winfile w]
$ns trace-all $tracefile1
set namfile [open out.nam w]
$ns namtrace-all $namfile
proc finish {} {
global ns tracefile1 namfile
$ns flush-trace
close $tracefile1
close $namfile
exec nam out.nam &
exit 0
} 

#declaring Nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]
set n10 [$ns node]

# declaring Colors of nodes
$n0 color Blue
$n1 color Red
$n2 color Yellow
$n3 color Green
$n4 color Orange
$n5 color Black
$n6 color Purple
$n7 color Silver
$n8 color Red
$n9 color Brown
$n10 color Blue

# connecting all the nodes according to requirement
$ns duplex-link $n0 $n1 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n0 $n3 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 2Mb 10ms DropTail
$ns duplex-link $n4 $n5 2Mb 10ms DropTail
$ns duplex-link $n4 $n6 2Mb 10ms DropTail
$ns duplex-link $n6 $n7 2Mb 10ms DropTail
$ns duplex-link $n6 $n8 2Mb 10ms DropTail
$ns duplex-link $n9 $n10 2Mb 10ms DropTail
set lan [$ns newLan "$n2 $n9 $n4" 0.5Mb 40ms LL Queue/DropTail MAC/Csma/Cd Channel]

#assigning positions to each nodes with respect to others
$ns duplex-link-op $n4 $n6 orient right
$ns duplex-link-op $n6 $n7 orient down
$ns duplex-link-op $n1 $n2 orient right
$ns duplex-link-op $n9 $n10 orient right
$ns duplex-link-op $n8 $n6 orient left
$ns duplex-link-op $n2 $n3 orient up
$ns duplex-link-op $n1 $n0 orient up
$ns duplex-link-op $n3 $n0 orient left
$ns duplex-link-op $n4 $n5 orient right-up

$ns queue-limit $n4 $n6 20

#setting TCP
set tcp [new Agent/TCP/Newreno]
$ns attach-agent $n2 $tcp 
set sink [new Agent/TCPSink/DelAck]
$ns attach-agent $n7 $sink 
$ns connect $tcp $sink
$tcp set fid_ 1 
$tcp set packet_size_ 552

#Setting FTP and creating FTP using TCP
set ftp [new Application/FTP]
$ftp attach-agent $tcp 

#Creating UDP-1
#creating source and sink
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp 
set null [new Agent/Null]
$ns attach-agent $n10 $null
$ns connect $udp $null
$udp set fid_ 2

#Creating UDP-2
#creating source and sink
set udp1 [new Agent/UDP]
$ns attach-agent $n8 $udp1 
set null [new Agent/Null]
$ns attach-agent $n0 $null 
$ns connect $udp1 $null
$udp1 set fid_ 3

#Creating CBR-1
#creating source and sink
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp 
$cbr set type_ CBR
$cbr set packet_size_ 1000
$cbr set rate_ 0.01Mb
$cbr set random_ false

#Creating CBR-2
#creating source and sink
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1 
$cbr1 set type_ CBR
$cbr1 set packet_size_ 1000
$cbr1 set rate_ 0.01Mb
$cbr1 set random_ false

#commands when to start
$ns at 0.1 "$cbr start"
$ns at 1.0 "$ftp start"
$ns at 1.4 "$cbr1 start"


proc plotWindow {tcpSource file} {
global ns
set time 0.1
set now [$ns now]
set cwnd [$tcpSource set cwnd_]
puts $file "$now $cwnd"
$ns at [expr $now+$time] "plotWindow $tcpSource $file"
}
$ns at 0.1 "plotWindow $tcp $winfile"
$ns at 127.0 "finish"
$ns run
