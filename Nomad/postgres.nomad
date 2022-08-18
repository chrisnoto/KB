job "mydb" {
  datacenters = ["dc1"]
  type = "service"
  update {
    max_parallel =1
    min_healthy_time = "10s"
    healthy_deadline = "3m"
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
  group "mydb" {
    count = 2
    constraint {
      operator = "distinct_hosts"
      value = "true"
    }
    volume "postgres" {
      type = "host"
      read_only = false
      source = "postgres"
    }
    network {
      port "db" { to = 5432 }
      port "http" { static = "9187" }
    }
    restart {
      attempts =2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }
    task "mydb" {
      driver = "docker"
      volume_mount {
        volume = "postgres"
        destination = "/var/lib/postgresql/data/pgdata"
        read_only = false
      }

      env {
        TZ = "Asia/Shanghai"
        POSTGRES_PASSWORD = "Foxconn123"
        PGDATA = "/var/lib/postgresql/data/pgdata"
      }
      
      resources {
        cpu = 600
        memory = 1024
      }

      config {
        image = "postgres:12"
        dns_servers = ["10.67.50.63","10.67.50.88"]
        ports = [
          "db",
        ]     
      }
      service {
        name = "zdb"
        tags = ["zabbix","postgres"]
        port = "db"
        check {
          name = "TCP Check"
          type = "tcp"
          port = "db"
          interval = "60s"
          timeout = "5s"
          check_restart {
            limit = 3 
            grace = "90s"
            ignore_warnings = false
          }
        }
      }   
    }
    task "postgres-exporter" {
      driver = "docker"
      env {
        DATA_SOURCE_URI = "${NOMAD_HOST_ADDR_db}/postgres?sslmode=disable"
        DATA_SOURCE_USER = "postgres"
        DATA_SOURCE_PASS = "Foxconn123"
      }

      config {
        image = "wrouesnel/postgres_exporter:20220817"
        volumes = [
          "/proc:/host/proc",
          "/sys:/host/sys",
          "/:/rootfs"
        ]
        ports = [
          "http",
        ]
      }

      service {
        name = "postgres-exporter"
        address_mode = "driver"
        tags = [
          "metrics"
        ]
        port = "http"
        check {
          type = "http"
          path = "/metrics/"
          interval = "10s"
          timeout = "2s"
        }
      }

      resources {
        cpu    = 50
        memory = 100
      }
    }
  }
}
