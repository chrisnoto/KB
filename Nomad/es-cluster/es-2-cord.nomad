job "es-cord" {
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
  group "cord-1" {
    count = 1
    constraint {
      attribute = "${attr.unique.hostname}"
      value = "xlhcesbges01"
    }
    volume "es_data" {
      type = "host"
      read_only = false
      source = "es_data"
    }
    network {
      port "transport" { static = "9300" }
      port "http" { static = "9200" }
    }
    restart {
      attempts =2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }
    task "sysctl" {
      lifecycle {
        hook = "prestart"
        sidecar = false
      }
      template {
        data    = <<EOF
echo "vm.max_map_count = 655365" >> /etc/sysctl.d/99-sysctl.conf
sysctl -p /etc/sysctl.d/99-sysctl.conf
EOF
        destination = "local/prestart.sh"
      }
      driver = "raw_exec"
      config {
        command = "/usr/bin/bash"
        args = ["local/prestart.sh"]
      }
    }
    task "rundocker" {
      vault {
        policies = ["admin"]
      }
      driver = "docker"
      volume_mount {
        volume = "es_data"
        destination = "/usr/share/elasticsearch/data"
        read_only = false
      }
      template {
        data        = <<EOF
           node.name = {{ env "attr.unique.hostname" }}
           network.publish_host = {{ env "NOMAD_IP_http" }}
        EOF
        destination = "local/customenv"
        env         = true
      }
      template {
        data        = <<EOF
{{ with secret "secret/data/es/cordconfig" }}
{{ range $key, $value := .Data.data }}
{{ $key }}={{ $value | toJSON }}{{ end }}
{{ end }}
        EOF
        destination = "local/env"
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
        destination = "secrets/instance.key"
        change_mode = "restart"
      }

      resources {
        cpu = 2000
        memory = 12000
      }
      artifact {
        source = "http://10.67.51.164/images/es7.12.0.tar"
        options {
          archive = false
        }
      }
      config {
        image = "elasticsearch:7.12.0"
        load = "es7.12.0.tar"
        dns_servers = ["10.134.240.146","10.134.240.147"]
        ports = [
          "transport",
          "http"
        ]
        ulimit {
          memlock = "-1:-1"
        }
        volumes = [
          "./secrets/ca.crt:/usr/share/elasticsearch/data/ca.crt",
          "./secrets/instance.crt:/usr/share/elasticsearch/data/instance.crt",
          "./secrets/instance.key:/usr/share/elasticsearch/data/instance.key"
        ]
      }
      service {
        name = "es-cord-1-transport"
        tags = ["cord","es"]
        port = "transport"
        provider = "nomad"
      }
      service {
        name = "es-cord-1-http"
        tags = ["cord","es"]
        port = "http"
        provider = "nomad"
      }
    }
  }
  group "cord-2" {
    count = 1
    constraint {
      attribute = "${attr.unique.hostname}"
      value = "xlhcesbges02"
    }
    volume "es_data" {
      type = "host"
      read_only = false
      source = "es_data"
    }
    network {
      port "transport" { static = "9300" }
      port "http" { static = "9200" }
    }
    restart {
      attempts =2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }
    task "sysctl" {
      lifecycle {
        hook = "prestart"
        sidecar = false
      }
      template {
        data    = <<EOF
echo "vm.max_map_count = 655365" >> /etc/sysctl.d/99-sysctl.conf
sysctl -p /etc/sysctl.d/99-sysctl.conf
EOF
        destination = "local/prestart.sh"
      }
      driver = "raw_exec"
      config {
        command = "/usr/bin/bash"
        args = ["local/prestart.sh"]
      }
    }
    task "rundocker" {
      vault {
        policies = ["admin"]
      }
      driver = "docker"
      volume_mount {
        volume = "es_data"
        destination = "/usr/share/elasticsearch/data"
        read_only = false
      }
      template {
        data        = <<EOF
           node.name = {{ env "attr.unique.hostname" }}
           network.publish_host = {{ env "NOMAD_IP_http" }}
        EOF
        destination = "local/customenv"
        env         = true
      }

      template {
        data        = <<EOF
{{ with secret "secret/data/es/cordconfig" }}
{{ range $key, $value := .Data.data }}
{{ $key }}={{ $value | toJSON }}{{ end }}
{{ end }}
        EOF
        destination = "local/env"
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
        destination = "secrets/instance.key"
        change_mode = "restart"
      }

      resources {
        cpu = 2000
        memory = 12000
      }
      artifact {
        source = "http://10.67.51.164/images/es7.12.0.tar"
        options {
          archive = false
        }
      }
      config {
        image = "elasticsearch:7.12.0"
        load = "es7.12.0.tar"
        dns_servers = ["10.134.240.146","10.134.240.147"]
        ports = [
          "transport",
          "http"
        ]
        ulimit {
          memlock = "-1:-1"
        }
        volumes = [
          "./secrets/ca.crt:/usr/share/elasticsearch/data/ca.crt",
          "./secrets/instance.crt:/usr/share/elasticsearch/data/instance.crt",
          "./secrets/instance.key:/usr/share/elasticsearch/data/instance.key"
        ]
      }
      service {
        name = "es-cord-2-transport"
        tags = ["cord","es"]
        port = "transport"
        provider = "nomad"
      }
      service {
        name = "es-cord-2-http"
        tags = ["cord","es"]
        port = "http"
        provider = "nomad"
      }
    }
  }
}
