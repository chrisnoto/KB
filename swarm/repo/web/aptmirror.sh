docker run --name apt-mirror -d \
 -v /root/web/mirror.list:/etc/apt/mirror.list \
 -v /root/web/nginx-apt-mirror.conf:/etc/nginx/sites-enabled/default \
 -v /mrepo/ubuntu:/var/spool/apt-mirror \
 -e http_proxy=10.67.9.200:3128 \
 -e https_proxy=10.67.9.200:3128 \
 -p 8083:80 flomine/apt-mirror:latest
