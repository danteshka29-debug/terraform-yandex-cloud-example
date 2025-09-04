# main.tf
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.93.0"
    }
  }
}

provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
}

variable "cloud_id" {
  description = "Yandex.Cloud Cloud ID"
  type        = string
}
variable "folder_id" {
  description = "Yandex.Cloud Folder ID"
  type        = string
}
variable "subnet_id" {
  description = "Subnet ID for the VM"
  type        = string
}

data "yandex_compute_image" "ubuntu_image" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "vm-1" {
  name = "my-first-terraform-vm"
  zone = "ru-central1-a" # УБЕДИТЕСЬ, ЧТО ЭТА ЗОНА СОВПАДАЕТ С ЗОНОЙ ВАШЕЙ СЕТИ

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_image.id
    }
  }

  network_interface {
    subnet_id = var.subnet_id
    nat       = true
  }
}