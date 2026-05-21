resource "azurerm_network_interface" "nic1" {
    name = var.nic1_name
    resource_group_name = var.resource_group_name
    location = var.location

    ip_configuration {
        name = "internal"
        subnet_id = var.subnet_id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_network_interface" "nic2" {
    name = var.nic2_name
    resource_group_name = var.resource_group_name
    location = var.location

    ip_configuration {
        name = "internal"
        subnet_id = var.subnet_id
        private_ip_address_allocation = "Dynamic"
    }
}