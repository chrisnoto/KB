[root@pcarshn01 ~]# lspci|grep -i fibre
18:00.0 Fibre Channel: QLogic Corp. ISP2432-based 4Gb Fibre Channel to PCI Express HBA (rev 03)
1e:00.0 Fibre Channel: QLogic Corp. ISP2432-based 4Gb Fibre Channel to PCI Express HBA (rev 03)
[root@pcarshn01 ~]# ls /sys/class/fc_host/
host3  host4
[root@pcarshn01 ~]# ls /sys/class/fc_remote_ports
rport-3:0-0  rport-4:0-0
[root@pcarshn01 ~]# ls /sys/class/fc_transport/
target3:0:0  target4:0:0
------------------------------------------------------------------------------------
[root@pcarshn01 ~]# ls -l /dev/disk/by-id/
total 0
lrwxrwxrwx 1 root root  9 Mar 23 12:09 ata-UJDA782_DVDCDRW_HE55_003770 -> ../../hda
lrwxrwxrwx 1 root root  9 Mar 23 12:09 scsi-3600507630affc54f0000000000002100 -> ../../sdo
lrwxrwxrwx 1 root root  9 Mar 23 12:09 scsi-3600507630affc54f0000000000002101 -> ../../sdp
lrwxrwxrwx 1 root root  9 Mar 23 12:09 scsi-3600507630affc54f0000000000002102 -> ../../sdq
lrwxrwxrwx 1 root root  9 Mar 23 12:09 scsi-3600507630affc54f0000000000002103 -> ../../sdr
lrwxrwxrwx 1 root root  9 Mar 23 12:09 scsi-3600507630affc54f0000000000002104 -> ../../sdf
lrwxrwxrwx 1 root root  9 Mar 23 12:09 scsi-3600507630affc54f0000000000002105 -> ../../sdg
lrwxrwxrwx 1 root root  9 Mar 23 12:09 scsi-3600507630affc54f0000000000002106 -> ../../sdh
lrwxrwxrwx 1 root root  9 Mar 23 12:09 scsi-3600507630affc54f0000000000002107 -> ../../sdi
lrwxrwxrwx 1 root root  9 Mar 23 12:09 scsi-3600507630affc54f0000000000002200 -> ../../sdj
lrwxrwxrwx 1 root root  9 Mar 23 12:09 scsi-3600507630affc54f0000000000002201 -> ../../sdk
lrwxrwxrwx 1 root root  9 Mar 23 12:09 scsi-3600507630affc54f0000000000002202 -> ../../sdl
lrwxrwxrwx 1 root root  9 Mar 23 12:09 scsi-3600507630affc54f0000000000002203 -> ../../sdm
lrwxrwxrwx 1 root root  9 Mar 23 12:09 scsi-3600507630affc54f0000000000009100 -> ../../sdn
lrwxrwxrwx 1 root root 11 Mar 23 12:09 scsi-3600507630affc54f0000000000009100-part1 -> ../../sdaa1
lrwxrwxrwx 1 root root  9 Mar 23 12:09 scsi-3600508e0000000003df105038d88b40b -> ../../sda
lrwxrwxrwx 1 root root 10 Mar 23 12:09 scsi-3600508e0000000003df105038d88b40b-part1 -> ../../sda1
lrwxrwxrwx 1 root root 10 Mar 23 12:09 scsi-3600508e0000000003df105038d88b40b-part2 -> ../../sda2
[root@pcarshn01 ~]# multipathd -k"show maps"
name    sysfs uuid                             
mpath13 dm-6  3600507630affc54f0000000000009100
mpath1  dm-7  3600507630affc54f0000000000002100
mpath2  dm-8  3600507630affc54f0000000000002101
mpath3  dm-9  3600507630affc54f0000000000002102
mpath4  dm-10 3600507630affc54f0000000000002103
mpath5  dm-11 3600507630affc54f0000000000002104
mpath6  dm-12 3600507630affc54f0000000000002105
mpath7  dm-13 3600507630affc54f0000000000002106
mpath8  dm-14 3600507630affc54f0000000000002107
mpath9  dm-15 3600507630affc54f0000000000002200
mpath10 dm-16 3600507630affc54f0000000000002201
mpath11 dm-17 3600507630affc54f0000000000002202
mpath12 dm-18 3600507630affc54f0000000000002203

