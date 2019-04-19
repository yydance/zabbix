#!/bin/bash
# ===============================================
# 文件名称: zabbix-redis.sh
# 创 建 者: Damon
# 创建日期: 2018-09-05 11:05:45
# 修改日期: 2018-09-05 11:11:09
# 描    述: zabbix常见监控项
# ===============================================

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin:/data/app/codis/bin

host="127.0.0.1"
port="$2"
commd="redis-cli -h $host -p $port info"
cut_cmd="cut -d: -f2"

bc_cmd_check() {
  if ! $(which bc >/dev/null 2>&1);then
    yum -y install bc >/dev/null 2>&1
  fi
}

if [ $# -ne 2 ];then
  echo "parameter error"
  exit 1
fi

if $(redis-cli -h $host -p $port ping >/dev/null 2>&1);then
  case "$1" in
    connts)
      	RESULT=`$commd Clients|grep -w connected_clients |$cut_cmd`
      	echo $RESULT
      	;;
    blocks)
      	RESULT=`$commd Clients|grep -w blocked_clients |$cut_cmd`
      	echo $RESULT
      	;;
    usedmem)
      	RESULT=`$commd Memory|grep -w used_memory_rss|$cut_cmd|tr -d "\r"`
      	echo $RESULT
      	;;
    maxmem)
      	RESULT=`$commd Memory|grep -w used_memory_peak|$cut_cmd|tr -d "\r"`
      	echo $RESULT
      	;;
    ratio)
      	RESULT=`$commd Memory|grep -w mem_fragmentation_ratio|$cut_cmd`
      	echo $RESULT
      	;;

    ops)
      	RESULT=`$commd Stats|grep -w instantaneous_ops_per_sec|$cut_cmd`
      	echo $RESULT
      	;;
    rejected)
      	RESULT=`$commd Stats|grep -w rejected_connections|$cut_cmd`
      	echo $RESULT
      	;;
    fork_used_time)
      	RESULT=`$commd Stats|grep -w latest_fork_usec|$cut_cmd`
      	echo $RESULT
      	;;
    expired_keys)
      	RESULT=`$commd Stats|grep -w expired_keys|$cut_cmd`
      	echo $RESULT
      	;;
    evicted_keys)
      	RESULT=`$commd Stats|grep -w evicted_keys|$cut_cmd`
      	echo $RESULT
      	;;
    keyspace_hits)
      	RESULT=`$commd Stats|grep -w keyspace_hits|$cut_cmd`
      	echo $RESULT
      	;;
    keyspace_misses)
      	RESULT=`$commd Stats|grep -w keyspace_misses|$cut_cmd`
      	echo $RESULT
      	;;
    keys_hit_ratio)
      	bc_cmd_check
      	keys_hits=`$commd Stats|grep -w keyspace_hits|$cut_cmd|tr -d "\r"`
      	keys_misses=`$commd Stats|grep -w keyspace_misses|$cut_cmd|tr -d "\r"`
      	keys_total=$(expr $keys_hits + $keys_misses)
      	if [ $keys_total -ne 0 ];then
            RESULT=0`echo "scale=3;$keys_hits/$keys_total"|bc`
            echo $(bc <<< "$RESULT * 100")
      	else
            echo 0
     	fi
      	;;
    instantaneous_input_kbps)
      	RESULT=`$commd Stats|grep -w instantaneous_input_kbps|$cut_cmd`
      	echo $RESULT
      	;;
    instantaneous_output_kbps)
      	RESULT=`$commd Stats|grep -w instantaneous_output_kbps|$cut_cmd`
      	echo $RESULT
      	;;
    rdb_used_time)
      	RESULT=`$commd Persistence|grep -w rdb_last_bgsave_time_sec|$cut_cmd`
      	echo $RESULT
      	;;
    rdb_change_time)
      	RESULT=`$commd Persistence|grep -w rdb_changes_since_last_save|$cut_cmd`
      	echo $RESULT
      	;;
    rdb_bgsave_status)
      	RESULT=`$commd Persistence|grep -w rdb_last_bgsave_status|$cut_cmd`
      	echo $RESULT
      	;;
    keys)
      	RESULT=`$commd Keyspace|grep -w keys|awk -F, '{print $1}'|awk -F= '{print $2}'`
      	if [ "$RESULT" = "" ];then
	    echo 0
      	else
	    echo $RESULT
      	fi
      	;;
     used_cpu_sys)
	RESULT=`$commd CPU|grep -w used_cpu_sys|$cut_cmd|tr -d "\r"`
        echo RESULT
      	;;
     used_cpu_user)
	RESULT=`$commd CPU|grep -w used_cpu_user|$cut_cmd|tr -d "\r"`
        echo $RESULT
      	;;
     used_cpu_sys_children)
	RESULT=`$commd CPU|grep -w used_cpu_sys_children|$cut_cmd|tr -d "\r"`
        echo $RESULT
      	;;
     used_cpu_user_children)
	RESULT=`$commd CPU|grep -w used_cpu_user_children|$cut_cmd|tr -d "\r"`
        echo $RESULT
      	;;
    *)
	echo "parameter error"
  esac
fi
