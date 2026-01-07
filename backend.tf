terraform {
  backend "azurerm" {
    # Backend configuration should be provided via:
    # 1. Backend config file: terraform init -backend-config=backend.hcl
    # 2. Environment variables: ARM_RESOURCE_GROUP_NAME, ARM_STORAGE_ACCOUNT_NAME, etc.
    # 3. Interactive prompt during terraform init

    # Example configuration (create backend.hcl locally):
    # resource_group_name  = "terraform-state-rg"
    # storage_account_name = "tfstatexxxxx"  # Must be globally unique
    # container_name       = "tfstate"
    # key                  = "azure-platform/${terraform.workspace}/terraform.tfstate"
    # use_azuread_auth     = true
  }
}
