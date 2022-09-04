resource "nomad_job" "logstash" {
  jobspec = file("${path.module}/jobs/logstash.nomad")
  detach  = false
}
