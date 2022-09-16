#!/bin/bash

yum install -y acpid cloud-init cloud-utils-growpart
systemctl enable acpid

# adjust cloud-init configuration
sed -i '/disable_root/s/1/0/' /etc/cloud/cloud.cfg
sed -i '/ssh_pwauth/s/0/1/' /etc/cloud/cloud.cfg
sed -i '/update_etc_hosts/s/^ /#/' /etc/cloud/cloud.cfg
sed -i '/update_hostname/s/^ /#/' /etc/cloud/cloud.cfg
sed -i '/yum-add-repo/s/^ /#/' /etc/cloud/cloud.cfg
sed -i '/ssh_pwauth/a package_upgrade:\ false' /etc/cloud/cloud.cfg
sed -i '/ssh_pwauth/a manage_etc_hosts:\ false' /etc/cloud/cloud.cfg


# remove interface UUID
sed -i '/UUID/d' /etc/sysconfig/network-scripts/ifcfg-eth0

rpm -qa kernel | sed 's/^kernel-//'  | xargs -I {} dracut -f /boot/initramfs-{}.img {}

