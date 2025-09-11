resource "azurerm_lb" "loadbalancer" {
  name                = var.loadbalancer_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "FrontendPublicIPAddress"
    public_ip_address_id = data.azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.loadbalancer.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.loadbalancer.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "FrontendPublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool.id]
  probe_id                       = azurerm_lb_probe.lb_probe.id
}

resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id = azurerm_lb.loadbalancer.id
  name            = "http-probe"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}


# === Associate NICs with Backend Pool ===
# For VM1
resource "azurerm_network_interface_backend_address_pool_association" "vm1_assoc" {
  network_interface_id    = data.azurerm_network_interface.vm1_nic.id
  ip_configuration_name   = "internal" # must match the NIC's ip_configuration block name
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}

# For VM2
resource "azurerm_network_interface_backend_address_pool_association" "vm2_assoc" {
  network_interface_id    = data.azurerm_network_interface.vm2_nic.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}
