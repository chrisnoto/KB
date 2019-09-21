docker run --name mrepo6 -d \
 -v /root/web/repos-c6.conf:/etc/mrepo.conf.d/repos.conf \
 -v /mrepo/centos6:/mrepo \
 -e http_proxy=10.67.9.200:3128 \
 -e https_proxy=10.67.9.200:3128 \
 -e WEB=True \
 -p 8081:80 tfhartmann/mrepo
