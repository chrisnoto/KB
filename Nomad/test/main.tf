terraform {
  backend "consul" {
    address = "consul.service.consul:8500"
    scheme  = "http"
    path    = "terraform_state/nomad"
  }
}



		# data "terraform_remote_state" "consul" {
		#   backend = "consul"
		#   config = {
		#     path = "terraform_state/nomad"
		#   }
		# }


provider "nomad" {
  address = "http://nomad.service.consul:4646/"
}
