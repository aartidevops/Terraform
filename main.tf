resource "azurerm_resource_group" "main" {
  name     = "RG"
  location = var.location
}

# ✅ Shared VNet (created ONLY once)
resource "azurerm_virtual_network" "main" {
  name                = "example-network"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.0.0.0/16"]
}

# ✅ Shared Subnet
resource "azurerm_subnet" "main" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# ✅ Module call (ONLY ONCE)
module "component" {
  for_each = var.component
  source   = "./resources"

  component           = each.value.name
  vm_size             = each.value.vm_size
  subnet_id           = azurerm_subnet.main.id
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
}