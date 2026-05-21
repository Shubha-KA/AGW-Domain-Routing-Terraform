output "nat_gateway_id" {
  value = azurerm_nat_gateway.nat_gateway.id
}

output "nat_public_ip" {
  value = azurerm_public_ip.nat_pip.ip_address
}