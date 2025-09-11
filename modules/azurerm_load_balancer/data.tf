data "azurerm_public_ip" "public_ip" {
  name                = "LoadBalancerIP"
  resource_group_name = "resource_group_lb"
}

data "azurerm_network_interface" "vm1_nic" {
  name                = "lbnic1"
  resource_group_name = var.resource_group_name
}

data "azurerm_network_interface" "vm2_nic" {
  name                = "lbnic2"
  resource_group_name = var.resource_group_name
}
