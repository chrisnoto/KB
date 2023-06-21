#!/usr/bin/env python3
import sys,datetime,re,os
import json
import subprocess
import redis
from redis import Redis
from redis.sentinel import Sentinel


def redis_is_ready(host,port,password):
    r=Redis(host=host,port=port,password=password)
    try:
        if r.ping():
            print("Redis server ",str(host)+":"+str(port)," is connected")
            return True
        else:
            print("Redis server ",str(host)+":"+str(port)," cannot be connected")
    except redis.exceptions.ConnectionError as r_con_error:
        print('Redis connection error: failed to connect to ',host+":"+str(port))
        return False

config= {
        'host': sys.argv[1],
        'port': '26379',
        'password': sys.argv[2],
        'servicename': sys.argv[3]
        }

print("*"*100)
print("Redis daily report")
print("*"*100,"\n"*2)

print("The current sentinel is: "+config['host']+":"+config['port'])
print("The other two sentinels is as below:")
r = Redis(host=config['host'],port=config['port'])
for u in r.sentinel_sentinels(config['servicename']):
    print(u['ip']+":"+str(u['port']))


s = Sentinel([(config['host'],config['port'])],socket_timeout=0.1)

host,port=s.discover_master(config['servicename'])
print("="*100)
print("Master Redis is ",str(host)+":"+str(port))

if redis_is_ready(host,port,config['password']):
    os.system("python single_redis_node.py "+str(host)+" "+str(port)+" "+config['password'])

print()
print("The list of slave server is as below:")
for shost,sport in s.discover_slaves(config['servicename']):
    print(str(shost)+":"+str(sport))
for shost,sport in s.discover_slaves(config['servicename']):
    print("="*100)
    print("Start to check the redis slave server "+str(shost)+":"+str(sport))
    if redis_is_ready(shost,sport,config['password']):
        os.system("python single_redis_node.py "+str(shost)+" "+str(sport)+" "+config['password'])
