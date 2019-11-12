docker run --name mrepo7 -d \
 -v /root/web/repos-c7.conf:/etc/mrepo.conf.d/repos.conf \
 -v /mrepo/centos7:/mrepo \
 -e http_proxy=10.67.50.59:808 \
 -e https_proxy=10.67.50.59:808 \
 -e WEB=True \
 -p 8080:80 tfhartmann/mrepo
