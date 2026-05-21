variable "resource_group_name" {}

variable "vnet_name" {}

variable "subnets" {
  type = map(list(string))
}