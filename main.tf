module "rg" {
  source = "./modules/resource_group"

  resource_group_name = var.resource_group_name
  location            = var.location
}

module "vnet" {
  source = "./modules/vnet"

  resource_group_name = module.rg.resource_group_name
  location            = module.rg.location

  vnet_name          = var.vnet_name
  vnet_address_space = var.vnet_address_space
}

module "subnet" {
  source = "./modules/subnet"

  resource_group_name = module.rg.resource_group_name
  vnet_name           = module.vnet.vnet_name

  subnets = {
    agw-subnet         = var.agw_subnet_prefix
    app-subnet         = var.app_subnet_prefix
    AzureBastionSubnet = var.bastion_subnet_prefix
  }
}

module "nsg" {
  source = "./modules/nsg"

  resource_group_name = module.rg.resource_group_name
  location            = module.rg.location

  agw_nsg_name      = var.agw_nsg_name
  app_nsg_name      = var.app_nsg_name

  agw_subnet_id     = module.subnet.subnet_ids["agw-subnet"]
  app_subnet_id     = module.subnet.subnet_ids["app-subnet"]

  agw_subnet_prefix = var.agw_subnet_prefix
}

module "nic" {
  source = "./modules/nic"

  resource_group_name = module.rg.resource_group_name
  location            = module.rg.location

  nic1_name = var.nic1_name
  nic2_name = var.nic2_name

  subnet_id = module.subnet.subnet_ids["app-subnet"]
}

module "vm" {
  source = "./modules/vm"

  resource_group_name = module.rg.resource_group_name
  location            = module.rg.location

  vm_size        = var.vm_size
  admin_username = var.admin_username
  admin_password = var.admin_password

  vms = {
    organic-vm = {
      nic_id      = module.nic.nic1_id
      custom_data = "${path.root}/scripts/organic_app.sh"
    }

    fitness-vm = {
      nic_id      = module.nic.nic2_id
      custom_data = "${path.root}/scripts/fitness_app.sh"
    }
  }
}

module "nat_gateway" {
  source = "./modules/nat_gateway"

  resource_group_name = module.rg.resource_group_name
  location            = module.rg.location

  nat_pip_name     = var.nat_pip_name
  nat_gateway_name = var.nat_gateway_name

  subnet_id = module.subnet.subnet_ids["app-subnet"]
}

module "bastion" {
  source = "./modules/bastion"

  resource_group_name = module.rg.resource_group_name
  location            = module.rg.location

  bastion_name     = var.bastion_name
  bastion_pip_name = var.bastion_pip_name

  bastion_subnet_id = module.subnet.subnet_ids["AzureBastionSubnet"]
}

module "waf" {
  source = "./modules/waf"

  resource_group_name = module.rg.resource_group_name
  location            = module.rg.location

  waf_policy_name = var.waf_policy_name
}

module "application_gateway" {
  source = "./modules/application_gateway"

  resource_group_name = module.rg.resource_group_name
  location            = module.rg.location

  appgw_name     = var.appgw_name
  appgw_pip_name = var.appgw_pip_name

  agw_subnet_id = module.subnet.subnet_ids["agw-subnet"]

  waf_policy_id = module.waf.waf_policy_id

  organic_vm_private_ip = module.nic.nic1_private_ip
  fitness_vm_private_ip = module.nic.nic2_private_ip

  organic_domain = var.organic_domain
  fitness_domain = var.fitness_domain
}