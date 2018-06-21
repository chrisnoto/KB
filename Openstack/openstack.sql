select nova.instances.hostname,nova.instances.vcpus,nova.instances.memory_mb,nova.instances.root_gb,cinder.volumes.display_name as volume_name,cinder.volumes.size from cinder.volumes join cinder.volume_attachment,nova.instances where cinder.volumes.id=cinder.volume_attachment.volume_id and cinder.volume_attachment.instance_uuid=nova.instances.uuid and volumes.deleted='false' group by cinder.volumes.display_name;
select nova.instances.hostname,nova.instances.vcpus,nova.instances.memory_mb,nova.instances.root_gb,cinder.volumes.display_name as volume_name,cinder.volumes.size from cinder.volumes join cinder.volume_attachment,nova.instances where cinder.volumes.id=cinder.volume_attachment.volume_id and cinder.volume_attachment.instance_uuid=nova.instances.uuid and volumes.deleted='false' group by cinder.volumes.display_name INTO OUTFILE '/var/lib/mysql-files/vm.csv' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';
