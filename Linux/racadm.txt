#Tested on Dell R620 server with iDRAC 7, this script is run under a winxp with racadm installed
host=$1

echo "#################################Deleting the existing vdisks#########################################"
#Deleting the existing vdisks
for i in 0 1 2 3 4 5
do
        echo "############## $i ##############"
        racadm -r $host -u root -p calvin raid deletevd:Disk.Virtual.$i:RAID.Integrated.1-1
        sleep 10
done
racadm -r $host -u root -p calvin jobqueue create RAID.Integrated.1-1
racadm -r $host -u root -p calvin serveraction powercycle
sleep 600

echo "#################################Create new vdisks#########################################"
#Create new vdisks
for i in 0 1 2 3 4 5
do
        echo "############## $i ##############"
        racadm -r $host -u root -p calvin raid createvd:RAID.Integrated.1-1 -rl r0 -wp wb -rp ara -ss 64k -pdkey:Disk.Bay.$i:Enclosure.Internal.0-1:RAID.Integrated.1-1
        sleep 30
done
racadm -r $host -u root -p calvin jobqueue create RAID.Integrated.1-1
racadm -r $host -u root -p calvin serveraction powercycle
sleep 600


echo "#################################Init vdisks#########################################"
#init vdisks
for i in 0 1 2 3 4 5
do
        echo "############## $i ##############"
        racadm -r $host -u root -p calvin raid init:Disk.Virtual.$i:RAID.Integrated.1-1
        sleep 30
done
racadm -r $host -u root -p calvin jobqueue create RAID.Integrated.1-1
racadm -r $host -u root -p calvin serveraction powercycle


sleep 600


#partition vflash SD
echo "#################################Init vflashSD#########################################"
racadm -r $host -u root -p calvin vflashsd initialize
sleep 300
echo "#################################Create vflashSD partitions#########################################"
index=1
for i in ROOT VAR LOG LOCAL
do
        echo "############## $i ##############"
        if [ $i == "LOCAL" ];then
                size=2500
        else
                size=4096
        fi
        racadm -r $host -u root -p calvin vflashpartition create -i $index -o $i -e HDD -t empty -f ext3 -s $size
        index=`expr $index + 1 `
        sleep 100
done
sleep 1200
#Attach vflash paritions to system
echo "#################################Attach vflashSD partitions#########################################"
for i in 1 2 3 4
do
        echo "############## $i ##############"
        racadm -r $host -u root -p calvin set iDRAC.vflashpartition.$i.AttachState 1
        sleep 100
done

sleep 100
echo "#################################Setting NIC LegacyBootProto#########################################"
for i in 1 2 3 4
do
        echo "############## $i ##############"
        if [ $i -eq 3 ];then
                value="PXE"
        else
                value="NONE"
        fi
        racadm -r $host -u root -p calvin set NIC.NICConfig.$i.LegacyBootProto $value
        sleep 30
        #racadm -r $host -u root -p calvin get NIC.NICConfig.$i.LegacyBootProto
        racadm -r $host -u root -p calvin jobqueue create NIC.Integrated.1-$i-1
done
sleep 10
racadm -r $host -u root -p calvin serveraction powercycle
sleep 600

echo "#################################Setting Boot from flashSD root#########################################"
racadm -r $host -u root -p calvin set BIOS.BiosBootSettings.HddSeq Disk.vFlash.ROOT-1,RAID.Integrated.1-1,,Disk.vFlash.VAR-1,Disk.vFlash.LOG-1,Disk.vFlash.LOCAL-1
racadm -r $host -u root -p calvin jobqueue create BIOS.Setup.1-1
sleep 10
racadm -r $host -u root -p calvin serveraction powercycle

#sleep 600
#echo "#################################Set Next boot PXE#########################################"
#Set next boot from PXE
#racadm -r $host -u root -p calvin set iDRAC.serverboot.FirstBootDevice PXE
#sleep 10
#racadm -r $host -u root -p calvin serveraction powercycle

#####################################################iDrac management#####################################################################################################

[root@vtj-cobbler ~]# for u in `cat idrac_ip`;do echo "----$u----";sshpass -p calvin ssh -o StrictHostKeyChecking=no root@$u racadm hwinventory NIC.Integrated.1-4-1 |egrep 'Device Description|Current MAC Address';done

----10.67.63.189----
Current MAC Address:                          18:66:DA:74:29:E6

[root@vtj-cobbler ~]# for u in `cat idrac_ip`;do echo "----$u----";sshpass -p calvin ssh -o StrictHostKeyChecking=no root@$u racadm  raid help createvd |grep createvd;done
----10.67.63.168----
racadm storage createvd:<Controller FQDD> -rl {r0|r1|r5|r6|r10|r50|r60}[-wp {wt|wb|wbf}] [-rp {nra|ra|ara}]
racadm storage createvd:RAID.Integrated.1-1 -rl r0 -pdkey:Disk.Bay.0:Enclosure.Internal.0-0:RAID.Integrated.1-1

[root@vtj-cobbler ~]# for u in `cat idrac_ip`;do echo "----$u----";sshpass -p calvin ssh -o StrictHostKeyChecking=no root@$u racadm getversion;done
----10.67.63.179----
 Bios Version             = 1.6.0
 iDRAC Version            = 1.06.06
 USC Version              = 1.0.0.5747
----10.67.63.180----
 

 [root@vtj-cobbler ~]# for u in `cat idrac_ip`;do echo "----$u----";sshpass -p calvin ssh -o StrictHostKeyChecking=no root@$u racadm racdump|egrep 'Firmware Version|Current IP Address * =|System Model|BIOS|Ethernet';done
----10.67.63.179----
Firmware Version        = 1.06.06
Current IP Address      = 10.67.63.179
System Model            = PowerEdge R720
System BIOS Version     = 1.6.0
----10.67.63.180----


[root@vtj-cobbler ~]# for u in `cat idrac_ip`;do echo "----$u----";sshpass -p calvin ssh -o StrictHostKeyChecking=no root@$u racadm getsensorinfo|egrep -i 'presen|absen';done
----10.67.63.179----
PS1 Status                      Present                  AC
PS2 Status                      Present                  AC
CPU1 Status                     Failed      Present     NA          NA
CPU2 Status                     Ok          Present     NA          NA
System Board CMOS Battery       Ok          Present     NA          NA
----10.67.63.180----


setup PXE enabled per NIC
racadm>>set NIC.NICConfig.1.LegacyBootProto PXE
        jobqueue create NIC.Integrated.1-1-1
		serveraction powercycle
        set BIOS.OneTimeBoot.OneTimeBootMode OneTimeHddSeq
racadm get BIOS.BiosBootSettings

[root@vtj-cobbler ~]# for u in `seq 141 146`;do  echo "----10.67.64.$u----drives";sshpass -p 'cesbgILO!!#'  sshilo "itsa@10.67.63.$u show system1/drive;done
----10.67.64.141----drives
    Bay 1 - drive status=Ok; UID=Off

[root@vtj-cobbler ~]# for u in `cat hp_ip`;do  echo "-----$u----nic";sshpass -p 'cesbgILO!!#'  sshilo "itsa@$u show system1/network1/integrated_nics"|grep NIC;done