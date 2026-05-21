resource "azurerm_public_ip" "nat_pip" {
    name = var.nat_pip_name
    resource_group_name = var.resource_group_name
    location = var.location
    allocation_method = "Static"
    sku = "Standard"
}

resource "azurerm_nat_gateway" "nat_gateway" {
    name = var.nat_gateway_name
    resource_group_name = var.resource_group_name
    location = var.location
    sku_name = "Standard"
    idle_timeout_in_minutes = 10
}

resource "azurerm_nat_gateway_public_ip_association" "nat_pip_assoc" {
    nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
    public_ip_address_id = azurerm_public_ip.nat_pip.id
}

resource "azurerm_subnet_nat_gateway_association" "priv_sub_nat_assoc" {
    subnet_id = var.subnet_id
    nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}