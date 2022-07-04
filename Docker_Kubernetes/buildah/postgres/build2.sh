buildah from localhost/centos:7
new=`buildah mount centos-working-container`
rm -f ${new}/etc/yum.repos.d/C*
curl -o ${new}/etc/yum.repos.d/centos7.repo http://10.67.51.164/repofile/centos7.repo
buildah run centos-working-container yum install -y postgresql14 postgresql14-server postgresql14-contrib iproute
buildah config --env PGDATA="/var/lib/pgsql/14/data" centos-working-container
buildah config --env PATH="$PATH:/usr/pgsql-14/bin" centos-working-container
buildah config --env PGDATABASE="" centos-working-container
buildah config --env PGUSERNAME="" centos-working-container
buildah config --env PGPASSWORD="" centos-working-container
buildah config --env PGADMPWD="" centos-working-container
buildah config --user postgres centos-working-container
buildah config --entrypoint '["/usr/bin/entrypoint.sh"]' centos-working-container
buildah copy centos-working-container /root/entrypoint.sh /usr/bin/entrypoint.sh
buildah run centos-working-container chmod +x /usr/bin/entrypoint.sh
buildah config --cmd "postgres" centos-working-container
buildah config --port 5432  centos-working-container
buildah config --volume /var/lib/pgsql/14/data centos-working-container
buildah config --stop-signal SIGINT centos-working-container
buildah commit centos-working-container mypg14:20220701
buildah rm centos-working-container
