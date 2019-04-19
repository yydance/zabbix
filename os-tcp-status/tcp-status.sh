#!/bin/bash

tmp_file=/dev/shm/tcp_stat.tmp

if [ $# -ne 1 ];then
    echo "Usage:$0 -
       - CLOSE-WAIT
       - CLOSED
       - CLOSING
       - ESTAB
       - FIN-WAIT-1
       - FIN-WAIT-2
       - LAST-ACK
       - LISTEN
       - SYN-RECV
       - SYN-SENT
       - TIME-WAIT"
    exit 0
fi

tcp_status_fun() {

    [ "$tcp_stat" = "ESTABLISHED" ] && tcp_stat="ESTAB" || tcp_stat=$1

    ss -ant|awk 'NR>1 {++s[$1]} END {for (k in s) print k,s[k]}' >$tmp_file
    tcp_status=$(grep $tcp_stat $tmp_file|cut -d' ' -f2)

    [ -z "$tcp_status" ] && tcp_status=0

    echo $tcp_status
}

tcp_status_fun $1
