output "resource_group_name" {
  value = module.rg.resource_group_name
}

output "vnet_id" {
  value = module.vnet.vnet_id
}

output "subnet_ids" {
  value = module.subnet.subnet_ids
}

output "vm_ids" {
  value = module.vm.vm_ids
}

output "application_gateway_public_ip" {
  value = module.application_gateway.appgw_public_ip
}

output "nat_gateway_public_ip" {
  value = module.nat_gateway.nat_public_ip
}

output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}