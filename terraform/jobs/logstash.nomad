job "es" {
  datacenters = ["dc1"]
  type = "service"
  update {
    max_parallel =1
    min_healthy_time = "10s"
    healthy_deadline = "5m"
    progress_deadline = "10m"
    auto_revert = false
    canary = 0
  }
  migrate {
    max_parallel = 1
    health_check = "checks"
    min_healthy_time = "10s"
    healthy_deadline = "5m"
  }
  group "logstash" {
    count = 1
    constraint {
      operator = "distinct_hosts"
      value = "true"
    }
    volume "logstash" {
      type = "host"
      read_only = false
      source = "logstash"
    }
    network {
      port "comm" { static = "9600" }
      port "beat" { static = "5044" }
    }
    restart {
      attempts =2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }
    task "build" {
      driver = "docker"
      volume_mount {
        volume = "logstash"
        destination = "/usr/share/logstash/data"
        read_only = false
      }

      template {
        data        = <<EOF
          LS_JAVA_OPTS = "-Xms2g -Xmx2g"
          NODE_NAME = "xtjcesbglogstash99.cesbg.foxconn"
          PATH_CONFIG = "/usr/share/logstash/pipeline/logstash.conf"
          CONFIG_SUPPORT_ESCAPES = true
          PIPELINE_ORDERED = "auto"
          PIPELINE_BATCH_SIZE = 2000
          PIPELINE_BATCH_DELAY = 10
          CONFIG_RELOAD_AUTOMATICS = true
          HTTP_HOST = "0.0.0.0"
          HTTP_PORT = 9600
          QUEUE_TYPE = "persisted"
          QUEUE_PAGE_CAPACITY = "128mb"
          XPACK_MONITORING_ENABLED = true
          XPACK_MONITORING_ELASTICSEARCH_USERNAME = "logstash_system"
          XPACK_MONITORING_ELASTICSEARCH_PASSWORD = "vSTJ456"
          XPACK_MONITORING_ELASTICSEARCH_HOSTS = "['https://xtjcesbges04.cesbg.foxconn:9200']"
          XPACK_MONITORING_ELASTICSEARCH_SSL_CERTIFICATE_AUTHORITY = "/tmp/ca.crt"
        EOF
        destination = "local/env"
        env         = true
      }
      template {
        data        = <<EOF
      input {
        beats {
          port => 5044
          ssl => true
          ssl_key => "/tmp/instance.pkcs8.key"
          ssl_certificate => "/tmp/instance.crt"
        }
      }
      output {
        elasticsearch {
          hosts => ["https://xtjcesbges04.cesbg.foxconn:9200","https://xtjcesbges05.cesbg.foxconn:9200"]
          ilm_enabled => false
          cacert => "/tmp/ca.crt"
          user => "logstash_writer"
          password => "vSTJ456"
          index => "%%{[@metadata][beat]}-%%{[@metadata][version]}-%%{+YYYY.MM.dd}"
        }
      }
      EOF
        destination = "local/pipeline.conf"
      }

      template {
        data        = <<EOF
{{ with secret "secret/data/es/ca/cacert" }}
{{- .Data.data.cert -}}
{{ end }}
EOF
        destination = "secrets/ca.crt"
      }
      template {
        data        = <<EOF
{{ with secret "secret/data/es/instance/cert" }}
{{- .Data.data.cert -}}
{{ end }}
EOF
        destination = "secrets/instance.crt"
        change_mode = "restart"
      }
      template {
        data        = <<EOF
{{ with secret "secret/data/es/instance/key" }}
{{- .Data.data.cert -}}
{{ end }}
EOF
        destination = "secrets/instance.pkcs8.key"
        change_mode = "restart"
      }
      
      resources {
        cpu = 2000
        memory = 4096
      }

      config {
        image = "logstash:7.12.0"
        dns_servers = ["10.66.14.206","10.67.50.88"]
        ports = [
          "comm",
          "beat"
        ]
        volumes = [
          "./secrets/ca.crt:/tmp/ca.crt",
          "./secrets/instance.crt:/tmp/instance.crt",
          "./secrets/instance.pkcs8.key:/tmp/instance.pkcs8.key",
          "./local/pipeline.conf:/usr/share/logstash/pipeline/logstash.conf"
        ]
      }
      service {
        name = "logstash"
        tags = ["logstash","es"]
        port = "comm"
        provider = "nomad"
      }
    }
  }
}

