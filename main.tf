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
# Create our Resource Group - Jonnychipz-RG


# Create our Virtual Machine - Jonnychipz-VM01
resource "azurerm_virtual_machine" "jonnychipzvm01" {
  name                  = "jonnychipzvm01"
  location              = "uksouth"
  resource_group_name   = "terraform001"
  network_interface_ids = [azurerm_network_interface.vmnic.id]
  vm_size               = "Standard_B2s"
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-Server-Core-smalldisk"
    version   = "latest"
  }
  storage_os_disk {
    name              = "jonnychipzvm01os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name      = "jonnychipzvm01"
    admin_username     = "jonnychipz"
    admin_password     = "Password123$"
  }
  os_profile_windows_config {
  }
}

 