variable "resource_group_name" {}
variable "location" {}

variable "vnet_name" {}
variable "vnet_address_space" {}

variable "agw_subnet_prefix" {}
variable "app_subnet_prefix" {}
variable "bastion_subnet_prefix" {}

variable "agw_nsg_name" {}
variable "app_nsg_name" {}

variable "nic1_name" {}
variable "nic2_name" {}

variable "vm_size" {}

variable "admin_username" {}
variable "admin_password" {}

variable "nat_pip_name" {}
variable "nat_gateway_name" {}

variable "bastion_name" {}
variable "bastion_pip_name" {}

variable "waf_policy_name" {}

variable "appgw_name" {}

variable "appgw_pip_name" {}

variable "organic_domain" {}

variable "fitness_domain" {}