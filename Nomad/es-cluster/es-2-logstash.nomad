job "es-logstash" {
  datacenters = ["lh"]
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
  group "logstash-1" {
    count = 1
    constraint {
      attribute = "${attr.unique.hostname}"
      value = "xlhceslogstash1"
    }
    volume "logstash_data" {
      type = "host"
      read_only = false
      source = "logstash_data"
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
    task "rundocker" {
      vault {
        policies = ["admin"]
      }
      driver = "docker"
      volume_mount {
        volume = "logstash_data"
        destination = "/usr/share/logstash/data"
        read_only = false
      }
      template {
        data        = <<EOF
           NODE_NAME = {{ env "attr.unique.hostname" }}
        EOF
        destination = "local/customenv"
        env         = true
      }
      template {
        data        = <<EOF
{{ with secret "secret/data/es/logstashconfig" }}
{{ range $key, $value := .Data.data }}
{{ $key }}={{ $value | toJSON }}{{ end }}
{{ end }}
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
          ssl_key => "/usr/share/logstash/data/instance.pkcs8.key"
          ssl_certificate => "/usr/share/logstash/data/instance.crt"
        }
      }
      output {
        elasticsearch {
          hosts => ["https://xlhcesbges01.cesbg.foxconn:9200","https://xlhcesbges02.cesbg.foxconn:9200"]
          ilm_enabled => false
          cacert => "/usr/share/logstash/data/ca.crt"
          ssl_certificate_verification => false
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
{{ with secret "secret/data/es/ca/cert" }}
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
{{ with secret "secret/data/es/instance/pkcs8key" }}
{{- .Data.data.cert -}}
{{ end }}
EOF
        destination = "secrets/instance.pkcs8.key"
        change_mode = "restart"
      }

      resources {
        cpu = 2000
        memory = 12000
      }
      artifact {
        source = "http://10.67.51.164/images/logstash.7.12.0.tar"
        options {
          archive = false
        }
      }
      config {
        image = "logstash:7.12.0"
        load = "logstash.7.12.0.tar"
        dns_servers = ["10.134.240.146","10.134.240.147"]
        ports = [
          "comm",
          "beat"
        ]
        volumes = [
          "./secrets/ca.crt:/usr/share/logstash/data/ca.crt",
          "./secrets/instance.crt:/usr/share/logstash/data/instance.crt",
          "./secrets/instance.pkcs8.key:/usr/share/logstash/data/instance.pkcs8.key",
          "./local/pipeline.conf:/usr/share/logstash/pipeline/logstash.conf"
        ]
      }
      service {
        name = "logstash-1-comm"
        tags = ["logstash","es"]
        port = "comm"
        provider = "nomad"
      }
      service {
        name = "logstash-1-beat"
        tags = ["logstash","es"]
        port = "beat"
        provider = "nomad"
      }
    }
  }
  group "logstash-2" {
    count = 1
    constraint {
      attribute = "${attr.unique.hostname}"
      value = "xlhceslogstash2"
    }
    volume "logstash_data" {
      type = "host"
      read_only = false
      source = "logstash_data"
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
    task "rundocker" {
      vault {
        policies = ["admin"]
      }
      driver = "docker"
      volume_mount {
        volume = "logstash_data"
        destination = "/usr/share/logstash/data"
        read_only = false
      }
      template {
        data        = <<EOF
           NODE_NAME = {{ env "attr.unique.hostname" }}
        EOF
        destination = "local/customenv"
        env         = true
      }
      template {
        data        = <<EOF
{{ with secret "secret/data/es/logstashconfig" }}
{{ range $key, $value := .Data.data }}
{{ $key }}={{ $value | toJSON }}{{ end }}
{{ end }}
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
          ssl_key => "/usr/share/logstash/data/instance.pkcs8.key"
          ssl_certificate => "/usr/share/logstash/data/instance.crt"
        }
      }
      output {
        elasticsearch {
          hosts => ["https://xlhcesbges01.cesbg.foxconn:9200","https://xlhcesbges02.cesbg.foxconn:9200"]
          ilm_enabled => false
          cacert => "/usr/share/logstash/data/ca.crt"
          ssl_certificate_verification => false
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
{{ with secret "secret/data/es/ca/cert" }}
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
{{ with secret "secret/data/es/instance/pkcs8key" }}
{{- .Data.data.cert -}}
{{ end }}
EOF
        destination = "secrets/instance.pkcs8.key"
        change_mode = "restart"
      }

      resources {
        cpu = 2000
        memory = 12000
      }
      artifact {
        source = "http://10.67.51.164/images/logstash.7.12.0.tar"
        options {
          archive = false
        }
      }
      config {
        image = "logstash:7.12.0"
        load = "logstash.7.12.0.tar"
        dns_servers = ["10.134.240.146","10.134.240.147"]
        ports = [
          "comm",
          "beat"
        ]
        volumes = [
          "./secrets/ca.crt:/usr/share/logstash/data/ca.crt",
          "./secrets/instance.crt:/usr/share/logstash/data/instance.crt",
          "./secrets/instance.pkcs8.key:/usr/share/logstash/data/instance.pkcs8.key",
          "./local/pipeline.conf:/usr/share/logstash/pipeline/logstash.conf"
        ]
      }
      service {
        name = "logstash-2-comm"
        tags = ["logstash","es"]
        port = "comm"
        provider = "nomad"
      }
      service {
        name = "logstash-2-beat"
        tags = ["logstash","es"]
        port = "beat"
        provider = "nomad"
      }
    }
  }
}
