# ============================================================================
# COMPUTE MODULE - VM Scale Sets with Managed Identities
# ============================================================================
# Provisions auto-scaling virtual machine sets with managed identities
# Environment-agnostic: all configuration comes from variables
# ============================================================================

# Create user-assigned managed identity for VMSS
# Managed identities provide Azure AD authentication without storing credentials
resource "azurerm_user_assigned_identity" "vmss" {
  name                = var.identity_name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

resource "azurerm_linux_virtual_machine_scale_set" "main" {
  count               = var.vmss_instance_count > 0 ? 1 : 0
  name                = var.vmss_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.vm_sku
  instances           = var.vmss_instance_count
  admin_username      = var.admin_username

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.vmss.id]
  }

  network_interface {
    name    = "${var.vmss_name}-nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.subnet_id
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  tags = var.tags
}
