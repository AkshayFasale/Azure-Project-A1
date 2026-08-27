output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.main.location
}
output "vm_public_ip" {
  description = "Public IP address of the development VM"
  value       = module.compute.public_ip_address
}