-------------------------------------------------------
[root@pcarshn01 ~]# ls -l /dev/disk/by-path/
total 0
lrwxrwxrwx 1 root root  9 Mar 23 12:09 ide-0:0 -> ../../hda
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:04:00.0-scsi-0:1:3:0 -> ../../sda
lrwxrwxrwx 1 root root 10 Mar 23 12:09 pci-0000:04:00.0-scsi-0:1:3:0-part1 -> ../../sda1
lrwxrwxrwx 1 root root 10 Mar 23 12:09 pci-0000:04:00.0-scsi-0:1:3:0-part2 -> ../../sda2
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:18:00.0-fc-0x500507630a18c54f:0x0000000000000000 -> ../../sdb
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:18:00.0-fc-0x500507630a18c54f:0x0001000000000000 -> ../../sdc
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:18:00.0-fc-0x500507630a18c54f:0x0002000000000000 -> ../../sdd
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:18:00.0-fc-0x500507630a18c54f:0x0003000000000000 -> ../../sde
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:18:00.0-fc-0x500507630a18c54f:0x0004000000000000 -> ../../sdf
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:18:00.0-fc-0x500507630a18c54f:0x0005000000000000 -> ../../sdg
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:18:00.0-fc-0x500507630a18c54f:0x0006000000000000 -> ../../sdh
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:18:00.0-fc-0x500507630a18c54f:0x0007000000000000 -> ../../sdi
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:18:00.0-fc-0x500507630a18c54f:0x0008000000000000 -> ../../sdj
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:18:00.0-fc-0x500507630a18c54f:0x0009000000000000 -> ../../sdk
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:18:00.0-fc-0x500507630a18c54f:0x000a000000000000 -> ../../sdl
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:18:00.0-fc-0x500507630a18c54f:0x000b000000000000 -> ../../sdm
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:18:00.0-fc-0x500507630a18c54f:0x000c000000000000 -> ../../sdn
lrwxrwxrwx 1 root root 10 Mar 23 12:09 pci-0000:18:00.0-fc-0x500507630a18c54f:0x000c000000000000-part1 -> ../../sdn1
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:1e:00.0-fc-0x500507630a00054f:0x0000000000000000 -> ../../sdo
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:1e:00.0-fc-0x500507630a00054f:0x0001000000000000 -> ../../sdp
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:1e:00.0-fc-0x500507630a00054f:0x0002000000000000 -> ../../sdq
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:1e:00.0-fc-0x500507630a00054f:0x0003000000000000 -> ../../sdr
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:1e:00.0-fc-0x500507630a00054f:0x0004000000000000 -> ../../sds
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:1e:00.0-fc-0x500507630a00054f:0x0005000000000000 -> ../../sdt
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:1e:00.0-fc-0x500507630a00054f:0x0006000000000000 -> ../../sdu
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:1e:00.0-fc-0x500507630a00054f:0x0007000000000000 -> ../../sdv
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:1e:00.0-fc-0x500507630a00054f:0x0008000000000000 -> ../../sdw
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:1e:00.0-fc-0x500507630a00054f:0x0009000000000000 -> ../../sdx
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:1e:00.0-fc-0x500507630a00054f:0x000a000000000000 -> ../../sdy
lrwxrwxrwx 1 root root  9 Mar 23 12:09 pci-0000:1e:00.0-fc-0x500507630a00054f:0x000b000000000000 -> ../../sdz
lrwxrwxrwx 1 root root 10 Mar 23 12:09 pci-0000:1e:00.0-fc-0x500507630a00054f:0x000c000000000000 -> ../../sdaa
lrwxrwxrwx 1 root root 11 Mar 23 12:09 pci-0000:1e:00.0-fc-0x500507630a00054f:0x000c000000000000-part1 -> ../../sdaa1
                                        pci标示       channel | storage WWPN   |  Lun ID   
                                           
[root@pcarshn01 ~]# systool -c fc_remote_ports -v
Class = "fc_remote_ports"

  Class Device = "0-0"
  Class Device path = "/sys/class/fc_remote_ports/rport-3:0-0"
    dev_loss_tmo        = "8"
    fast_io_fail_tmo    = "off"
    node_name           = "0x500507630affc54f"                ------storage WWNN(host adapter WWNN)
    port_id             = "0x023800"			      -------存储端口的 24位交换机端口ID
    port_name           = "0x500507630a18c54f"                ------storage WWPN(port of host adapter WWPN)
    port_state          = "Online"
    roles               = "FCP Target"                        ------fabric roles:  FCP Target, name server, login server
    scsi_target_id      = "0"
    supported_classes   = "Class 2, Class 3"
    uevent              = <store method only>

    Device = "rport-3:0-0"
    Device path = "/sys/devices/pci0000:17/0000:17:00.0/0000:18:00.0/host3/rport-3:0-0"
      uevent              = <store method only>


  Class Device = "0-0"
  Class Device path = "/sys/class/fc_remote_ports/rport-4:0-0"
    dev_loss_tmo        = "8"
    fast_io_fail_tmo    = "off"
    node_name           = "0x500507630affc54f"                ------storage WWNN(host adapter WWNN)
    port_id             = "0x020000"			      -------存储端口的 24位交换机端口ID
    port_name           = "0x500507630a00054f"                ------storage WWPN(port of host adapter WWPN)
    port_state          = "Online"
    roles               = "FCP Target"
    scsi_target_id      = "0"
    supported_classes   = "Class 2, Class 3"
    uevent              = <store method only>

    Device = "rport-4:0-0"
    Device path = "/sys/devices/pci0000:1d/0000:1d:00.0/0000:1e:00.0/host4/rport-4:0-0"
      uevent              = <store method only>

