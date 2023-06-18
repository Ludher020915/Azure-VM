terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.61.0"
    }
  }
}

provider "azurerm" {
  client_id       = "b55d9e8d-8974-42da-9400-132cf792139d"
  client_secret   = "dHm8Q~Exuo_Gy0GsDsGBi_9KWCz6n4A9kT_mEafZ"
  tenant_id       = "3a122ef3-7d7a-4b72-b856-d776793db874"
  subscription_id = "cdd3c02b-47dd-4a05-8064-814133d0de17"
  features {}
}

resource "azurerm_resource_group" "app_grp" {
  name     = var.app_grp
  location = var.loc
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "terraformstore23456"
  resource_group_name      = azurerm_resource_group.app_grp.name
  location                 = azurerm_resource_group.app_grp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Creating vnet
resource "azurerm_network_security_group" "nsg" {
  name                = "app-nsg"
  location            = azurerm_resource_group.app_grp.location
  resource_group_name = azurerm_resource_group.app_grp.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "app-vnet"
  location            = azurerm_resource_group.app_grp.location
  resource_group_name = azurerm_resource_group.app_grp.name
  address_space       = ["10.0.0.0/16"]

    subnet {
  name           = "appsubnet1"
  address_prefix = "10.0.1.0/24"
  }

    subnet {
  name           = "appsubnet2"
  address_prefix = "10.0.2.0/24"
  security_group = azurerm_network_security_group.nsg.id
  }
}



data "azurerm_resource_group" "Test_grp" {
  name = "TestRG"
}


resource "azurerm_storage_account" "stg_app" {
  name                     = "azstg123456"
  resource_group_name      = data.azurerm_resource_group.Test_grp.name
  location                 = data.azurerm_resource_group.Test_grp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}