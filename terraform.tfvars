resource_group_name = "agw-host-based-rg-1"
location = "Central India"

vnet_name = "rg-1-vnet-1"
vnet_address_space = ["10.0.0.0/16"]

agw_subnet_prefix   = ["10.0.1.0/24"]
app_subnet_prefix = ["10.0.2.0/24"]
bastion_subnet_prefix = ["10.0.3.0/24"]

agw_nsg_name = "agw-nsg"
app_nsg_name = "app-nsg"

nic1_name = "organic-nic"
nic2_name = "fitness-nic"

vm_size         = "Standard_D2ls_v5"
admin_username  = "shubha2001"
admin_password  = "Shubha@azure123"

nat_pip_name     = "nat-pip"
nat_gateway_name = "app-nat-gateway"

bastion_name     = "main-bastion"
bastion_pip_name = "bastion-pip"

waf_policy_name = "main-waf-policy"

appgw_name     = "main-appgw"

appgw_pip_name = "appgw-pip"

organic_domain = "organic.vkcolors.shop"

fitness_domain = "fitness.vkcolors.shop"