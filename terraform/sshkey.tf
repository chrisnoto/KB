resource "null_resource" "ansible" {
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook jobs/add_ssh_key.yaml"
  }
}

