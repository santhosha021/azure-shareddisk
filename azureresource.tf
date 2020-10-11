provider "azurerm" {
  version = ">2.0.0"
  features {}
  subscription_id = "dead8329-b12b-4816-8b97-943531d50a18"

}
#create resource group
resource "azurerm_resource_group" "rg" {
  name     = "Azdemo-rg01"
  location = "Australia East"

}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "terraform" {
  name                = "demo-network"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.10.0.0/24"]
}

resource "azurerm_subnet" "app-subnet" {
  name                 = "appsubnet01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.terraform.name
  address_prefix       = "10.10.0.0/25"
}

# Create a virtual Machine Nic in Australia east region 
resource "azurerm_network_interface" "auenic01" {
  name                = "auevm-nic01"
  location            = "australiaeast"
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "aueinternal"
    subnet_id                     = azurerm_subnet.app-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
# Create a virtual Machine in Australia east region 
resource "azurerm_windows_virtual_machine" "ausevm" {
  name                = "auedemo-vm01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "australiaeast"
  size                = "Standard_ds2_v2"
  admin_username      = "kloudadmin"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.auenic01.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}

# Create a second virtual Machine Nic in Australia east region 
resource "azurerm_network_interface" "auenic02" {
  name                = "auevm-nic02"
  location            = "australiaeast"
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "aueinternal02"
    subnet_id                     = azurerm_subnet.app-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
# Create a second virtual Machine in Australia east region 
resource "azurerm_windows_virtual_machine" "ausevm02" {
  name                = "auedemo-vm02"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "australiaeast"
  size                = "Standard_ds2_v2"
  admin_username      = "kloudadmin"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.auenic02.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
