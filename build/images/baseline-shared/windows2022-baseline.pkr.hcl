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
  default = "vaidhee-shared-baseline-windows2022"
}

variable "shared_image_version" {
  type    = string
  default = "1.0.0"
}

variable "os_type" {
  type    = string
  default = "Windows"
}

variable "image_publisher" {
  type    = string
  default = "MicrosoftWindowsServer"
}

variable "image_offer" {
  type    = string
  default = "WindowsServer"
}

variable "image_sku" {
  type    = string
  default = "2022-datacenter-g2"
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

  # TODO: Replace with baseline image
  os_type         = var.os_type
  image_publisher = var.image_publisher
  image_offer     = var.image_offer
  image_sku       = var.image_sku

  managed_image_name                = "${var.shared_image}-${var.shared_image_version}"
  managed_image_resource_group_name = var.shared_image_gallery_rg

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
    environment_vars = ["EncodedCredentials=${var.encoded_credentials}",
                        "AquaToken=${var.aqua_token}"]
    script = "./scripts/baseline-script.ps1"
  }

  provisioner "powershell" {
    script = "./scripts/sysprep.ps1"
  }
}