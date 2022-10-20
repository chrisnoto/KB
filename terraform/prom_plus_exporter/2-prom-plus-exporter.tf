variable "vm_count" {
  type        = number
  description = "number of vm"
  default     = 2
}

data "template_file" "user_data" {
  count    = var.vm_count
  template = "${file("${path.module}/files/user_data.cloud_config")}"
  vars = {
    pubkey   = file(pathexpand("~/.ssh/id_rsa.pub"))
    hostname = "dc${count.index}"
    domain   = "cesbg.foxconn"
  }
}

# create a local copy of the file,to transfer to Proxmox 
resource "local_file" "cloud_init_user_data" {
  count        = var.vm_count
  content      = data.template_file.user_data[count.index].rendered
  filename     = "${path.module}/files/user_data_${count.index}.cfg"
}

# transfer the local copy to proxmox host
resource "null_resource" "cloud_init_user_data_files" {
  count        = var.vm_count
  connection {
    type       = "ssh"
    user       = "root"
    host       = "10.67.50.162"
    password   = "vSTJ456789"
  }

  provisioner "file" {
    source = local_file.cloud_init_user_data[count.index].filename
    destination = "/var/lib/vz/snippets/dc_user_data-${count.index}.yml"
  }
}

resource "proxmox_vm_qemu" "dc" {
  depends_on = [
    null_resource.cloud_init_user_data_files
  ]

  count        = var.vm_count
  name         = "dc${count.index}"
  target_node  = "pve1"
  pool         = "chensen"
  clone        = "centos7.9-cloudinit"
  agent        = 1
  full_clone   = false
  cores        = 4
  sockets      = 2
  boot         = "order=scsi0;ide2"
  kvm          = true
  memory       = "16384"
  disk {
    storage    = "prod"
    size       = "60G"
    type       = "scsi"
  }
  disk {
    storage    = "prod"
    size       = "100G"
    type       = "scsi"
  }
  network {
    bridge     = "vmbr0"
    firewall   = false
    link_down  = false
    model      = "virtio"
  }
  ipconfig0= "ip=10.67.50.4${count.index + 1}/23,gw=10.67.50.1"
  cicustom = "user=local:snippets/dc_user_data-${count.index}.yml"
  ciuser   = "centos"
}

output "vm_ip_address" {
  description = "The IP addr of VM"
  value = proxmox_vm_qemu.dc.*.default_ipv4_address
}

resource "local_file" "inventory" {
  depends_on = [
    proxmox_vm_qemu.dc
  ]

  filename = "files/hosts"
  content = <<EOF
  [app]
  ${proxmox_vm_qemu.dc[0].default_ipv4_address}
  ${proxmox_vm_qemu.dc[1].default_ipv4_address}
  EOF
}

resource "null_resource" "ansible-playbook" {
  depends_on = [
    local_file.inventory
  ]

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i files/hosts files/prom.yaml -e 'ansible_ssh_pass=Foxconn123'"
  }
}
