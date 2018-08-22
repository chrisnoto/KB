#!/bin/bash
SENDER='/usr/bin/zabbix_sender'
HOST="10.67.37.192"
IP=`grep -i '^Hostname=' /etc/zabbix/zabbix_agentd.conf |cut -d'=' -f2`

#active/inactive memory
res=`vmstat -a|awk 'NR==3{print $6,$5}'`
act=`echo $res|awk '{print $1}'`
inact=`echo $res|awk '{print $2}'`

#page in/out
pi=`vmstat -s|grep "paged in"|awk '{print $1}'`
po=`vmstat -s|grep "paged out"|awk '{print $1}'`

#tcp connection
LISTEN=0
CLOSE_WAIT=0
TIME_WAIT=0
ESTABLISHED=0
FIN_WAIT1=0
FIN_WAIT2=0
CONN=`netstat -antl | awk '/^tcp/ {++state[$NF]} END {for(key in state) print key"="state[key]}'`
eval $CONN


$SENDER -s "$IP" -z "$HOST" -k "memory.pi" -o "$pi"
$SENDER -s "$IP" -z "$HOST" -k "memory.po" -o "$po"

$SENDER -s "$IP" -z "$HOST" -k "memory.active" -o "$act"
$SENDER -s "$IP" -z "$HOST" -k "memory.inactive" -o "$inact"

$SENDER -s "$IP" -z "$HOST" -k "tcpconn.listen" -o "$LISTEN"
$SENDER -s "$IP" -z "$HOST" -k "tcpconn.closewait" -o "$CLOSE_WAIT"
$SENDER -s "$IP" -z "$HOST" -k "tcpconn.timewait" -o "$TIME_WAIT"
$SENDER -s "$IP" -z "$HOST" -k "tcpconn.finwait1" -o "$FIN_WAIT1"
$SENDER -s "$IP" -z "$HOST" -k "tcpconn.finwait2" -o "$FIN_WAIT2"
$SENDER -s "$IP" -z "$HOST" -k "tcpconn.established" -o "$ESTABLISHED"
