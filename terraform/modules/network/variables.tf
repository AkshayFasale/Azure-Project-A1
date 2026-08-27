variable "resource_group_name" {
  description = "The name of the resource group in which to create the network resources."
  type        = string
}

variable "location" {
  description = "The Azure region in which to create the network resources."
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network to create."
  type        = string
}

variable "address_space" {
  description = "The address space of the virtual network."
  type        = list(string)
}

variable "public_subnet_name" {
  description = "The name of the public subnet to create."
  type        = string
}

variable "public_subnet_prefix" {
  description = "Public subnet CIDR"
  type        = list(string)
}

variable "private_subnet_name" {
  description = "Private subnet name"
  type        = string
}

variable "private_subnet_prefix" {
  description = "Private subnet CIDR"
  type        = list(string)
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}

variable "nsg_name" {
  description = "The name of the network security group to create."
  type        = string
}
variable "admin_ip" {
  description = "Admin IP address for SSH access"
  type        = string
}

