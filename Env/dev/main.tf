module "resource_group" {
    source = "../../modules/azurerm_resource_group"
    name = "resource_group_lb"
    location = "Switzerland North"
}

module "virtual_network" {
    depends_on = [ module.resource_group ]
    source = "../../modules/azurerm_virtual_network"
    virtual_network_name = "vnet_lb"
    resource_group_name = "resource_group_lb"
    resource_group_location = "Switzerland North"
    address_space = ["10.0.0.0/16"]
}

module "subnet" {
    depends_on = [ module.virtual_network ]
    source = "../../modules/azurerm_subnet"
    subnet_name = "subnet_lb"
    resource_group_name = "resource_group_lb"
    virtual_network_name = "vnet_lb"
    address_prefixes = ["10.0.1.0/24"]
}

module "public_ip" {
    depends_on = [ module.resource_group ]
    source = "../../modules/azurerm_public_ip"
    public_ip = "LoadBalancerIP"
    resource_group_name = "resource_group_lb"
    resource_group_location = "Switzerland North"
}

module "virtual_machine_1" {
    depends_on = [ module.subnet ]
    source = "../../modules/azurerm_linux_virtual_machine"
    subnet_name = "subnet_lb"
    virtual_network_name = "vnet_lb"
    resource_group_name = "resource_group_lb"
    resource_group_location = "Switzerland North"
    virtual_machine_name = "vm1"
    size = "Standard_B2ms"
    nic_name = "lbnic1"
}

module "virtual_machine_2" {
    depends_on = [ module.subnet ]
    source = "../../modules/azurerm_linux_virtual_machine"
    subnet_name = "subnet_lb"
    virtual_network_name = "vnet_lb"
    resource_group_name = "resource_group_lb"
    resource_group_location = "Switzerland North"
    virtual_machine_name = "vm2"
    size = "Standard_B2ms"
    nic_name = "lbnic2"
}

module "loadbalancer" {
    depends_on = [ module.public_ip, module.virtual_machine_1, module.virtual_machine_2]
    source = "../../modules/azurerm_load_balancer"
    loadbalancer_name = "TestLoadBalancer"
    resource_group_name = "resource_group_lb"
    resource_group_location = "Switzerland North"
}