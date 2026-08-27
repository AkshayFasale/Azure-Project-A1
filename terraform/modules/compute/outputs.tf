output "public_ip_id" {
  value = azurerm_public_ip.public_ip.id
}


output "nic_id" {
  value = azurerm_network_interface.main.id
}

output "public_ip_address" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.public_ip.ip_address
}