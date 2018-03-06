Nginx:
worker
worker_connection cpu_affinity
use epoll；
隐藏nginx ver
隐藏nginx软件
timeout  keepalive
nginx connection timeout
fastcgi connection timeout
cache  读
buffer 写
gzip  优势劣势 只压缩文本文件
expires  优势劣势  广告，统计程序不缓存。
http://xxx/robots.txt 爬虫排除协议
虚拟主机
rewrite
fastcgi_pass
proxy_pass
upstream

平滑重启
apachectl graceful
nginx -s reload
kill -USR2 `cat php-fpm.pid`


apache隐藏版本号
ServerTokens Prod
ServerSignature Off

php编译支持远程mysql
--with-mysql=mysqlnd \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
查看编译参数：
nginx -V
cat /app/apache/build/config.nice
grep CONFIGURE_LINE /app/mysql/bin/mysqlbug
php -i |grp configure

php加速器
xcache > eacc > zend apc
memcache.so  redis.so  数据库缓存模块
PDO_mysql 统一数据库接口
ImangeMagick 图形处理
php使用模块
extension_dir=""
extension=memchache.so
extension=pdo_mysql.so
extension=imagick.so

tmpfs 缓存目录使用tmpfs
mount -t tmpfs -o size=2G tmpfs /tmp
mount限制权限
mount -o noexec,nosuid

禁止apache使用php
<Directory>
 php_flag engine off
</Directory>

Tcmalloc优化Nginx性能  tcmalloc比标准glibc库的malloc在内存分配效率和速度上高很多

防盗链与广告收入   
1 图片 视频打水印，logo
2 根据referer机制 rewrite
3 根据cookie处理   rewrite
4 通过加密变换访问路径实现防盗链
NginxHttpAccessKeyModule实现防盗链

伪静态
nginx.org/en/docs/

php优化
safe_mode=on
safe_mode_grid=off
disable_functions=system,passthru,exec,shell_exec,popen,phpinfo
expose_php=Off
register_globals=Off
magic_quotes_gpc=On 防SQL注入
disply_errors=Off
max_execution_time=30  (sec)
memory_limit=128M     编译时--enable-memory-limit
allow_url_fopen=Off
session.save_handler=memcache     --enable-memcache
session.save_path='tcp://xxxx:11211'
http://blog.zyan.cc/nginx_php_v6

