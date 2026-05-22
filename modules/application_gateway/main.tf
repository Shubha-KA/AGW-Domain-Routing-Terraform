resource "azurerm_public_ip" "appgw_pip" {
  name                = var.appgw_pip_name
  resource_group_name = var.resource_group_name
  location            = var.location

  allocation_method = "Static"
  sku               = "Standard"
}

resource "azurerm_application_gateway" "appgw" {
  name                = var.appgw_name
  resource_group_name = var.resource_group_name
  location            = var.location

  firewall_policy_id = var.waf_policy_id

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }

  autoscale_configuration {
    min_capacity = 1
    max_capacity = 2
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = var.agw_subnet_id
  }

  frontend_port {
    name = "http-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw_pip.id
  }

  backend_address_pool {
    name         = "organic-backend-pool"
    ip_addresses = [var.organic_vm_private_ip]
  }

  backend_address_pool {
    name         = "fitness-backend-pool"
    ip_addresses = [var.fitness_vm_private_ip]
  }

  backend_http_settings {
    name                  = "http-setting"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
    probe_name            = "health-probe"

    pick_host_name_from_backend_address = true
  }

  probe {
    name                                      = "health-probe"
    protocol                                  = "Http"
    path                                      = "/"
    interval                                  = 30
    timeout                                   = 30
    unhealthy_threshold                       = 3
    pick_host_name_from_backend_http_settings = true
  }

  http_listener {
    name                           = "organic-listener"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
    host_name                      = var.organic_domain
  }

  http_listener {
    name                           = "fitness-listener"
    frontend_ip_configuration_name = "frontend-ip"
    frontend_port_name             = "http-port"
    protocol                       = "Http"
    host_name                      = var.fitness_domain
  }

  request_routing_rule {
    name                       = "organic-rule"
    rule_type                  = "Basic"
    priority                   = 100
    http_listener_name         = "organic-listener"
    backend_address_pool_name  = "organic-backend-pool"
    backend_http_settings_name = "http-setting"
  }

  request_routing_rule {
    name                       = "fitness-rule"
    rule_type                  = "Basic"
    priority                   = 110
    http_listener_name         = "fitness-listener"
    backend_address_pool_name  = "fitness-backend-pool"
    backend_http_settings_name = "http-setting"
  }
}