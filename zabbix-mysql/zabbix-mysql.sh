#!/bin/bash
# author: damon.yang
# description: used to match zabbix mysql template(Template App MySQL)

USER="root"
PORT="$2"

if [ -z "$2" ];then
    socket="--socket=/data/appData/mysql/mysql.sock"
else
    socket="--socket=/data/appData/mysql-$PORT/mysql.sock"
fi

if [ -f /data/app/mysql/bin/mysqladmin ];then
    MYSQL_CONN="/data/app/mysql/bin/mysqladmin $socket -u$USER"
else
    echo "Not Found Command 'mysqladmin'"
    exit
fi

case "$1" in
  Uptime)
    result=`${MYSQL_CONN} status|cut -f2 -d":"|cut -f1 -d"T"`
    echo $result
  ;;
  Com_update)
    result=`${MYSQL_CONN} extended-status|grep -w "Com_update"|cut -d"|" -f3`
    echo $result
  ;;
  Slow_queries)
    result=`${MYSQL_CONN} status|cut -f5 -d":"|cut -f1 -d"O"`
    echo $result
  ;;
  Com_select)
    result=`${MYSQL_CONN} extended-status|grep -w "Com_select"|cut -d"|" -f3`
    echo $result
  ;;
  Com_rollback)
    result=`${MYSQL_CONN} extended-status|grep -w "Com_rollback"|cut -d"|" -f3`
    echo $result
  ;;
  Questions)
    result=`${MYSQL_CONN} status|cut -f4 -d":"|cut -f1 -d"S"`
    echo $result
  ;;
  Com_insert)
    result=`${MYSQL_CONN} extended-status|grep -w "Com_insert"|cut -d"|" -f3`
    echo $result
  ;;
  Com_delete)
    result=`${MYSQL_CONN} extended-status|grep -w "Com_delete"|cut -d"|" -f3`
    echo $result
  ;;
  Com_commit)
    result=`${MYSQL_CONN} extended-status|grep -w "Com_commit"|cut -d"|" -f3`
    echo $result
  ;;
  Bytes_sent)
    result=`${MYSQL_CONN} extended-status|grep -w "Bytes_sent"|cut -d"|" -f3`
    echo $result
  ;;
  Bytes_received)
    result=`${MYSQL_CONN} extended-status|grep -w "Bytes_received"|cut -d"|" -f3`
    echo $result
  ;;
  Com_begin)
    result=`${MYSQL_CONN} extended-status|grep -w "Com_begin"|cut -d"|" -f3`
    echo $result
  ;;
  ping)
    result=`${MYSQL_CONN} ping|grep -c alive`
    echo $result
  ;;
  *)
    echo "error parameter"
  ;;
esac
