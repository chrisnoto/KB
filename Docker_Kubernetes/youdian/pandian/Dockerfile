FROM 10.67.51.164:5000/youdian/httpd2.4.6-php:7.3.33v1
MAINTAINER sen.chen@mail.foxconn.com

ENV DOMAIN ""

RUN set -ex; \
    yum install -y gettext git; \
    git config --global user.name "sen.chen@mail.foxconn.com"; \
    git config --global credential.helper store; \
    echo "https://sen.chen%40mail.foxconn.com:F0xc0nn%2123456@gitlab.ces.efoxconn.com" > /root/.git-credentials; \
    chmod 600 /root/.git-credentials; \
    cd /var/www; \
    git clone https://gitlab.ces.efoxconn.com/H7108579/pandian_v107.git youdian_v107; \
    chmod -R 777 youdian_v107/Application/Runtime; \
    chown -R 48:48 youdian_v107
    

COPY config.php.template /var/www/youdian_v107/Application/Admin/Conf/
COPY pandian.conf.template /etc/httpd/conf.d/
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["httpd-foreground"]
