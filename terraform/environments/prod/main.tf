resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}

module "network" {
  source = "../../modules/network"

  resource_group_name   = azurerm_resource_group.main.name
  location              = azurerm_resource_group.main.location
  nsg_name              = var.nsg_name
  vnet_name             = var.vnet_name
  address_space         = var.address_space
  public_subnet_name    = var.public_subnet_name
  public_subnet_prefix  = var.public_subnet_prefix
  private_subnet_name   = var.private_subnet_name
  private_subnet_prefix = var.private_subnet_prefix
  tags                  = local.common_tags

  admin_ip = var.admin_ip

}

module "compute" {

  source              = "../../modules/compute"
  resource_group_name = azurerm_resource_group.main.name
  admin_username      = var.admin_username
  location            = azurerm_resource_group.main.location
  ssh_public_key_path = var.ssh_public_key_path
  subnet_id           = module.network.public_subnet_id
  tags                = local.common_tags
  vm_name             = var.vm_name
  vm_size             = var.vm_size
  image_publisher     = var.image_publisher
  image_offer         = var.image_offer
  image_sku           = var.image_sku
  custom_script       = file("${path.module}/../../../scripts/cloud-init.yaml")
}