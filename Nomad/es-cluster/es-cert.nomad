job "escert" {
  datacenters = ["lh"]
  type = "batch"

  group "cert" {
    constraint {
      attribute = "${attr.unique.hostname}"
      value = "xlhcesbges01"
    }
    volume "es_data" {
      type = "host"
      read_only = false
      source = "es_data"
    }
    task "cert-util" {
      driver = "docker"
      volume_mount {
        volume = "es_data"
        destination = "/usr/share/elasticsearch/data"
        read_only = false
      }

      config {
        image = "elasticsearch:7.12.0"
        command = "/usr/share/elasticsearch/bin/elasticsearch-certutil"
        args    = ["cert","--keep-ca-key","--pem","--out","/usr/share/elasticsearch/data/escerts.zip"]
      }
    }
    task "put cert to vault" {
      lifecycle {
        hook = "poststop"
        sidecar = false
      }
      template {
        data    = <<EOF
unzip -n /data/escerts.zip -d /data
openssl pkcs8 -in /data/instance/instance.key -topk8 -nocrypt -out /data/instance/instance.pkcs8.key
chown -R 1000:1000 /data
export VAULT_ADDR='http://10.134.241.90:8200'
export VAULT_TOKEN='hvs.TT5BgZoCQ54bMqWfz7DhX20g'
vault kv put secret/es/ca/cert cert=@/data/ca/ca.crt
vault kv put secret/es/instance/cert cert=@/data/instance/instance.crt
vault kv put secret/es/instance/key cert=@/data/instance/instance.key
vault kv put secret/es/instance/pkcs8key cert=@/data/instance/instance.pkcs8.key
EOF
        destination = "local/putcerts.sh"
      }
      driver = "raw_exec"
      config {
        command = "/usr/bin/bash"
        args = ["local/putcerts.sh"]
      }
    }
  }
} 

