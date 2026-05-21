output "nic1_id" {
  value = azurerm_network_interface.nic1.id
}

output "nic2_id" {
  value = azurerm_network_interface.nic2.id
}

output "nic1_private_ip" {
  value = azurerm_network_interface.nic1.private_ip_address
}

output "nic2_private_ip" {
  value = azurerm_network_interface.nic2.private_ip_address
}