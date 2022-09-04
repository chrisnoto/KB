job "vault-cert" {
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
        command = "/usr/bin/cat"
        args    = ["-n","secrets/ca.crt"]
      }
      template {
        data        = <<EOH
{{ with secret "secret/data/es/ca/cert" }}
{{- .Data.data.cert -}}
{{ end }}
EOH
        destination = "secrets/ca.crt"
      }
    }
  }
}

