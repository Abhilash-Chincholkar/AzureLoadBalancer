data "azurerm_public_ip" "public_ip" {
  name                = "LoadBalancerIP"
  resource_group_name = "resource_group_lb"
}