FROM centos:7.9.2009
MAINTAINER sen.chen@mail.foxconn.com

RUN set -ex; \
      rm -rf /etc/yum.repos.d/*.repo; \
      curl -o /etc/yum.repos.d/centos7.repo http://10.67.51.164/repofile/centos7.repo; \
      yum clean all; \
      yum install -y make \
                     gcc \
                     gcc-devel \
                     gcc-c++ \
                     libgcc \
                     autoconf \
                     automake \
                     httpd-devel \
                     httpd \
                     zlib \
                     zlib-devel \
                     openssl \
                     openssl-devel \
                     pcre \
                     pcre-devel \
                     libffi \
                     libffi-devel \
                     libxml2 \
                     libxml2-devel \
                     sqlite-devel \
                     mysql \
                     mysql-devel \
                     readline-devel \
                     bzip2 \
                     bzip2-devel \
                     expat-devel \
                     gdbm-devel \
                     python-devel \
                     MariaDB-shared \
                     curl \
                     curl-devel \
                     libjpeg-devel \
                     libpng \
                     libpng-devel \
                     freetype-devel \
                     libxslt-devel \
                     libzip-devel; \
      rm -rf /var/cache/yum

RUN set -ex; \
      curl -o /root/php-7.3.33.tar.gz http://10.67.51.164/php-7.3.33.tar.gz; \
      tar zxvf /root/php-7.3.33.tar.gz; \
      cd php-7.3.33; \
      ./configure \
         --prefix=/usr/local/php7 \
         --enable-mysqlnd \
         --with-mysqli=mysqlnd \
         --with-apxs2 \
         --with-pdo-mysql=mysqlnd \
         --with-curl \
         --with-freetype-dir \
         --with-gd \
         --with-gettext \
         --with-iconv-dir \
         --with-kerberos \
         --with-libdir=lib64 \
         --with-libxml-dir \
         --with-openssl \
         --with-pcre-regex \
         --with-pdo-sqlite \
         --with-pear \
         --with-png-dir \
         --with-jpeg-dir \
         --with-xmlrpc \
         --with-xsl \
         --with-zlib \
         --with-bz2 \
         --with-mhash \
         --enable-bcmath \
         --enable-libxml \
         --enable-inline-optimization \
         --enable-mbregex \
         --enable-mbstring \
         --enable-opcache \
         --enable-pcntl \
         --enable-shmop \
         --enable-soap \
         --enable-sockets \
         --enable-sysvsem \
         --enable-sysvshm \
         --enable-xml; \
      make; \
      make install

RUN set -ex; \
      cp /php-7.3.33/php.ini-development /usr/local/php7/lib/php.ini; \
      echo "export PATH=${PATH}:/usr/local/php7/bin" > /etc/environment; \
      rm -rf /php-7.3.33

RUN sed -ri \
        -e 's!^(\s*CustomLog)\s+\S+!\1 "| /usr/bin/tee /var/log/httpd/access_log"!g' \
        -e 's!^(\s*ErrorLog)\s+\S+!\1  "| /usr/bin/tee /var/log/httpd/error_log"!g' \
        /etc/httpd/conf/httpd.conf 

RUN { \ 
    echo '<FilesMatch \.php$>'; \
    echo '    SetHandler application/x-httpd-php'; \
    echo '</FilesMatch>'; \
    echo 'DirectoryIndex disabled'; \
    echo 'DirectoryIndex index.php index.html'; \
    } | tee /etc/httpd/conf.d/php.conf

STOPSIGNAL SIGWINCH

COPY httpd-foreground /usr/local/bin/

EXPOSE 80
CMD ["httpd-foreground"]
