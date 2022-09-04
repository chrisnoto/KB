job "es-kibana" {
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
  group "kibana" {
    count = 1
    constraint {
      attribute = "${attr.unique.hostname}"
      value = "xlhceslogstash1"
    }
    network {
      port "http" { static = "5601" }
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
      template {
        data        = <<EOF
           SERVER_NAME = {{ env "attr.unique.hostname" }}
           SERVER_HOST = "0.0.0.0"
           ELASTICSEARCH_USERNAME = "kibana_system"
           ELASTICSEARCH_PASSWORD = "vSTJ456"
           SERVER_SSL_ENABLED = false
           ELASTICSEARCH_HOSTS = "[\"https://xlhcesbges01.cesbg.foxconn:9200\",\"https://xlhcesbges02.cesbg.foxconn:9200\"]"
           ELASTICSEARCH_SSL_CERTIFICATEAUTHORITEIS = "/usr/share/kibana/ca.cert"
           ELASTICSEARCH_SSL_VERIFICATIONMODE = "none"
        EOF
        destination = "local/customenv"
        env         = true
      }

      template {
        data        = <<EOF
{{ with secret "secret/data/es/ca/cert" }}
{{- .Data.data.cert -}}
{{ end }}
EOF
        destination = "secrets/ca.crt"
      }

      resources {
        cpu = 200
        memory = 400
      }
      artifact {
        source = "http://10.67.51.164/images/kibana.7.12.0.tar"
        options {
          archive = false
        }
      }
      config {
        image = "kibana:7.12.0"
        load = "kibana.7.12.0.tar"
        dns_servers = ["10.134.241.70","10.134.240.147"]
        ports = [
          "http"
        ]
        volumes = [
          "./secrets/ca.crt:/usr/share/kibana/ca.crt"
        ]
      }
      service {
        name = "kibana-http"
        tags = ["kibana","es"]
        port = "http"
        provider = "nomad"
      }
    }
  }
}
