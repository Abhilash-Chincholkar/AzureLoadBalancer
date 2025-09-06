resource "azurerm_resource_group" "resource_group" {
  name     =  var.name #"resource_group_lb"
  location = var.location #"Switzerland North"
}

