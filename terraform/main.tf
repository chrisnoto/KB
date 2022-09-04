terraform {
  backend "consul" {
    address = "10.67.36.58:8500"
    scheme  = "http"
    path    = "terraform/state"
    lock    = true
  }
}



                # data "terraform_remote_state" "consul" {
                #   backend = "consul"
                #   config = {
                #     path = "terraform_state/nomad"
                #   }
                # }


provider "nomad" {
  address = "http://10.67.36.58:4646/"
}

