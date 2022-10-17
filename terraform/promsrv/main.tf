terraform {
  required_version = ">= 1.1.0"
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 2.9.5"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure = true
  pm_api_url      = "https://10.67.50.162:8006/api2/json"
  pm_user         = "root@pam"
  pm_password     = "vSTJ456789"
  pm_debug        = true
}
