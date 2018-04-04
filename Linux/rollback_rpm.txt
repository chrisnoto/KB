[HowTo] : rollback of rpm's after update or removal - rpm command

Method to rollback rpm packages after removal or update using rpm command, rollback option using yum is not mentioned here.

OS used is rhel5.
Enable roll back option:

    Appened following line to /etc/rpm/macros (if file is not exisiting then create one)
    %_repackage_all_erasures 1

Rollback updated/erased rpm:

rpm -Uvh -rollback '1 hour ago'

Other options are minutes, week, year and particular date in 'Month nunmericDate'

 
Example:
=> Updating a package (xinetd-2.3.14-19.el5 to xinetd-2.3.14-20.el5_10) and then rollback

    Ensure roll back is enabled in /etc/rpm/macros (please refer to enable roll back option)
    Update rpm package 
    rpm -Uvh xinetd-2.3.14-20.el5_10.x86_64.rpm
     

    [root@rhel5-node1 ~]# rpm -Uvh xinetd-2.3.14-20.el5_10.x86_64.rpm
    Preparing...                ########################################### [100%]
    Repackaging...              
       1:xinetd                 ########################################### [100%]
    Upgrading...                
       1:xinetd                 ########################################### [100%]
    [root@rhel5-node1 ~]#

    Validate updated rpm version
    rpm -q xinetd

    [root@rhel5-node1 ~]# rpm -q xinetd
    xinetd-2.3.14-20.el5_10
    [root@rhel5-node1 ~]#

    Default location of repackaed rpm is /var/spool/repackage

    [root@rhel5-node1 ~]# ls -l /var/spool/repackage/
    total 136
    -rw-r--r-- 1 root root 130389 Mar  7 11:47 xinetd-2.3.14-19.el5.x86_64.rpm
    [root@rhel5-node1 ~]#

Performing roll back:

    rolling back rpm changes 11 minutes ago
    rpm -Uvh --rollback '11 minute ago'

    [root@rhel5-node1 ~]# rpm -Uvh --rollback '11 minute ago'
    Rollback packages (+1/-1) to Fri Mar  7 11:47:54 2014 (0x5319f83a):
    Preparing...                ########################################### [100%]
       1:xinetd                 ########################################### [ 50%]
    Cleaning up repackaged packages:
        Removing /var/spool/repackage/xinetd-2.3.14-19.el5.x86_64.rpm:
    [root@rhel5-node1 ~]#

    Validare rpm version after rollback
    rpm -q xinetd

    [root@rhel5-node1 ~]# rpm -q xinetd
    xinetd-2.3.14-19.el5
    [root@rhel5-node1 ~]#

Rolling back rpm which is erased=>

    For example if we removed a rpm package ( e.g. xinetd)
    rpm -ev xinetd

    [root@rhel5-node1 ~]# rpm -ev xinetd
    Wrote: /var/spool/repackage/xinetd-2.3.14-19.el5.x86_64.rpm
    [root@rhel5-node1 ~]# rpm -q xinetd
    package xinetd is not installed
    [root@rhel5-node1 ~]#

    Roll back erased rpm
    rpm -Uvh --rollback '5 minute ago'

    [root@rhel5-node1 ~]# rpm -Uvh --rollback '5 minute ago'
    Rollback packages (+1/-0) to Fri Mar  7 12:01:26 2014 (0x5319fb66):
    Preparing...                ########################################### [100%]
       1:xinetd                 ########################################### [ 50%]
    Cleaning up repackaged packages:
        Removing /var/spool/repackage/xinetd-2.3.14-19.el5.x86_64.rpm:
    [root@rhel5-node1 ~]#

    Validate rpm version after rollback
    rpm -q xinetd

    [root@rhel5-node1 ~]# rpm -q xinetd
    xinetd-2.3.14-19.el5
    [root@rhel5-node1 ~]#


