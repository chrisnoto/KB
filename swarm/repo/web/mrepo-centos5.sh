docker run --name mrepo5 -d \
 -v /root/web/repos-c5.conf:/etc/mrepo.conf.d/repos.conf \
 -v /mrepo/centos5:/mrepo \
 -e http_proxy=10.67.9.200:3128 \
 -e https_proxy=10.67.9.200:3128 \
 -e WEB=True -p 8082:80 tfhartmann/mrepo
