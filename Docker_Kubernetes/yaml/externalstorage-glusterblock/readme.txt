##############rke部署的kubernetes使用gluster-block關鍵#############
1 rke cluster.yml
  kubelet:
    image: ""
    extra_args: {}
    extra_binds:
      - "/usr/libexec/kubernetes/kubelet-plugins:/usr/libexec/kubernetes/kubelet-plugins"
      - "/etc/iscsi:/etc/iscsi"
      - "/sbin/iscsiadm:/sbin/iscsiadm"
讓kubelet容器與host上的/etc/iscsi和/sbin/iscsiadm做bind-mount
否則kubelet容器里iscsiadm -m discovery時根本沒有反應, 會一直stuck在discovery狀態
2 
[root@rancher externalstorage-glusterblock]# cat glusterblock-sc.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: gluster-block
provisioner: gluster.org/glusterblock
parameters:
  resturl: "http://10.43.35.193:8081"
  restauthenabled: "false"
  chapauthenabled: "false"
  hacount: "3"
增加參數restauthenabled 和 chapauthenabled
沒有的話, iscsiadm login會失敗
3 在heketi.json里增加
   "auto_create_block_hosting_volume": true,
   "block_hosting_volume_size": 100,
   "block_hosting_volume_options": "group gluster-block",
   "pre_request_volume_options": "",
   "post_request_volume_options": ""
