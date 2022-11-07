BEGIN {
	recvdSize = 0
	startTime = 400
	stopTime = 0
}

{
	event = $1
	time = $2
	node_id = $3
	pkt_size = $8
	level = $4
	# Store start time
	if (level == "AGT" && event == "s" && pkt_size >= 512) {
		if (time < startTime) {
			startTime = time
		}
	}
	# Update total received packets' size and store packets arrival time
	if (level == "AGT" && event == "r" && pkt_size >= 512) {
		if (time > stopTime) {
			stopTime = time
		}
	recvdSize += pkt_size
	}
}

END {
	printf("Average Throughput[kbps] = %.2f\t\t StartTime=%.2f\tStopTime=%.2f\n",(recvdSize/(stopTime-startTime))*(8/1000)-200,startTime,stopTime)
}