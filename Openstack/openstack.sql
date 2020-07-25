select nova.instances.hostname,nova.instances.vcpus,nova.instances.memory_mb,nova.instances.root_gb,cinder.volumes.display_name as volume_name,cinder.volumes.size from cinder.volumes join cinder.volume_attachment,nova.instances where cinder.volumes.id=cinder.volume_attachment.volume_id and cinder.volume_attachment.instance_uuid=nova.instances.uuid and volumes.deleted='false' group by cinder.volumes.display_name;
select nova.instances.hostname,nova.instances.vcpus,nova.instances.memory_mb,nova.instances.root_gb,cinder.volumes.display_name as volume_name,cinder.volumes.size from cinder.volumes join cinder.volume_attachment,nova.instances where cinder.volumes.id=cinder.volume_attachment.volume_id and cinder.volume_attachment.instance_uuid=nova.instances.uuid and volumes.deleted='false' group by cinder.volumes.display_name INTO OUTFILE '/var/lib/mysql-files/vm.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

mysql> select glance.images.name,count(glance.images.id) as image_count from nova.instances join glance.images where nova.instances.vm_state='active' and nova.instances.image_ref=glance.images.id group by glance.images.name order by image_count DESC;
+-----------------------------+-------------+
| name                        | image_count |
+-----------------------------+-------------+
| CentOS7.6-LVM               |          18 |
| w2k16-Template2.qcow2       |          14 |
| w2k16-Template.qcow2        |          10 |
| w2k12r2-Template-2.0        |          10 |
| CentOS7                     |           9 |
| centos7-ryan                |           7 |
| Ubuntu1604                  |           5 |
| CentOS6                     |           4 |
| w2k12r2_en_template         |           4 |
| Python001                   |           3 |
| CentOS6_LVM_Template        |           2 |
| w2k08r2-Template-1.0        |           2 |
| zabbix_openstack-20200619   |           1 |
| chiwen_10.67.44.125         |           1 |
| 10.67.44.135                |           1 |
| oSTJNEWMESDB01-20190525     |           1 |
| oSTJefoxNCap01-190527       |           1 |
| python_dev-1-20190529       |           1 |
| oSTJgatekeeper_sit-20190530 |           1 |
| 3783_snapshot0805           |           1 |
| Ubuntu1604_LVM_template     |           1 |
+-----------------------------+-------------+
21 rows in set (0.00 sec)