沒有的話, 默認不會允許建立 block volume
4 沒有provisioner
LAST SEEN   TYPE      REASON                   OBJECT                                     MESSAGE
31m         Normal    ExternalProvisioning     persistentvolumeclaim/data-db9-mysqlha-0   waiting for a volume to be created, either by external provisioner "gluster.org/glusterblock" or manually created by system administrator
需要自己deploy一個glusterblock provisioner
################從kubernetes 驗證#########
[root@rancher ~]# kubectl get pvc
NAME                     STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS    AGE
data-db9-mysqlha-0       Bound    pvc-34db5f6b-d14c-11e9-ac6a-0050569376db   6Gi        RWO            gluster-block   12m
data-db9-mysqlha-1       Bound    pvc-593c07b6-d14c-11e9-ac6a-0050569376db   6Gi        RWO            gluster-block   11m
data-redis-ha-server-0   Bound    pvc-bd5d4656-bcab-11e9-bbcf-0050569376db   10Gi       RWO            glusterfs       26d
data-redis-ha-server-1   Bound    pvc-df4d22ee-bcac-11e9-bbcf-0050569376db   10Gi       RWO            glusterfs       26d
data-redis-ha-server-2   Bound    pvc-216a992a-bcad-11e9-bbcf-0050569376db   10Gi       RWO            glusterfs       26d
[root@rancher ~]# kubectl describe pvc data-db9-mysqlha-0
Name:          data-db9-mysqlha-0
Namespace:     default
StorageClass:  gluster-block
Status:        Bound
Volume:        pvc-34db5f6b-d14c-11e9-ac6a-0050569376db
Labels:        app=db9-mysqlha
Annotations:   control-plane.alpha.kubernetes.io/leader:
                 {"holderIdentity":"9b8b28e7-d04a-11e9-af51-ae1fce7d1c0f","leaseDurationSeconds":15,"acquireTime":"2019-09-07T08:48:55Z","renewTime":"2019-...
               pv.kubernetes.io/bind-completed: yes
               pv.kubernetes.io/bound-by-controller: yes
               volume.beta.kubernetes.io/storage-provisioner: gluster.org/glusterblock
Finalizers:    [kubernetes.io/pvc-protection]
Capacity:      6Gi
Access Modes:  RWO
VolumeMode:    Filesystem
Mounted By:    db9-mysqlha-0
Events:
  Type    Reason                 Age                From                                                                                                     Message
  ----    ------                 ----               ----                                                                                                     -------
  Normal  ExternalProvisioning   12m (x4 over 12m)  persistentvolume-controller                                                                              waiting for a volume to be created, either by external provisioner "gluster.org/glusterblock" or manually created by system administrator
  Normal  Provisioning           12m                gluster.org/glusterblock glusterblock-provisioner-7d4ccd6bdd-dmzld 9b8b28e7-d04a-11e9-af51-ae1fce7d1c0f  External provisioner is provisioning volume for claim "default/data-db9-mysqlha-0"
  Normal  ProvisioningSucceeded  11m                gluster.org/glusterblock glusterblock-provisioner-7d4ccd6bdd-dmzld 9b8b28e7-d04a-11e9-af51-ae1fce7d1c0f  Successfully provisioned volume pvc-34db5f6b-d14c-11e9-ac6a-0050569376db
[root@rancher ~]# kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                            STORAGECLASS    REASON   AGE
pvc-216a992a-bcad-11e9-bbcf-0050569376db   10Gi       RWO            Delete           Bound    default/data-redis-ha-server-2   glusterfs                26d
pvc-34db5f6b-d14c-11e9-ac6a-0050569376db   6Gi        RWO            Delete           Bound    default/data-db9-mysqlha-0       gluster-block            12m
pvc-593c07b6-d14c-11e9-ac6a-0050569376db   6Gi        RWO            Delete           Bound    default/data-db9-mysqlha-1       gluster-block            11m
pvc-bd5d4656-bcab-11e9-bbcf-0050569376db   10Gi       RWO            Delete           Bound    default/data-redis-ha-server-0   glusterfs                26d
pvc-df4d22ee-bcac-11e9-bbcf-0050569376db   10Gi       RWO            Delete           Bound    default/data-redis-ha-server-1   glusterfs                26d
[root@rancher ~]# kubectl describe pv pvc-34db5f6b-d14c-11e9-ac6a-0050569376db
Name:            pvc-34db5f6b-d14c-11e9-ac6a-0050569376db
Labels:          <none>
Annotations:     AccessKey:
                 AccessKeyNs:
                 Blockstring: url:http://10.43.35.193:8081,user:,secret:,secretnamespace:
                 Description: Gluster-external: Dynamically provisioned PV
                 gluster.org/type: block
                 gluster.org/volume-id: 4036c161bd3c72bbf82406fd1f45a63b
                 glusterBlkProvIdentity: gluster.org/glusterblock
                 glusterBlockShare: blockvol_4036c161bd3c72bbf82406fd1f45a63b
                 kubernetes.io/createdby: heketi
                 pv.kubernetes.io/provisioned-by: gluster.org/glusterblock
                 v2.0.0: v2.0.0
Finalizers:      [kubernetes.io/pv-protection]
StorageClass:    gluster-block
Status:          Bound
Claim:           default/data-db9-mysqlha-0
Reclaim Policy:  Delete
Access Modes:    RWO
VolumeMode:      Filesystem
Capacity:        6Gi
Node Affinity:   <none>
Message:
Source:
    Type:               ISCSI (an ISCSI Disk resource that is attached to a kubelet's host machine and then exposed to the pod)
    TargetPortal:       10.67.36.153
    IQN:                iqn.2016-12.org.gluster-block:dd77fe82-e44d-479c-ab7f-a0a2d124ff4b
    Lun:                0
    ISCSIInterface      default
    FSType:             xfs
    ReadOnly:           false
    Portals:            [10.67.36.151 10.67.36.152]
    DiscoveryCHAPAuth:  false
    SessionCHAPAuth:    false
    SecretRef:          nil
    InitiatorName:      <none>
Events:                 <none>

[root@rancher ~]# kubectl get pv pvc-34db5f6b-d14c-11e9-ac6a-0050569376db -o yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  annotations:
    AccessKey: ""
    AccessKeyNs: ""
    Blockstring: 'url:http://10.43.35.193:8081,user:,secret:,secretnamespace:'
    Description: 'Gluster-external: Dynamically provisioned PV'
    gluster.org/type: block
    gluster.org/volume-id: 4036c161bd3c72bbf82406fd1f45a63b
    glusterBlkProvIdentity: gluster.org/glusterblock
    glusterBlockShare: blockvol_4036c161bd3c72bbf82406fd1f45a63b
    kubernetes.io/createdby: heketi
    pv.kubernetes.io/provisioned-by: gluster.org/glusterblock
    v2.0.0: v2.0.0
  creationTimestamp: "2019-09-07T08:48:16Z"
  finalizers:
  - kubernetes.io/pv-protection
  name: pvc-34db5f6b-d14c-11e9-ac6a-0050569376db
  resourceVersion: "8670962"
  selfLink: /api/v1/persistentvolumes/pvc-34db5f6b-d14c-11e9-ac6a-0050569376db
  uid: 3c0e7c11-d14c-11e9-ac6a-0050569376db
spec:
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 6Gi
  claimRef:
    apiVersion: v1
    kind: PersistentVolumeClaim
    name: data-db9-mysqlha-0
    namespace: default
    resourceVersion: "8670943"
    uid: 34db5f6b-d14c-11e9-ac6a-0050569376db
  iscsi:
    fsType: xfs
    iqn: iqn.2016-12.org.gluster-block:dd77fe82-e44d-479c-ab7f-a0a2d124ff4b
    iscsiInterface: default
    lun: 0
    portals:
    - 10.67.36.151
    - 10.67.36.152
    targetPortal: 10.67.36.153
  persistentVolumeReclaimPolicy: Delete
  storageClassName: gluster-block
  volumeMode: Filesystem
status:
  phase: Bound

##############從 worker4 的kubelet容器中驗證###########  
[root@worker4 ~]# docker exec -it kubelet sh
sh-4.4# iscsiadm -m session
tcp: [1] 10.67.36.153:3260,1 iqn.2016-12.org.gluster-block:dd77fe82-e44d-479c-ab7f-a0a2d124ff4b (non-flash)
tcp: [2] 10.67.36.151:3260,2 iqn.2016-12.org.gluster-block:dd77fe82-e44d-479c-ab7f-a0a2d124ff4b (non-flash)
tcp: [3] 10.67.36.152:3260,3 iqn.2016-12.org.gluster-block:dd77fe82-e44d-479c-ab7f-a0a2d124ff4b (non-flash)
 
################從worker4上驗證#########
[root@worker4 ~]# lsblk -fs
NAME        FSTYPE       LABEL UUID                                   MOUNTPOINT
fd0
sda1        xfs                77b58b7f-d2ba-4bc9-92a9-b90acbfe77d4   /boot
└─sda
sr0
centos-root xfs                22893a50-a2dc-49c5-a4ca-5309a9cd39fa   /
└─sda2      LVM2_member        6GczNm-hEhH-aqk3-ZBk2-s9cF-yX7w-BX1ZzL
  └─sda
centos-swap swap               93b27f2d-bd80-402e-8ef5-4ef5ce420a4f
└─sda2      LVM2_member        6GczNm-hEhH-aqk3-ZBk2-s9cF-yX7w-BX1ZzL
  └─sda
mpatha      xfs                624bf1ff-4250-4f9e-8d76-dbb1b5598adb   /var/lib/kubelet/pods/34e25304-d14c-11e9-ac6a-0050569376db/volumes/kubernetes.io~iscsi/pvc-34db5f6b-
├─sdb       mpath_member
├─sdc       mpath_member
└─sdd       mpath_member
[root@worker4 ~]# multipath -ll
mpatha (36001405dd77fe82e44d479cab7fa0a2d) dm-2 LIO-ORG ,TCMU device
size=6.0G features='1 queue_if_no_path' hwhandler='0' wp=rw
|-+- policy='round-robin 0' prio=1 status=active
| `- 3:0:0:0 sdb 8:16 active ready running
|-+- policy='round-robin 0' prio=1 status=enabled
| `- 4:0:0:0 sdc 8:32 active ready running
`-+- policy='round-robin 0' prio=1 status=enabled
  `- 5:0:0:0 sdd 8:48 active ready running
[root@worker4 ~]# iscsiadm -m session -P 3
iSCSI Transport Class version 2.0-870
version 6.2.0.874-10
Target: iqn.2016-12.org.gluster-block:dd77fe82-e44d-479c-ab7f-a0a2d124ff4b (non-flash)
        Current Portal: 10.67.36.153:3260,1
        Persistent Portal: 10.67.36.153:3260,1
                **********
                Interface:
                **********
                Iface Name: default
                Iface Transport: tcp
                Iface Initiatorname: iqn.1994-05.com.redhat:b49893446d97
                Iface IPaddress: 10.67.36.59
                Iface HWaddress: <empty>
                Iface Netdev: <empty>
                SID: 1
                iSCSI Connection State: LOGGED IN
                iSCSI Session State: LOGGED_IN
                Internal iscsid Session State: NO CHANGE
                *********
                Timeouts:
                *********
                Recovery Timeout: 5
                Target Reset Timeout: 30
                LUN Reset Timeout: 30
                Abort Timeout: 15
                *****
                CHAP:
                *****
                username: <empty>
                password: ********
                username_in: <empty>
                password_in: ********
                ************************
                Negotiated iSCSI params:
                ************************
                HeaderDigest: None
                DataDigest: None
                MaxRecvDataSegmentLength: 262144
                MaxXmitDataSegmentLength: 262144
                FirstBurstLength: 65536
                MaxBurstLength: 262144
                ImmediateData: Yes
                InitialR2T: Yes
                MaxOutstandingR2T: 1
                ************************
                Attached SCSI devices:
                ************************
                Host Number: 3  State: running
                scsi3 Channel 00 Id 0 Lun: 0
                        Attached scsi disk sdb          State: running
        Current Portal: 10.67.36.151:3260,2
        Persistent Portal: 10.67.36.151:3260,2
                **********
                Interface:
                **********
                Iface Name: default
                Iface Transport: tcp
                Iface Initiatorname: iqn.1994-05.com.redhat:b49893446d97
                Iface IPaddress: 10.67.36.59
                Iface HWaddress: <empty>
                Iface Netdev: <empty>
                SID: 2
                iSCSI Connection State: LOGGED IN
                iSCSI Session State: LOGGED_IN
                Internal iscsid Session State: NO CHANGE
                *********
                Timeouts:
                *********
                Recovery Timeout: 5
                Target Reset Timeout: 30
                LUN Reset Timeout: 30
                Abort Timeout: 15
                *****
                CHAP:
                *****
                username: <empty>
                password: ********
                username_in: <empty>
                password_in: ********
                ************************
                Negotiated iSCSI params:
                ************************
                HeaderDigest: None
                DataDigest: None
                MaxRecvDataSegmentLength: 262144
                MaxXmitDataSegmentLength: 262144
                FirstBurstLength: 65536
                MaxBurstLength: 262144
                ImmediateData: Yes
                InitialR2T: Yes
                MaxOutstandingR2T: 1
                ************************
                Attached SCSI devices:
                ************************
                Host Number: 4  State: running
                scsi4 Channel 00 Id 0 Lun: 0
                        Attached scsi disk sdc          State: running
        Current Portal: 10.67.36.152:3260,3
        Persistent Portal: 10.67.36.152:3260,3
                **********
                Interface:
                **********
                Iface Name: default
                Iface Transport: tcp
                Iface Initiatorname: iqn.1994-05.com.redhat:b49893446d97
                Iface IPaddress: 10.67.36.59
                Iface HWaddress: <empty>
                Iface Netdev: <empty>
                SID: 3
                iSCSI Connection State: LOGGED IN
                iSCSI Session State: LOGGED_IN
                Internal iscsid Session State: NO CHANGE
                *********
                Timeouts:
                *********
                Recovery Timeout: 5
                Target Reset Timeout: 30
                LUN Reset Timeout: 30
                Abort Timeout: 15
                *****
                CHAP:
                *****
                username: <empty>
                password: ********
                username_in: <empty>
                password_in: ********
                ************************
                Negotiated iSCSI params:
                ************************
                HeaderDigest: None
                DataDigest: None
                MaxRecvDataSegmentLength: 262144
                MaxXmitDataSegmentLength: 262144
                FirstBurstLength: 65536
                MaxBurstLength: 262144
                ImmediateData: Yes
                InitialR2T: Yes
                MaxOutstandingR2T: 1
                ************************
                Attached SCSI devices:
                ************************
                Host Number: 5  State: running
                scsi5 Channel 00 Id 0 Lun: 0
                        Attached scsi disk sdd          State: running
