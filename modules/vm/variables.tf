variable "resource_group_name" {}

variable "location" {}

variable "vm_size" {}

variable "admin_username" {}

variable "admin_password" {}

variable "vms" {
  type = map(object({
    nic_id      = string
    custom_data = string
  }))
}