--------------------------------------------------------
[root@pcarshn01 ~]# systool -c fc_host -v
Class = "fc_host"

  Class Device = "host3"
  Class Device path = "/sys/class/fc_host/host3"
    fabric_name         = "0x100000051e84b833"                          ----WWN of fabric switch,'00051e' is an OUI of Brocade fabric
    issue_lip           = <store method only>
    node_name           = "0x2000001b3289b710"                          ----WWNN of initiator (HBA)
    port_id             = "0x011800"                                    ---- HBA端口的 24位交换机端口ID
    port_name           = "0x2100001b3289b710"                          ----WWPN of initiator (HBA)
    port_state          = "Online"
    port_type           = "NPort (fabric via point-to-point)"
    speed               = "4 Gbit"
    supported_classes   = "Class 3"
    supported_speeds    = "1 Gbit, 2 Gbit, 4 Gbit"
    symbolic_name       = "QLE2460 FW:v5.06.03 DVR:v8.03.07.15.05.09-k"
    system_hostname     = ""
    tgtid_bind_type     = "wwpn (World Wide Port Name)"
    uevent              = <store method only>

    Device = "host3"
    Device path = "/sys/devices/pci0000:17/0000:17:00.0/0000:18:00.0/host3"
      fw_dump             = 
      nvram               = "ISP "
      optrom_ctl          = <store method only>
      optrom              = 
      reset               = <store method only>
      sfp                 = ""
      uevent              = <store method only>
      vpd                 = "�4"


  Class Device = "host4"
  Class Device path = "/sys/class/fc_host/host4"
    fabric_name         = "0x100000051e86f383"
    issue_lip           = <store method only>
    node_name           = "0x2000001b32891911"
    port_id             = "0x011800"
    port_name           = "0x2100001b32891911"
    port_state          = "Online"
    port_type           = "NPort (fabric via point-to-point)"
    speed               = "4 Gbit"
    supported_classes   = "Class 3"
    supported_speeds    = "1 Gbit, 2 Gbit, 4 Gbit"
    symbolic_name       = "QLE2460 FW:v5.06.03 DVR:v8.03.07.15.05.09-k"
    system_hostname     = ""
    tgtid_bind_type     = "wwpn (World Wide Port Name)"
    uevent              = <store method only>

    Device = "host4"
    Device path = "/sys/devices/pci0000:1d/0000:1d:00.0/0000:1e:00.0/host4"
      fw_dump             = 
      nvram               = "ISP "
      optrom_ctl          = <store method only>
      optrom              = 
      reset               = <store method only>
      sfp                 = ""
      uevent              = <store method only>
      vpd                 = "�4"

--------------------------------------------------------
[root@pcarshn01 ~]# systool -c fc_transport -v
Class = "fc_transport"

  Class Device = "0:0"
  Class Device path = "/sys/class/fc_transport/target3:0:0"
    node_name           = "0x500507630affc54f"                ------storage WWNN
    port_id             = "0x023800"                         -------存储端口的 24位交换机端口ID
    port_name           = "0x500507630a18c54f"                ------storage port WWPN
    uevent              = <store method only>

    Device = "target3:0:0"
    Device path = "/sys/devices/pci0000:17/0000:17:00.0/0000:18:00.0/host3/rport-3:0-0/target3:0:0"
      uevent              = <store method only>


  Class Device = "0:0"
  Class Device path = "/sys/class/fc_transport/target4:0:0"
    node_name           = "0x500507630affc54f"               ------storage WWNN
    port_id             = "0x020000"                         -------存储端口的 24位交换机端口ID
    port_name           = "0x500507630a00054f"               ------storage WWPN
    uevent              = <store method only>

    Device = "target4:0:0"
    Device path = "/sys/devices/pci0000:1d/0000:1d:00.0/0000:1e:00.0/host4/rport-4:0-0/target4:0:0"
      uevent              = <store method only>





