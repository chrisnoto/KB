docker service create --name logrotate --mode global \
  --mount type=bind,source=/var/lib/docker/containers,destination=/var/lib/docker/containers \
  -e "LOGROTATE_INTERVAL=daily" \
  -e "LOGROTATE_CRONSCHEDULE=30 10 * * * *" \
  -e "LOGS_DIRECTORIES=/var/lib/docker/containers /var/log/docker" \
  -e "LOGROTATE_DATEFORMAT=-%Y%m%d" \
  blacklabelops/logrotate
