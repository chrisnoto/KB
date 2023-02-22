#!/usr/bin/env python3
import sys
from datetime import datetime
import re
import redis
import json

host=sys.argv[1]
port=sys.argv[2]
password=sys.argv[3]

def print_redis_info(section,selection):
    print('-'*100)
    print("# ",section)
    print('-'*100)
    re_genre=r'{}'.format(selection)
    pattern=re.compile(re_genre)
    for k,v in r.info(section).items():
        if pattern.search(k):
            print('%-50s%-50s' % (k,v))

def print_with_width(cname,cvalue):
    print('-'*100)
    print('%-50s%-50s' % (cname,cvalue))

r=redis.Redis(host=host,port=port,password=password)
try:
    if not r.ping():
        raise redis.exceptions.ConnectionError
except redis.exceptions.ConnectionError as r_con_error:
    print('Redis connection error: failed to connect to ',host+":"+str(port))
    sys.exit(1)

def listen():
    count = 1
    p=r.pubsub()
    p.subscribe('__sentinel__:hello')
    for m in p.listen():
        if m['type'] == 'message':
            print(m['data'].decode())
            count +=1
            if count == 4:
                p.unsubscribe()
            if count == 5:
                break

print('='*100)
print("Redis Info")
print_redis_info('server','redis_version|mode|os|tcp_port|uptime')
print_redis_info('clients','client')
print_redis_info('memory','human|maxmemory_policy|ratio')
print_redis_info('persistence','rdb_last|aof_enabled|aof_last')
print_redis_info('stats','instantaneous|rejected|sync_full|sync_partial|expired_keys|evicted_keys|keyspace')
print_redis_info('replication','role|connected_slaves|repl_backlog_size|offset')
print_redis_info('errorstats','errorstat')
print_redis_info('keyspace','db')
print('-'*100)
print()
print('='*100)
print("Important configuration")
print_with_width("RDB save policy:",r.config_get('save'))
print_with_width("Appendfsync",r.config_get('appendfsync'))
print_with_width("Replica read only",r.config_get('replica-read-only'))
print_with_width("ACL",r.acl_list())
print()
print('='*100)
print("Redis slow log")
print('-'*100)
slowlog=r.slowlog_get()
for log in slowlog:
    print("id: ",log['id'],"time: ",datetime.fromtimestamp(log['start_time'])," duration: ",str(round(log['duration']/1000,2))+"ms"," command: ",log['command'].decode())
print('-'*100)
if r.pubsub_channels():
    print("sentinel hello messages")
    print('-'*100)
    listen()
    print('-'*100)
