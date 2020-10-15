set verify off
ACCEPT sysPassword CHAR PROMPT 'Enter new password for SYS: ' HIDE
ACCEPT systemPassword CHAR PROMPT 'Enter new password for SYSTEM: ' HIDE
host /home/oracle/product/11.2.4/dbhome_1/bin/orapwd file=/home/oracle/product/11.2.4/dbhome_1/dbs/orapwpoc1 force=y
@/home/oracle/admin/poc1/scripts/CloneRmanRestore.sql
@/home/oracle/admin/poc1/scripts/cloneDBCreation.sql
@/home/oracle/admin/poc1/scripts/postScripts.sql
@/home/oracle/admin/poc1/scripts/lockAccount.sql
@/home/oracle/admin/poc1/scripts/postDBCreation.sql
