#!/bin/bash
# decription: you need to record zookeeper cluster information
#             about ip-hostname in file '/etc/hosts'
#

local_ip="$(grep $(hostname) /etc/hosts|awk '{print $1}')"
zk_port=2181

case "$1" in
    ruok)
	echo ruok |nc ${local_ip} ${zk_port}
    ;;
    latency_min)
	echo srvr | nc ${local_ip} ${zk_port} |grep Latency |cut -d: -f2|cut -d/ -f1
    ;;
    latency_avg)
	echo srvr | nc ${local_ip} ${zk_port} |grep Latency |cut -d: -f2|cut -d/ -f2
    ;;
    latency_max)
        echo srvr | nc ${local_ip} ${zk_port} |grep Latency |cut -d: -f2|cut -d/ -f3
    ;;
    *)
	echo srvr | nc ${local_ip} ${zk_port} |grep "$1" |awk -F: '{print $2}'
esac
