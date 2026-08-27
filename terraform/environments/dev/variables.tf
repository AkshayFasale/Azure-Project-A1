variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}
variable "nsg_name" {
  description = "Name of the network security group"
  type        = string
}

variable "vnet_name" {
  type = string
}

variable "public_subnet_name" {
  type = string
}

variable "private_subnet_name" {
  type = string
}

variable "public_subnet_prefix" {
  type = list(string)
}

variable "private_subnet_prefix" {
  type = list(string)
}
variable "address_space" {
  type = list(string)
}
variable "ssh_public_key_path" {
  description = "Path to the SSH public key"
  type        = string
}
variable "vm_name" {
  type = string
}
variable "vm_size" {
  type = string
}
variable "image_publisher" {
  type = string
}
variable "image_offer" {
  type = string
}
variable "image_sku" {
  type = string
}
variable "admin_username" {
  type = string
}
variable "admin_ip" {
  description = "Admin IP address for SSH access"
  type        = string
}
