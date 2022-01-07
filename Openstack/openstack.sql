select nova.instances.hostname,nova.instances.vcpus,nova.instances.memory_mb,nova.instances.root_gb,cinder.volumes.display_name as volume_name,cinder.volumes.size from cinder.volumes join cinder.volume_attachment,nova.instances where cinder.volumes.id=cinder.volume_attachment.volume_id and cinder.volume_attachment.instance_uuid=nova.instances.uuid and volumes.deleted='false' group by cinder.volumes.display_name;
select nova.instances.hostname,nova.instances.vcpus,nova.instances.memory_mb,nova.instances.root_gb,cinder.volumes.display_name as volume_name,cinder.volumes.size from cinder.volumes join cinder.volume_attachment,nova.instances where cinder.volumes.id=cinder.volume_attachment.volume_id and cinder.volume_attachment.instance_uuid=nova.instances.uuid and volumes.deleted='false' group by cinder.volumes.display_name INTO OUTFILE '/var/lib/mysql-files/vm.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

mysql> select id,host_ip,hypervisor_hostname,running_vms,host,uuid from compute_nodes where running_vms >0;
+----+--------------+---------------------+-------------+--------------------+--------------------------------------+
| id | host_ip      | hypervisor_hostname | running_vms | host               | uuid                                 |
+----+--------------+---------------------+-------------+--------------------+--------------------------------------+
|  1 | 192.168.0.8  | node-8.domain.tld   |           8 | node-8.domain.tld  | 7730e360-b6d8-40ec-bbd1-1e62f210c996 |
|  4 | 192.168.0.14 | node-9.domain.tld   |           4 | node-9.domain.tld  | 7569c19a-257b-4bd7-bf04-854317c52299 |
|  7 | 192.168.0.15 | node-10.domain.tld  |           5 | node-10.domain.tld | 10fffbc9-d956-4643-8153-cdab291b26c9 |
| 17 | 192.168.0.21 | node-16.domain.tld  |           8 | node-16.domain.tld | 7461cd31-593d-487e-8e4d-13f4afcfdfd3 |


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

#### procedure ####
root@node-1:~# cat GetImage.sql
drop procedure if exists GetImage;
delimiter //
create procedure GetImage()
begin
  select glance.images.name,count(glance.images.id) as image_count from nova.instances join glance.images 
  where nova.instances.vm_state='active' and nova.instances.image_ref=glance.images.id 
  group by glance.images.name 
  order by image_count 
  DESC;
end; //
delimiter ;

#### procedure with cursor ####
root@node-1:~# cat GetImage.sql
drop procedure if exists GetImage;
delimiter //
create procedure GetImage()
begin
  declare image_name varchar(50);
  declare image_count int;
  declare Linux_total int default 0;
  declare Windows_total int default 0;
  declare Unknown_total int default 0;
  declare done int default false;
  declare cur1 cursor for
  select glance.images.name,count(glance.images.id) as image_count from nova.instances join glance.images
  where nova.instances.vm_state='active' and nova.instances.image_ref=glance.images.id
  group by glance.images.name
  order by image_count
  DESC;
  declare continue handler for not found set done = true;
  set Linux_total =0;
  set Windows_total = 0;
  set Unknown_total = 0;
  open cur1;
  read_loop:loop
  fetch cur1 into image_name,image_count;
  if done then
      leave read_loop;
  end if;
  if image_name like 'CentOS%' or image_name like 'centos%' or image_name like 'Ubuntu%' then
      set Linux_total = Linux_total + image_count;
  elseif image_name like 'w2k%' then
      set Windows_total = Windows_total + image_count;
  else
      set Unknown_total = Unknown_total + image_count;
  end if;
  end loop read_loop;
  close cur1;
  select Linux_total,Windows_total,Unknown_total;
end; //
delimiter ;

mysql> call GetImage();
+-------------+---------------+---------------+
| Linux_total | Windows_total | Unknown_total |
+-------------+---------------+---------------+
|          45 |            39 |            11 |
+-------------+---------------+---------------+
