terraform {
  # Minimum Terraform version required for this configuration
  # Version 1.5.0+ includes improvements to workspace handling and state management
  required_version = ">= 1.5.0"

  # Define required providers and their versions
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80" # Use any 3.x version >= 3.80, but not 4.0
    }
  }
}

provider "azurerm" {
  # The features block is required by the Azure provider
  # It controls provider-level behaviors and safety mechanisms
  features {
    # Resource group safety: prevent accidental deletion of non-empty resource groups
    resource_group {
      prevent_deletion_if_contains_resources = true
    }

    # Key Vault safety: retain deleted vaults for recovery (soft delete)
    key_vault {
      purge_soft_delete_on_destroy    = false # Don't permanently delete vaults
      recover_soft_deleted_key_vaults = true  # Recover soft-deleted vaults
    }

    # Virtual machine behavior during terraform destroy
    virtual_machine {
      delete_os_disk_on_deletion     = true  # Clean up OS disks when VM is destroyed
      graceful_shutdown              = false # Force immediate shutdown
      skip_shutdown_and_force_delete = false # Go through shutdown process
    }
  }
}
