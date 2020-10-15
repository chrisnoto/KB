SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /home/oracle/admin/poc1/scripts/cloneDBCreation.log append
Create controlfile reuse set database "poc1"
MAXINSTANCES 8
MAXLOGHISTORY 1
MAXLOGFILES 16
MAXLOGMEMBERS 3
MAXDATAFILES 100
Datafile 
'&&file0',
'&&file1',
'&&file2',
'&&file3'
LOGFILE GROUP 1  SIZE 51200K,
GROUP 2  SIZE 51200K,
GROUP 3  SIZE 51200K RESETLOGS;
select name from v$controlfile;
exec dbms_backup_restore.zerodbid(0);
shutdown immediate;
startup nomount pfile="/home/oracle/admin/poc1/scripts/initpoc1Temp.ora";
Create controlfile reuse set database "poc1"
MAXINSTANCES 8
MAXLOGHISTORY 1
MAXLOGFILES 16
MAXLOGMEMBERS 3
MAXDATAFILES 100
Datafile 
'&&file0',
'&&file1',
'&&file2',
'&&file3'
LOGFILE GROUP 1  SIZE 51200K,
GROUP 2  SIZE 51200K,
GROUP 3  SIZE 51200K RESETLOGS;
alter system enable restricted session;
alter database "poc1" open resetlogs;
exec dbms_service.delete_service('seeddata');
exec dbms_service.delete_service('seeddataXDB');
alter database rename global_name to "poc1";
set linesize 2048;
column ctl_files NEW_VALUE ctl_files;
select concat('control_files=''', concat(replace(value, ', ', ''','''), '''')) ctl_files from v$parameter where name ='control_files';
host echo &ctl_files >>/home/oracle/admin/poc1/scripts/init.ora;
host echo &ctl_files >>/home/oracle/admin/poc1/scripts/initpoc1Temp.ora;
ALTER TABLESPACE TEMP ADD TEMPFILE SIZE 20480K AUTOEXTEND ON NEXT 640K MAXSIZE UNLIMITED;
select tablespace_name from dba_tablespaces where tablespace_name='USERS';
alter system disable restricted session;
connect "SYS"/"&&sysPassword" as SYSDBA
@/home/oracle/product/11.2.4/dbhome_1/demo/schema/mkplug.sql &&sysPassword change_on_install change_on_install change_on_install change_on_install change_on_install change_on_install example.dmp example01.dfb /data/oradata/poc1/example01.dbf /home/oracle/admin/poc1/scripts/ /home/oracle/product/11.2.4/dbhome_1/assistants/dbca/templates/ "\'SYS/&&sysPassword as SYSDBA\'";
connect "SYS"/"&&sysPassword" as SYSDBA
shutdown immediate;
connect "SYS"/"&&sysPassword" as SYSDBA
startup restrict pfile="/home/oracle/admin/poc1/scripts/initpoc1Temp.ora";
select sid, program, serial#, username from v$session;
alter database character set INTERNAL_CONVERT AL32UTF8;
alter database national character set INTERNAL_CONVERT AL16UTF16;
alter user sys account unlock identified by "&&sysPassword";
alter user system account unlock identified by "&&systemPassword";
alter system disable restricted session;
