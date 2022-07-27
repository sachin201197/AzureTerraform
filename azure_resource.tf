resource "azurerm_resource_group" "RG1" {
  name     = "TRG1"
  location = "West US 3"
}
output "resourceId" {
  value = azurerm_resource_group.RG1
}

resource "azurerm_virtual_network" "Vnet1" {
  name                = "VirtualNetwork1"
  resource_group_name = azurerm_resource_group.RG1.name
  location            = azurerm_resource_group.RG1.location
  address_space       = ["${var.VN1ip}"]
}
output "vNet" {
  value = azurerm_virtual_network.Vnet1

}
resource "azurerm_subnet" "VSN1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.RG1.name
  virtual_network_name = azurerm_virtual_network.Vnet1.name
  address_prefixes     = ["${var.subnetIP}"]
}

resource "azurerm_public_ip" "example" {
  name                = "acceptanceTestPublicIp1"
  resource_group_name = azurerm_resource_group.RG1.name
  location            = azurerm_resource_group.RG1.location
  allocation_method   = "Dynamic"
}
output "publicIP" {
  value = azurerm_public_ip.example
}
resource "azurerm_network_interface" "main" {
  name                = "NetworkInterface"
  location            = azurerm_resource_group.RG1.location
  resource_group_name = azurerm_resource_group.RG1.name
  //public_ip_address_id  = "52.170.210.10"
  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.VSN1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id

  }
}

output "networkInerface" {
  value = azurerm_network_interface.main
}

resource "azurerm_windows_virtual_machine" "VM1" {
  name                  = "vm"
  resource_group_name   = azurerm_resource_group.RG1.name
  location              = azurerm_resource_group.RG1.location
  network_interface_ids = [azurerm_network_interface.main.id]
  size                  = element(var.winSize, 0) #element(list, index)
  #count                 = 1
  admin_username        = lookup(var.user, "admin", "user id is not difined") #lookup(map, key, default)
  admin_password        = lookup(var.password, "admin", "undefined")


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
output "winvalue" {
  sensitive = true
  value     = azurerm_windows_virtual_machine.VM1
}