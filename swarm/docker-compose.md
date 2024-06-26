---
title: docker-compose
category: Devops
layout: 2017/sheet
prism_languages: [yaml]
weight: -1
updated: 2018-03-17
---

### Basic example

```yaml
# docker-compose.yml
version: '2'

services:
  web:
    build: .
    # build from Dockerfile
    context: ./Path
    dockerfile: Dockerfile
    ports:
     - "5000:5000"
    volumes:
     - .:/code
  redis:
    image: redis
```

## Reference
{: .-one-column}

```yaml
web:
  # build from Dockerfile
  build: .

  # build from image
  image: ubuntu
  image: ubuntu:14.04
  image: tutum/influxdb
  image: example-registry:4000/postgresql
  image: a4bc65fd

  ports:
    - "3000"
    - "8000:80"  # guest:host

  # command to execute
  command: bundle exec thin -p 3000
  command: [bundle, exec, thin, -p, 3000]

  # override the entrypoint
  entrypoint: /app/start.sh
  entrypoint: [php, -d, vendor/bin/phpunit]

  # environment vars
  environment:
    RACK_ENV: development
  environment:
    - RACK_ENV=development

  # environment vars from file
  env_file: .env
  env_file: [.env, .development.env]

  # expose ports to linked services (not to host)
  expose: ["3000"]

  # make this service extend another
  extends:
    file: common.yml  # optional
    service: webapp

  # makes the `db` service available as the hostname `database`
  # (implies depends_on)
  links:
    - db:database
    - redis

  # make sure `db` is alive before starting
  depends_on:
    - db

  volumes:
    - /var/lib/mysql
    - ./_data:/var/lib/mysql
```

## Advanced features
{: .-three-column}

### Labels

```yaml
services:
  web:
    labels:
      com.example.description: "Accounting web app"
```

### DNS servers

```yaml
services:
  web:
    dns: 8.8.8.8
    dns:
      - 8.8.8.8
      - 8.8.4.4
```

### Devices

```yaml
services:
  web:
    devices:
    - "/dev/ttyUSB0:/dev/ttyUSB0"
```

### External links

```yaml
services:
  web:
    external_links:
      - redis_1
      - project_db_1:mysql
```

### Hosts

```yaml
services:
  web:
    extra_hosts:
      - "somehost:192.168.1.100"
```

### another example
```yaml
version: '3'

services:
  db:
    image: mysql:5.6
    expose:
      - 3306
    volumes:
      - data:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=Foxconn123
  web:
    build:
      context: ./web
      args:
        http_proxy: "http://10.62.32.27:33128"
    image: gatekeeper_web:1.0
    command: python2 manage.py runserver 0.0.0.0:8000
    ports:
      - "8000:8000"
    depends_on:
      - db
volumes:
  data: {}
```
services: 
    ngnix-service:
        image: my-nginx-image
        build: 
            context: .
            args: # Environment variables available at build-time
                - http_proxy
                - https_proxy
                - no_proxy
        environment: # Environment variables available at container run-time
            - https_proxy
            - http_proxy
            - no_proxy
        volumes: 