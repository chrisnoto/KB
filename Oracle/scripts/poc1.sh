#!/bin/sh

OLD_UMASK=`umask`
umask 0027
mkdir -p /data/fast_recovery_area
mkdir -p /data/fast_recovery_area/poc1/archive
mkdir -p /data/oradata
mkdir -p /data/oradata/poc1/archive
mkdir -p /home/oracle/admin/poc1/adump
mkdir -p /home/oracle/admin/poc1/dpdump
mkdir -p /home/oracle/admin/poc1/pfile
mkdir -p /home/oracle/cfgtoollogs/dbca/poc1
mkdir -p /home/oracle/product/11.2.4/dbhome_1/dbs
umask ${OLD_UMASK}
ORACLE_SID=poc1; export ORACLE_SID
PATH=$ORACLE_HOME/bin:$PATH; export PATH
echo You should Add this entry in the /etc/oratab: poc1:/home/oracle/product/11.2.4/dbhome_1:Y
/home/oracle/product/11.2.4/dbhome_1/bin/sqlplus /nolog @/home/oracle/admin/poc1/scripts/poc1.sql
