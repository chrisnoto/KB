docker run --name repo8 -d \
  -v /root/web/centos8.repo:/etc/yum.repos.d/centos8.repo \
  -v /mrepo/centos8:/usr/share/nginx/html/centos8-x86_64 \
  -v /root/web/nginx-repo8.conf:/etc/nginx/nginx.conf \
  -e http_proxy=10.67.9.200:3128 \
  -e https_proxy=10.67.9.200:3128 \
  -p 8084:80 reposync:centos8
