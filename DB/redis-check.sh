REDIS_CLI="redis-cli -h $1 -a $2"
${REDIS_CLI} info server 2>/dev/null|egrep 'redis_version|redis_mode|os|tcp_port|uptime_in_days' |awk \
 'BEGIN{ FS=":";ORS= "\n---------------------------------------------------------------------------------\n"; \
         print "Redis Info"; \
         printf "%-40s %40s\n", "Name","Value"; \
         print}\
  { if ($1~ "#") print $1;else printf "%-40s %40s\n",$1,$2}'

${REDIS_CLI} info clients 2>/dev/null | awk \
 'BEGIN{ FS=":";ORS= "\n---------------------------------------------------------------------------------\n"; \
         print}\
  { if ($1~ "#") print $1;else printf "%-40s %40s\n",$1,$2}'

${REDIS_CLI} info memory 2>/dev/null|egrep 'human|maxmemory_policy|ratio' | awk \
 'BEGIN{ FS=":";ORS= "\n---------------------------------------------------------------------------------\n"; \
         print}\
  { if ($1~ "#") print $1;else printf "%-40s %40s\n",$1,$2}'

${REDIS_CLI} info persistence 2>/dev/null |egrep 'rdb_last|aof_enabled|aof_last' | awk \
 'BEGIN{ FS=":";ORS= "\n---------------------------------------------------------------------------------\n"; \
         print}\
  { if ($1~ "#") print $1;else printf "%-40s %40s\n",$1,$2}'

${REDIS_CLI} info stats 2>/dev/null |egrep 'instantaneous|rejected|sync_full|sync_partial|expired_keys|evicted_keys|keyspace' | awk \
 'BEGIN{ FS=":";ORS= "\n---------------------------------------------------------------------------------\n"; \
         print}\
  { if ($1~ "#") print $1;else printf "%-40s %40s\n",$1,$2}'

${REDIS_CLI} info replication 2>/dev/null |egrep 'role|connected_slaves|repl_backlog_size' | awk \
 'BEGIN{ FS=":";ORS= "\n---------------------------------------------------------------------------------\n"; \
         print}\
  { if ($1~ "#") print $1;else printf "%-40s %40s\n",$1,$2}'

${REDIS_CLI} info errorstats 2>/dev/null | awk \
 'BEGIN{ FS=":";ORS= "\n---------------------------------------------------------------------------------\n"; \
         print}\
  { if ($1~ "#") print $1;else printf "%-40s %40s\n",$1,$2}'

cat <<EOF
---------------------------------------------------------------------------------
# Keyspace
---------------------------------------------------------------------------------
EOF
R_KEYSPACE=`${REDIS_CLI} info keyspace 2>/dev/null`
for u in $R_KEYSPACE
do
  echo $u | awk -F ":" '{if ($1!~ "#") printf "%-40s %40s\n",$1,$2}'
done

echo
cat <<EOF
---------------------------------------------------------------------------------
Important config
---------------------------------------------------------------------------------
EOF
R_RDB_POLICY=`${REDIS_CLI} config get save 2>/dev/null |tail -1`

R_APDFILENAME=`${REDIS_CLI} config get appendfilename 2>/dev/null |tail -1`

R_APDFSYNC=`${REDIS_CLI} config get appendfsync 2>/dev/null |tail -1`

R_ACL=`${REDIS_CLI} acl list 2>/dev/null |tail -1`

cat <<EOF | awk -F ":" '{printf "%-40s %40s\n",$1,$2}'
RDB Save Policy:$R_RDB_POLICY
appendfilename:$R_APDFILENAME
appendfsync:$R_APDFSYNC
ACL:$R_ACL
EOF

cat <<EOF
---------------------------------------------------------------------------------
Slow log
---------------------------------------------------------------------------------
EOF
${REDIS_CLI} slowlog get 2>/dev/null  | awk '{if ($3~ "(integer)") print $NF;else printf " "$NF}'
echo
echo "---------------------------------------------------------------------------------"
