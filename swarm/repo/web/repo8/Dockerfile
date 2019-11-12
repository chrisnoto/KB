FROM centos:8
MAINTAINER chensen <chensen@mail.foxconn.com>

RUN sed -i '/main/a proxy=http://10.67.9.200:3128' /etc/yum.conf

RUN rm -f /etc/yum.repos.d/*

ADD centos8.repo /etc/yum.repos.d/centos8.repo

RUN dnf install dnf-plugins-core dnf-utils nginx cronie -y

RUN mkdir -p /usr/share/nginx/html/centos8-x86_64

ADD cron-reposync /etc/cron.d/reposync

ADD run.sh /run.sh

VOLUME /usr/share/nginx/html/centos8-x86_64

VOLUME /var/log

EXPOSE 80

CMD /run.sh


