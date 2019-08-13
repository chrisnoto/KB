kubectl create configmap logstash-pipeline-conf --from-file ~/logstash/configmap/conf.d
kubectl create configmap logstash-conf --from-file ~/logstash/configmap
