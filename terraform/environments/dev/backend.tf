# Remote state backend.
#
# Locking is automatic with the azurerm backend: Terraform takes a *blob lease*
# on the state blob for the duration of any state-mutating command. A second
# `terraform apply` against the same key will fail to acquire the lease and
# error out instead of racing. There is no separate lock table to provision
# (unlike S3 + DynamoDB).
#
# NOTE: backend blocks cannot use variables, locals, or interpolation - the
# backend is initialised before Terraform evaluates any config. These values
# must be literals, and must match terraform/bootstrap/create-state-backend.sh.

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "sttfstateazprj786b3e"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"

    # Authenticate to the blob with your `az login` identity rather than a
    # storage account access key. The bootstrap script disables shared-key
    # access entirely, so this is required, not optional.
    use_azuread_auth = true
  }
}
