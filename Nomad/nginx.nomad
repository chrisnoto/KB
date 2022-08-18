job "website" {
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
  group "website" {
    count = 1
    network {
      port "http" { to = 80 }
    }
    restart {
      attempts =2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }
    task "myweb" {
      driver = "docker"
      env {
        TZ = "Asia/Shanghai"
      }
      
      resources {
        cpu = 500
        memory = 1024
      }

      config {
        image = "nginx:20220728"
        ports = [
          "http",
        ]     
      }
      service {
        name = "website"
        tags = ["nginx","website"]
        port = "http"
        check {
          name = "TCP Check"
          type = "tcp"
          port = "http"
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
  }
}
