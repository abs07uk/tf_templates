terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.79.0"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = "true"
  subscription_id = "abb7e7fc-9a9f-49e5-a520-ceb3705e78ed"
  tenant_id = "8df4cd79-878d-46b7-ac70-c4785f0c01d5"
  client_id = "ad87be72-f846-4524-821e-76567fa9e081"
  client_secret = "bC38Q~nQgUm6.96ST5~qetWNT.ALOLXnjupQcbQg"
  features {}
}

terraform {
    backend "azurerm" {
        resource_group_name  = "uks-amr-01-rg"
        storage_account_name = "uksamr01str02"
        container_name       = "tfstate"
        key                  = "stgacc.terraform.tfstate"
    }
}

locals {
  resource_group_name = "tf-rg"
  location            = "uksouth"
}

resource "azurerm_resource_group" "tfrg" {
    name = local.resource_group_name
    location = local.location
}
