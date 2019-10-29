kubectl create configmap logstash-pipeline-conf --from-file ~/production/logstash/configmap/conf.d
kubectl create configmap logstash-conf --from-file ~/production/logstash/configmap
