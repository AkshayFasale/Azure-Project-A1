#!/usr/bin/env bash
# Bootstrap the Azure remote state backend.
#
# Chicken-and-egg: the storage account that holds Terraform state cannot itself
# be managed by the Terraform config that uses it. So it is created out-of-band,
# once, by this script. Safe to re-run - every step is idempotent.
#
# Keep these values in sync with terraform/environments/dev/backend.tf.

set -euo pipefail

LOCATION="centralindia"
STATE_RG="rg-tfstate"
STORAGE_ACCOUNT="sttfstateazprj786b3e"
CONTAINER="tfstate"

echo "==> Subscription: $(az account show --query name -o tsv)"

# 1. Microsoft.Storage is NotRegistered on this subscription, and the azurerm
#    provider is configured with resource_provider_registrations = "none",
#    so it will never self-register. Do it here.
echo "==> Registering Microsoft.Storage (one-time, can take a few minutes)"
az provider register --namespace Microsoft.Storage
until [ "$(az provider show --namespace Microsoft.Storage --query registrationState -o tsv)" = "Registered" ]; do
  echo "    still registering..."
  sleep 15
done
echo "    Registered."

# 2. Separate resource group, deliberately NOT rg-dev-azureproject: a
#    `terraform destroy` of the dev env must never be able to delete the state.
echo "==> Resource group: $STATE_RG"
az group create --name "$STATE_RG" --location "$LOCATION" --output none

# 3. Storage account.
#    - allow-shared-key-access false  -> access keys disabled, Entra ID auth only
#    - versioning                     -> every state write keeps a recoverable prior version
echo "==> Storage account: $STORAGE_ACCOUNT"
az storage account create \
  --name "$STORAGE_ACCOUNT" \
  --resource-group "$STATE_RG" \
  --location "$LOCATION" \
  --sku Standard_LRS \
  --kind StorageV2 \
  --min-tls-version TLS1_2 \
  --allow-blob-public-access false \
  --allow-shared-key-access false \
  --output none

echo "==> Enabling blob versioning + soft delete"
az storage account blob-service-properties update \
  --account-name "$STORAGE_ACCOUNT" \
  --resource-group "$STATE_RG" \
  --enable-versioning true \
  --enable-delete-retention true \
  --delete-retention-days 30 \
  --output none

# 4. Grant yourself data-plane access. Control-plane Owner is NOT enough to read
#    or write blobs once shared keys are disabled - that needs an RBAC data role.
echo "==> Assigning 'Storage Blob Data Owner' to signed-in user"
USER_OID="$(az ad signed-in-user show --query id -o tsv)"
SA_ID="$(az storage account show --name "$STORAGE_ACCOUNT" --resource-group "$STATE_RG" --query id -o tsv)"
az role assignment create \
  --assignee-object-id "$USER_OID" \
  --assignee-principal-type User \
  --role "Storage Blob Data Owner" \
  --scope "$SA_ID" \
  --output none 2>/dev/null || echo "    (already assigned)"

echo "==> Waiting 60s for RBAC propagation"
sleep 60

# 5. Container. --auth-mode login forces Entra ID rather than an account key.
echo "==> Container: $CONTAINER"
az storage container create \
  --name "$CONTAINER" \
  --account-name "$STORAGE_ACCOUNT" \
  --auth-mode login \
  --output none

echo
echo "Done. Backend is ready:"
echo "  resource_group_name  = $STATE_RG"
echo "  storage_account_name = $STORAGE_ACCOUNT"
echo "  container_name       = $CONTAINER"
echo
echo "Next: cd terraform/environments/dev && terraform init"
