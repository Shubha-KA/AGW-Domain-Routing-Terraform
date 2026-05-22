# Azure Application Gateway WAF_v2 – Domain Based Routing using Terraform

## Project Overview

This project demonstrates a production-style Azure infrastructure deployment using custom modular Terraform code to implement:

- Domain-based routing
- Azure Application Gateway WAF_v2
- Multiple backend applications
- Secure private backend infrastructure
- NAT Gateway outbound connectivity
- Azure Bastion access
- Custom VM deployment scripts using `custom_data`
- Nginx reverse proxy
- MongoDB installation
- Automated application deployment

---

# Architecture

```text
                          Internet
                               |
                     Domain/Subdomain Requests
                               |
                 +-----------------------------+
                 | Azure Application Gateway   |
                 |          WAF_v2             |
                 +-----------------------------+
                               |
          ------------------------------------------------
          |                                              |
          |                                              |
 organic.vkcolors.shop                     fitness.vkcolors.shop
          |                                              |
          |                                              |
    Backend Pool 1                               Backend Pool 2
          |                                              |
      Organic VM                                    Fitness VM
          |                                              |
        Nginx                                         Nginx
          |                                              |
      NodeJS App                                   NodeJS App
          |                                              |
        MongoDB                                       MongoDB
```

---

# Features

- Modular Terraform Architecture
- Azure Application Gateway WAF_v2
- Domain Based Routing
- Azure Bastion for Secure SSH Access
- NAT Gateway for Private Outbound Connectivity
- Private Backend VMs
- Nginx Reverse Proxy
- Automated NodeJS Application Deployment
- MongoDB Installation
- Dynamic Terraform Modules using `for_each`
- Infrastructure as Code (IaC)

---

# Technologies Used

- Terraform
- Microsoft Azure
- Azure Application Gateway WAF_v2
- Azure Bastion
- Azure NAT Gateway
- Nginx
- NodeJS
- PM2
- MongoDB
- Linux VM
- Bash Scripting

---

# Infrastructure Components

| Component | Purpose |
|---|---|
| Resource Group | Infrastructure container |
| Virtual Network | Network isolation |
| Subnets | App Gateway, App VM, Bastion |
| NSG | Network security rules |
| NAT Gateway | Outbound internet access |
| Bastion Host | Secure SSH access |
| Application Gateway | Layer 7 load balancing |
| WAF_v2 | Web application firewall |
| Linux VMs | Backend application hosting |
| Nginx | Reverse proxy |
| MongoDB | Database |
| PM2 | NodeJS process manager |

---

# Project Structure

```text
AGW-Domain-Routing-Terraform/
│
├── modules/
│   ├── resource_group/
│   ├── vnet/
│   ├── subnet/
│   ├── nsg/
│   ├── nic/
│   ├── vm/
│   ├── nat_gateway/
│   ├── bastion/
│   ├── waf/
│   └── application_gateway/
│
├── scripts/
│   ├── organic_app.sh
│   └── fitness_app.sh
│
├── main.tf
├── variables.tf
├── terraform.tfvars
├── outputs.tf
├── provider.tf
└── .gitignore
```

---

# Network Design

| Subnet | CIDR |
|---|---|
| agw-subnet | 10.0.1.0/24 |
| app-subnet | 10.0.2.0/24 |
| AzureBastionSubnet | 10.0.3.0/26 |

---

# NSG Rules

## Application Gateway NSG

Allowed:
- Port 80
- Port 443
- Port 65200-65535 from `GatewayManager`

## App Subnet NSG

Allowed:
- SSH (22) from Bastion subnet
- HTTP (80) from Application Gateway subnet

---

# Domain Based Routing

| Domain | Backend |
|---|---|
| organic.vkcolors.shop | Organic Ghee Application |
| fitness.vkcolors.shop | Fitness Tracker Application |

---

# Application Deployment Flow

## VM Bootstrap Process

Using Terraform `custom_data`:

- Install NodeJS
- Install PM2
- Install MongoDB
- Install Nginx
- Clone GitHub repository
- Configure environment variables
- Start application using PM2
- Configure Nginx reverse proxy

---

# Nginx Reverse Proxy

```nginx
location / {
    proxy_pass http://127.0.0.1:5656;

    proxy_http_version 1.1;

    proxy_set_header Upgrade $http_upgrade;

    proxy_set_header Connection 'upgrade';

    proxy_set_header Host $host;

    proxy_cache_bypass $http_upgrade;
}
```

---

# Application Gateway Features

- WAF_v2 SKU
- Domain-based routing
- Backend health probes
- Host-based listeners
- Backend pools
- Request routing rules
- Autoscaling support

---

# WAF Configuration

- OWASP Rule Set 3.2
- Prevention Mode Enabled

---

# Security Features

- Private backend VMs
- No public IP on backend servers
- Azure Bastion secure access
- WAF protection
- NSG subnet-level filtering
- NAT Gateway outbound-only connectivity

---

# Terraform Commands

## Initialize Terraform

```bash
terraform init
```

## Validate Configuration

```bash
terraform validate
```

## View Execution Plan

```bash
terraform plan
```

## Deploy Infrastructure

```bash
terraform apply
```

## Destroy Infrastructure

```bash
terraform destroy
```

---

# DNS Configuration

Point both domains to Application Gateway Public IP.

Example:

```text
organic.vkcolors.shop  -> App Gateway Public IP
fitness.vkcolors.shop -> App Gateway Public IP
```

---

# HTTPS Enablement

HTTPS can be enabled using:

- Certbot
- Let's Encrypt
- Azure Key Vault
- SSL Certificates on Application Gateway

---

# Future Enhancements

- End-to-End HTTPS
- Azure Key Vault Integration
- VM Scale Sets
- CI/CD using GitHub Actions
- Azure Monitor
- Log Analytics
- Autoscaling
- Private DNS
- Azure Firewall

---

# Learning Outcomes

This project demonstrates practical understanding of:

- Azure Networking
- Layer 7 Routing
- WAF Architecture
- Terraform Modular Design
- Infrastructure as Code
- Reverse Proxy Configuration
- Secure Cloud Architecture
- Private Networking
- Domain Based Routing
- Linux Automation

---

# Author

Shubha K A
