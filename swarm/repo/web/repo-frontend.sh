docker run --name repo-frontend -d \
  -v /root/web/default.conf:/etc/nginx/conf.d/default.conf \
  -v /mrepo/html:/usr/share/nginx/html \
  -e TZ='Asia/Shanghai' -p 80:80 nginx:latest
