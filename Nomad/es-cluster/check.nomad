job "vault" {
  datacenters = ["lh"]
  type = "batch"

  group "demo" {
    constraint {
      attribute = "${attr.unique.hostname}"
      value = "xlhcesbges01"
    }
    task "task" {
      vault {
        policies = ["admin"]
      }

      driver = "raw_exec"
      config {
        command = "env"
      }
      template {
        data        = <<EOH
{{ with secret "secret/data/es/masterconfig" }}
{{ range $key, $value := .Data.data }}
{{ $key }}={{ $value | toJSON }}{{ end }}
{{ end }}
EOH
        destination = "secrets/esmaster.env"
        env = true
      }
    }
  }
}

