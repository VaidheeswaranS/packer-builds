packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "2.1.1"
    }
  }
}

# Authentication

variable "use_azure_cli_auth" {
  type    = bool
  default = true
}

variable "shared_image_gallery_subscription" {
  type    = string
  default = null
}

variable "shared_image_gallery_rg" {
  type    = string
  default = "vaidhee-shared-rg"
}

variable "shared_image_gallery" {
  type    = string
  default = "vaidhee_shared_rg_gallery"
}

variable "shared_image" {
  type    = string
  default = "vaidhee-shared-generalized-windows2022"
}

variable "shared_image_version" {
  type    = string
  default = "1.0.0"
}

variable "baseline_image_gallery_subscription" {
  type    = string
  default = ""
}

variable "baseline_shared_gallery_name" {
  type    = string
  default = "vaidhee_shared_rg_gallery"
}

variable "baseline_shared_image_name" {
  type    = string
  default = "vaidhee-shared-baseline-windows2022"
}

variable "os_type" {
  type    = string
  default = "Windows"
}

variable "winrm_timeout" {
  type    = string
  default = "3h"
}

variable "location" {
  type    = string
  default = "East US"
}

variable "vm_size" {
  type    = string
  default = "Standard_DS2_v2"
}

variable "encoded_credentials" {
  type    = string
  default = ""
}

variable "aqua_token" {
  type    = string
  default = ""
}

source "azure-arm" "image" {
  use_azure_cli_auth = var.use_azure_cli_auth
  location           = var.location
  vm_size            = var.vm_size
  os_type            = var.os_type

  managed_image_name                = "${var.shared_image}-${var.shared_image_version}"
  managed_image_resource_group_name = var.shared_image_gallery_rg

  shared_image_gallery {
    subscription   = var.baseline_image_gallery_subscription
    resource_group = var.shared_image_gallery_rg
    gallery_name   = var.baseline_shared_gallery_name
    image_name     = var.baseline_shared_image_name
    image_version  = "latest"
  }

  shared_image_gallery_destination {
    subscription        = var.shared_image_gallery_subscription
    resource_group      = var.shared_image_gallery_rg
    gallery_name        = var.shared_image_gallery
    image_name          = var.shared_image
    image_version       = var.shared_image_version
    replication_regions = [var.location]
  }

  communicator   = "winrm"
  winrm_use_ssl  = true
  winrm_insecure = true
  winrm_timeout  = var.winrm_timeout
  winrm_username = "packer"
}

build {
  sources = ["azure-arm.image"]

  provisioner "powershell" {
    script = "./scripts/consolidated-scripts.ps1"
  }

  provisioner "powershell" {
    script = "./scripts/sysprep.ps1"
  }
}