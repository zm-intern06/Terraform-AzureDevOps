terraform {
  required_providers {
    azurerm = {
      # Specify what version of the provider we are going to utilise
      source = "hashicorp/azurerm"
      version = ">= 2.0"
    }
  }
}
provider "azurerm" {
  features {
      key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

backend "azurerm" {
    resource_group_name   = "terraform001"
    storage_account_name  = "statetf01fadv"
    container_name        = "tstate"
    key                   = "+qwqpk6KiHS5sj+Y4Ys+Qmu+Q+WJY9dJ9pyijLQGmfDlwWcXBi8osXnBW00neUIdimBt2jFMV8bzMKObOnYh+TQ=="
}


data "azurerm_client_config" "current" {}

# Create our Virtual Network - Jonnychipz-VNET
resource "azurerm_virtual_network" "vnet" {
  name                = "tftestpzvnet"
  address_space       = ["10.0.0.0/16"]
  location            = "uksouth"
  resource_group_name = "terraform001"
}
# Create our Subnet to hold our VM - Virtual Machines
resource "azurerm_subnet" "sn" {
  name                 = "VM"
  resource_group_name  = "terraform001"
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = ["10.0.1.0/24"]
}
# Create our Azure Storage Account 
resource "azurerm_storage_account" "terraformsac" {
  name                     = "terraformsac"
  location            = "uksouth"
  resource_group_name = "terraform001"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = {
    environment = "jonnychipzrox"
  }
}
# Create our vNIC for our VM and assign it to our Virtual Machines Subnet
resource "azurerm_network_interface" "vmnic" {
  name                = "terraformtestvm01nic"
  location            = "uksouth"
  resource_group_name = "terraform001"
  
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sn.id
    private_ip_address_allocation = "Dynamic"
  }
}
# Create our Virtual Machine - Jonnychipz-VM01
resource "azurerm_virtual_machine" "firsttestvm01" {
  name                  = "firsttestvm01"
  location            = "uksouth"
  resource_group_name = "terraform001"
  network_interface_ids = [azurerm_network_interface.vmnic.id]
  vm_size               = "Standard_B2s"
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-Server-Core-smalldisk"
    version   = "latest"
  }
  storage_os_disk {
    name              = "tftestftvm01os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name      = "firsttestvm01"
    admin_username     = "Azure-dev"
    admin_password     = "@ZyC%j7G"
  }
  os_profile_windows_config {
  }
}