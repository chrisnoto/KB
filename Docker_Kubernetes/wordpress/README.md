部署wordpress所需的image
wordpress:4.8-apache
mysql:5.6

使用statefulset及動態存儲： 定義好的storage-class： nfs-storage

1  創建mysql secret
kubectl create secret generic mysql-pass --from-literal=password=YOUR_PASSWORD

2 使用以下模板部署wordpress
kubectl apply -f wordpress-mysql.yaml
kubectl apply -f wordpress.yaml
