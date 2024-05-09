#!/usr/bin/bash
#******************************************
# Author:       Sen Chen
# Date:         2024/2/21
# Email:        sen.chen@mail.foxconn.com
# Description:  389DS Install Script
#******************************************

custom_vars(){
cat > /root/install.config <<EOF
INS_NAME=ldap
FQDN=ldap09.cesbg.fii
DS_ROOT_PW=Foxconn123123
DS_REPLICA_USER="cn=repl,cn=config"
DS_REPLICA_PW=Foxconn123123
DS_REPLICA_ID=21
DS_SUFFIX="dc=cesbg,dc=fii"
DS_TOKEN=Foxconn123
CERT_DIR="/root/"
AD_IP="10.66.14.220"
AD_USER=ldap
AD_PW=Foxconn12345
AD_CERT_TPL=RDComputer
EOF

source /root/install.config

}

set_firewall(){
  systemctl status firewalld
  [ $? -gt 0 ] && systemctl enable --now firewalld
  firewall-cmd --zone=public --add-port=636/tcp --permanent
  firewall-cmd --zone=public --add-port=389/tcp --permanent
  firewall-cmd --reload
}

set_hosts(){
  echo "$(hostname -I) ${FQDN}" >> /etc/hosts
}

gen_yum_repo(){
rm -rf /etc/yum.repos.d/*.repo
cat > /etc/yum.repos.d/rocky.repo <<EOF
[baseos]
name=Rocky Linux \$releasever - BaseOS
baseurl=https://yum.efoxconn.com/rocky/\$releasever/BaseOS/\$basearch/os/
gpgcheck=0
enabled=1
countme=1
metadata_expire=6h
verifyssl=0

[appstream]
name=Rocky Linux \$releasever - AppStream
baseurl=https://yum.efoxconn.com/rocky/\$releasever/AppStream/\$basearch/os/
gpgcheck=0
enabled=1
countme=1
metadata_expire=6h
verifyssl=0

[extras]
name=Rocky Linux \$releasever - Extras
baseurl=https://yum.efoxconn.com/rocky/\$releasever/extras/\$basearch/os/
gpgcheck=0
enabled=1
countme=1
metadata_expire=6h
verifyssl=0

[epel]
name=Rocky Linux \$releasever - epel
baseurl=https://yum.efoxconn.com/epel/\$releasever/Everything/x86_64/
gpgcheck=0
enabled=1
countme=1
metadata_expire=6h
verifyssl=0

EOF
yum clean all
}

install_389ds(){
  yum install -y 389-ds-base
  [ $? -gt 0 ] && echo "389ds is not installed successfully. Please check yum settings. " && exit 1
  DS_DIR=/etc/dirsrv/slapd-${INS_NAME}
}

gen_389ds_template(){
cat > /root/template.txt <<EOF
[general]
full_machine_name = ${FQDN}
strict_host_checking = False
[slapd]
instance_name = ${INS_NAME}
root_password = ${DS_ROOT_PW}
self_sign_cert = False
[backend-userroot]
create_suffix_entry = True
enable_replication = True
replica_binddn = ${DS_REPLICA_USER}
replica_bindpw = ${DS_REPLICA_PW}
replica_id = ${DS_REPLICA_ID}
replica_role = supplier
sample_entries = yes
suffix = ${DS_SUFFIX}
EOF

}

create_389ds_instance(){
  dscreate -v from-file template.txt
}



reset_nssdb(){
  yum install -y expect
  [ $? -gt 0 ] && echo "expect is not installed successfully. Please check yum settings. " && exit 1
  mv ${DS_DIR}/*.db /tmp
  expect -c "
  set timeout 5;
  spawn certutil -d ${DS_DIR} -N;
    expect {
           \"*assword:\" {send \"$password\r\"; exp_continue}
           \"*assword:\" {send \"$password\r\";}
           }
  "
  echo "Internal (Software) Token:${DS_TOKEN}" >${DS_DIR}/pin.txt
  echo "Internal (Software) Token:${DS_TOKEN}" >${DS_DIR}/pwdfile.txt

}

install_python_libs(){
  yum install -y python3-requests_ntlm python3-beautifulsoup4 python3-cryptography
  [ $? -gt 0 ] && echo "python libs are not installed successfully. Please check yum settings. " && exit 1

  # enable legacy hashing algorithms eg MD4
  sed -i 's/^##legacy/legacy/' /etc/ssl/openssl.cnf
  sed -i 's/^##activate/activate/' /etc/ssl/openssl.cnf
  sed -i 's/^##\[legacy_sect\]/\[legacy_sect\]/' /etc/ssl/openssl.cnf
}

gen_certs(){
  python /root/gencerts.py
}

import_certs(){
  openssl pkcs12 -export -in ${FQDN}.cer -inkey ${FQDN}.key -out ${FQDN}.p12 -name Server-Cert
  pk12util -i ${FQDN}.p12 -d ${DS_DIR}
  certutil -d ${DS_DIR} -A -n "CA" -t "CT,," -a -i ca.cer
}

enable_389ds_ssl(){
  dsconf ${INS_NAME} config replace nsslapd-security=on
  systemctl restart dirsrv@${INS_NAME}
}

enable_389ds_unhashed_pw(){
  dsconf ${INS_NAME} config replace nsslapd-unhashed-pw-switch=on
}

main(){
  custom_vars
  set_firewall
  set_hosts
  gen_yum_repo
  install_389ds
  gen_389ds_template
  create_389ds_instance
  reset_nssdb
  install_python_libs
  gen_certs
  import_certs
  enable_389ds_ssl
  enable_389ds_unhashed_pw

}

main
