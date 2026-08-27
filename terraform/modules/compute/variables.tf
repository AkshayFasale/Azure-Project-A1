variable "resource_group_name" {
  description = "The name of the resource group in which to create the compute resources."
  type        = string
}
variable "location" {
  description = "The Azure region in which to create the compute resources."
  type        = string
}

variable "vm_name" {
  description = "The name of the virtual machine to create."
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine."
  type        = string
}

variable "admin_username" {
  description = "The username for the administrator account on the virtual machine."
  type        = string
}

variable "ssh_public_key_path" {
  description = "The SSH public key for the administrator account on the virtual machine."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet in which to create the virtual machine."
  type        = string
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
}

variable "image_publisher" {
  description = "The publisher of the image to use for the virtual machine."
  type        = string
}

variable "image_offer" {
  description = "The offer of the image to use for the virtual machine."
  type        = string
}

variable "image_sku" {
  description = "The SKU of the image to use for the virtual machine."
  type        = string
}

variable "custom_script" {
  description = "Custom script to run on the virtual machine."
  type        = string
}