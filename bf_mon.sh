#!/bin/sh

OP=$1
WLAN_DRV=$2
NIC=$3
LOCAL_MAC=$4
REMOTE_MAC=$5
BW=$6
ACK_TIMEOUT=$7
INTERVAL=$8

if [ "$OP" = "stop" ]; then 
	echo "bf_mon: stop, reset status... "
	echo "0 00:00:00:00:00:00 0 0" > /proc/net/$WLAN_DRV/$NIC/bf_monitor_conf
	echo 33 > /proc/net/$WLAN_DRV/$NIC/ack_timeout 	# Realtek default
	exit
fi

if [ "$OP" = "start" ]; then 
	echo "bf_mon: start... "
	echo "1 $REMOTE_MAC 0 0" > /proc/net/$WLAN_DRV/$NIC/bf_monitor_conf
	echo $ACK_TIMEOUT > /proc/net/$WLAN_DRV/$NIC/ack_timeout
	while true; do
		echo "$LOCAL_MAC $REMOTE_MAC 0 0 0 $BW" > /proc/net/$WLAN_DRV/$NIC/bf_monitor_trig
		sleep $INTERVAL
		echo "1" > /proc/net/$WLAN_DRV/$NIC/bf_monitor_en
	done
	exit
fi


echo "Usage:" 
echo "    bf_mon.sh start <WLAN_DRV> <NIC> <LOCAL_MAC> <REMOTE_MAC> <BW:20/40/80> <ACK_TIMEOUT:33~255> <INTERVAL:s>"
echo "    bf_mon.sh stop <WLAN_DRV> <NIC>"
echo ""
echo "e.g. "
echo "    bf_mon.sh start rtl88x2eu wlan0 00:11:22:33:44:55 00:66:77:88:99:ab 20 255 0.1"
echo "    bf_mon.sh stop rtl88x2eu wlan0"
