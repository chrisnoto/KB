[root@rancher ~]# kubectl get pvc
NAME                     STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS    AGE
data-db1-mysqlha-0       Bound    pvc-09c74f9b-d044-11e9-ac6a-0050569376db   10Gi       RWO            gluster-block   4s
data-redis-ha-server-0   Bound    pvc-bd5d4656-bcab-11e9-bbcf-0050569376db   10Gi       RWO            glusterfs       24d
data-redis-ha-server-1   Bound    pvc-df4d22ee-bcac-11e9-bbcf-0050569376db   10Gi       RWO            glusterfs       24d
data-redis-ha-server-2   Bound    pvc-216a992a-bcad-11e9-bbcf-0050569376db   10Gi       RWO            glusterfs       24d
[root@rancher ~]# kubectl describe pvc data-db1-mysqlha-0
Name:          data-db1-mysqlha-0
Namespace:     default
StorageClass:  gluster-block
Status:        Bound
Volume:        pvc-09c74f9b-d044-11e9-ac6a-0050569376db
Labels:        app=db1-mysqlha
Annotations:   control-plane.alpha.kubernetes.io/leader:
                 {"holderIdentity":"c02d6330-d042-11e9-9b87-169be71558ee","leaseDurationSeconds":15,"acquireTime":"2019-09-06T01:17:05Z","renewTime":"2019-...
               pv.kubernetes.io/bind-completed: yes
               pv.kubernetes.io/bound-by-controller: yes
               volume.beta.kubernetes.io/storage-provisioner: gluster.org/glusterblock
Finalizers:    [kubernetes.io/pvc-protection]
Capacity:      10Gi
Access Modes:  RWO
VolumeMode:    Filesystem
Mounted By:    db1-mysqlha-0
Events:
  Type    Reason                 Age                From                                                                                                     Me                                      ssage
  ----    ------                 ----               ----                                                                                                     --                                      -----
  Normal  Provisioning           15s                gluster.org/glusterblock glusterblock-provisioner-7d4ccd6bdd-blkw2 c02d6330-d042-11e9-9b87-169be71558ee  Ex                                      ternal provisioner is provisioning volume for claim "default/data-db1-mysqlha-0"
  Normal  ExternalProvisioning   13s (x5 over 15s)  persistentvolume-controller                                                                              wa                                      iting for a volume to be created, either by external provisioner "gluster.org/glusterblock" or manually created by system administrator
  Normal  ProvisioningSucceeded  12s                gluster.org/glusterblock glusterblock-provisioner-7d4ccd6bdd-blkw2 c02d6330-d042-11e9-9b87-169be71558ee  Su                                      ccessfully provisioned volume pvc-09c74f9b-d044-11e9-ac6a-0050569376db
[root@rancher ~]# kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                            STORAGECLASS    REASON   AGE
pvc-09c74f9b-d044-11e9-ac6a-0050569376db   10Gi       RWO            Delete           Bound    default/data-db1-mysqlha-0       gluster-block            19s
[root@rancher ~]# kubectl get pv pvc-09c74f9b-d044-11e9-ac6a-0050569376db -o yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  annotations:
    AccessKey: glusterblk-b2f6ac59-6ca3-40de-801a-e091d36221eb-secret
    AccessKeyNs: default
    Blockstring: 'url:http://10.43.35.193:8081,user:,secret:,secretnamespace:'
    Description: 'Gluster-external: Dynamically provisioned PV'
    gluster.org/type: block
    gluster.org/volume-id: 6c8a76d94b268d334c8d82e7e19bdae1
    glusterBlkProvIdentity: gluster.org/glusterblock
    glusterBlockShare: blockvol_6c8a76d94b268d334c8d82e7e19bdae1
    kubernetes.io/createdby: heketi
    pv.kubernetes.io/provisioned-by: gluster.org/glusterblock

[root@master kubelet-plugins]# heketi-cli blockvolume list
Id:6c8a76d94b268d334c8d82e7e19bdae1    Cluster:19971a3ec4307d366539a5d323c73cf3    Name:blockvol_6c8a76d94b268d334c8d82e7e19bdae1
