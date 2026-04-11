# resource "azurerm_public_ip" "example" {
#   name                = "${var.component}-ip"
#   location            = data.azurerm_resource_group.example.location
#   resource_group_name = data.azurerm_resource_group.example.name
#   allocation_method   = "Static"
#
#   tags = {
#     environment = "var.component"
#   }
# }
# resource "azurerm_virtual_network" "example" {
#   name                = "example-network"
#   address_space       = ["10.0.0.0/16"]
#   location            = data.azurerm_resource_group.example.location
#   resource_group_name = data.azurerm_resource_group.example.name
# }
#
# resource "azurerm_subnet" "example" {
#   name                 = "internal"
#   resource_group_name = data.azurerm_resource_group.example.name
#   virtual_network_name = azurerm_virtual_network.example.name
#   address_prefixes     = ["10.0.2.0/24"]
# }
#
# resource "azurerm_network_interface" "example" {
#   name                = "${var.component}-nic"
#   location            = data.azurerm_resource_group.example.location
#   resource_group_name = data.azurerm_resource_group.example.name
#
#   ip_configuration {
#     name                          = "internal"
#     subnet_id                     = azurerm_subnet.example.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.example.id
#
#   }
# }
#
# resource "azurerm_network_security_group" "main" {
#   name                = "${var.component}-nsg"
#   location            = data.azurerm_resource_group.example.location
#   resource_group_name = data.azurerm_resource_group.example.name
#
#   security_rule {
#     name                       = "main"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "*"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
#
#   tags = {
#     component = var.component
#   }
# }
#
# resource "azurerm_network_interface_security_group_association" "main" {
#   network_interface_id      = azurerm_network_interface.example.id
#   network_security_group_id = azurerm_network_security_group.main.id
# }
# resource "azurerm_virtual_machine" "main" {
#   name                  = var.component
#   location              = data.azurerm_resource_group.example.location
#   resource_group_name   = data.azurerm_resource_group.example.name
#   network_interface_ids = [azurerm_network_interface.example.id]
#   vm_size               = var.vm_size
#
#   # Uncomment this line to delete the OS disk automatically when deleting the VM
#   delete_os_disk_on_termination = true
#
#
#   storage_image_reference {
#     id = "/subscriptions/0aa6e6f6-6e44-47f7-b30d-2aa0dfd4e5f4/resourcegroups/RG/providers/Microsoft.Compute/galleries/image/images/custom/versions/1.0.0"
#   }
#
#
#   storage_os_disk {
#     name              = var.component
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }
#   os_profile {
#     computer_name  = var.component
#     admin_username = "aarti"
#     admin_password = "Aarti@431721"
#   }
#   os_profile_linux_config {
#     disable_password_authentication = false
#   }
#   tags = {
#     component         = var.component
#     prometheus_scrape = "true"
#   }
# }





resource "azurerm_public_ip" "main" {
  name                = "${var.component}-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "main" {
  name                = "${var.component}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_network_security_group" "main" {
  name                = "${var.component}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow-all"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_virtual_machine" "main" {
  name                  = var.component
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.vm_size

  delete_os_disk_on_termination = true

  storage_image_reference {
    id = "/subscriptions/0aa6e6f6-6e44-47f7-b30d-2aa0dfd4e5f4/resourceGroups/RG/providers/Microsoft.Compute/galleries/image/images/custom/versions/1.0.0"
  }

  storage_os_disk {
    name              = var.component
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.component
    admin_username = "aarti"
    admin_password = "Aarti@431721"   # ⚠️ change this
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    component = var.component
  }
}