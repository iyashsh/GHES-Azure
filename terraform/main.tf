provider "azurerm" {
  features {}
  # This block configures the AzureRM provider, which is required to interact with Azure resources.
}

resource "azurerm_resource_group" "ghes_rg" {
  name     = "ghes-resource-group"  # Name of the resource group that will contain all your Azure resources.
  location = "West Europe"          # Azure region where the resource group will be created (e.g., West Europe).
}

resource "azurerm_virtual_network" "vnet" {
  name                = "ghes-vnet"                               # Name of the virtual network (VNet) where your VMs will be placed.
  address_space       = ["10.0.0.0/16"]                           # IP range (CIDR block) for the VNet, which defines the internal network space.
  location            = azurerm_resource_group.ghes_rg.location   # Location for the VNet (same as resource group location).
  resource_group_name = azurerm_resource_group.ghes_rg.name       # Associates the VNet with the resource group created above.
}

resource "azurerm_subnet" "subnet" {
  name                 = "ghes-subnet"                            # Name of the subnet within the VNet where the VMs will be located.
  resource_group_name  = azurerm_resource_group.ghes_rg.name      # Associates the subnet with the resource group.
  virtual_network_name = azurerm_virtual_network.vnet.name        # Associates the subnet with the virtual network created above.
  address_prefixes     = ["10.0.1.0/24"]                          # CIDR block defining the address range for the subnet.
}

resource "azurerm_virtual_machine" "primary_vm" {
  name                  = "ghes-primary-vm"                           # Name of the primary virtual machine (VM) that will run GHES.
  location              = azurerm_resource_group.ghes_rg.location     # Specifies the region where the VM will be deployed.
  resource_group_name   = azurerm_resource_group.ghes_rg.name         # Associates the VM with the resource group created earlier.
  network_interface_ids = [azurerm_network_interface.primary_nic.id]  # References the network interface (NIC) for the VM.

  vm_size               = "Standard_D4as_v5"              # Specifies the size of the VM (4 vCPUs, 32GB memory, etc.).

  storage_image_reference {                               # Specifies the Azure Marketplace image to use for the VM.
    publisher = "GitHub"                                  # The publisher of the GHES image.
    offer     = "GitHub-Enterprise"                       # The offer name (in this case, GitHub Enterprise).
    sku       = "GitHub-Enterprise-Server"                # The SKU for GHES.
    version   = "latest"                                  # The latest version of the GHES image will be used.
  }

  storage_os_disk {                                       # Configuration for the operating system disk of the VM.
    name              = "primary_os_disk"                 # Name of the OS disk.
    caching           = "ReadWrite"                       # Disk caching mode.
    create_option     = "FromImage"                       # The disk is created from the specified image.
    managed_disk_type = "Standard_LRS"                    # Managed disk type (Standard locally redundant storage).
  }

  os_profile {                                            # Defines the operating system settings for the VM.
    computer_name  = "ghes-primary"                       # Hostname for the VM.
    admin_username = "azureuser"                          # The admin username for the VM.
    admin_password = "Password123!"                       # Password for the admin user.
  }

  os_profile_linux_config {                               # Additional Linux OS configuration.
    disable_password_authentication = false               # Password authentication is enabled.
  }

  tags = {                                                # Tags can help with resource management and billing.
    environment = "production"                            # Tag for identifying the environment.
  }
}

resource "azurerm_virtual_machine" "replica_vm" {
  name                  = "ghes-replica-vm"                           # Name of the replica virtual machine for GHES.
  location              = "Germany West Central"                      # Region where the replica VM will be deployed.
  resource_group_name   = azurerm_resource_group.ghes_rg.name         # Associates the replica VM with the same resource group.
  network_interface_ids = [azurerm_network_interface.replica_nic.id]  # References the network interface for the replica VM.

  vm_size               = "Standard_D4as_v5"              # Specifies the size of the replica VM (same as primary).

  storage_image_reference {                               # Specifies the GHES image from the Azure Marketplace.
    publisher = "GitHub"                                  # The publisher of the GHES image.
    offer     = "GitHub-Enterprise"                       # The offer name (in this case, GitHub Enterprise).
    sku       = "GitHub-Enterprise-Server"                # The SKU for GHES.
    version   = "latest"                                  # The latest version of the GHES image will be used.
  }

  storage_os_disk {                                       # Configuration for the replica VM's OS disk.
    name              = "replica_os_disk"                 # Name of the OS disk for the replica VM.
    caching           = "ReadWrite"                       # Disk caching mode.
    create_option     = "FromImage"                       # The disk is created from the specified image.
    managed_disk_type = "Standard_LRS"                    # Managed disk type (Standard locally redundant storage).
  }

  os_profile {                                            # OS profile for the replica VM.
    computer_name  = "ghes-replica"                       # Hostname for the replica VM.
    admin_username = "azureuser"                          # Admin username.
    admin_password = "Password123!"                       # Password for the admin user.
  }

  os_profile_linux_config {                               # Additional Linux OS configuration.
    disable_password_authentication = false               # Password authentication is enabled.
  }

  tags = {                                                # Tags for the replica VM.
    environment = "replica"                               # Identifies this VM as the replica in the environment.
  }
}
