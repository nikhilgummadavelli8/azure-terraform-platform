# Network Module

Environment-agnostic Azure networking module that provisions VNet and subnets for AKS and compute workloads.

## Overview

This module creates the **networking foundation** for the platform. It's the first module called because all other modules depend on the network infrastructure it creates.

## Architecture

```mermaid
graph TD
    INPUT[Inputs<br/>VNet CIDR<br/>Subnet CIDRs<br/>Location] --> RG[Resource Group]
    RG --> VNET[Virtual Network<br/>Private IP Space]
    VNET --> AKS_SUB[AKS Subnet<br/>For Kubernetes Nodes]
    VNET --> COMP_SUB[Compute Subnet<br/>For VMs/VMSS]
    
    AKS_SUB --> AKS_OUT[→ AKS Module]
    COMP_SUB --> COMP_OUT[→ Compute Module]
    RG --> RG_OUT[→ Compute & AKS Modules]
    
    style VNET fill:#4A90E2,color:#fff
    style AKS_SUB fill:#50C878,color:#fff
    style COMP_SUB fill:#9B59B6,color:#fff
```

## Resources Created

| Resource | Purpose |
|----------|---------|
| **Resource Group** | Logical container for network resources |
| **Virtual Network** | Private IP address space |
| **AKS Subnet** | Dedicated subnet for Kubernetes nodes |
| **Compute Subnet** | Dedicated subnet for VMs and VM Scale Sets |

## Network Isolation

```mermaid
graph LR
    VNET[VNet<br/>10.x.0.0/16] --> AKS[AKS Subnet<br/>10.x.1.0/24<br/>Kubernetes Nodes]
    VNET --> COMPUTE[Compute Subnet<br/>10.x.2.0/24<br/>VM Scale Sets]
    
    style VNET fill:#3498DB,color:#fff
    style AKS fill:#27AE60,color:#fff
    style COMPUTE fill:#8E44AD,color:#fff
```

## Inputs

| Variable | Type | Description | Example |
|----------|------|-------------|---------|
| `resource_group_name` | string | Name of resource group | `azplatform-dev-network-rg` |
| `location` | string | Azure region | `East US` |
| `vnet_name` | string | Virtual network name | `azplatform-dev-vnet` |
| `vnet_address_space` | list(string) | VNet CIDR blocks | `["10.0.0.0/16"]` |
| `aks_subnet_name` | string | AKS subnet name | `aks-subnet` |
| `aks_subnet_prefixes` | list(string) | AKS subnet CIDR | `["10.0.1.0/24"]` |
| `compute_subnet_name` | string | Compute subnet name | `compute-subnet` |
| `compute_subnet_prefixes` | list(string) | Compute subnet CIDR | `["10.0.2.0/24"]` |
| `tags` | map(string) | Resource tags | `{ Environment = "dev" }` |

## Outputs

| Output | Description | Used By |
|--------|-------------|---------|
| `vnet_id` | Virtual network ID | RBAC module |
| `vnet_name` | Virtual network name | Documentation |
| `resource_group_name` | Resource group name | Compute, AKS modules |
| `location` | Azure region | Compute, AKS modules |
| `aks_subnet_id` | AKS subnet ID | AKS module |
| `compute_subnet_id` | Compute subnet ID | Compute module |

## Usage

```hcl
module "network" {
  source = "../../modules/network"
  
  resource_group_name     = "azplatform-dev-network-rg"
  location                = "East US"
  vnet_name               = "azplatform-dev-vnet"
  vnet_address_space      = ["10.0.0.0/16"]
  aks_subnet_name         = "aks-subnet"
  aks_subnet_prefixes     = ["10.0.1.0/24"]
  compute_subnet_name     = "compute-subnet"
  compute_subnet_prefixes = ["10.0.2.0/24"]
  tags                    = { Environment = "dev" }
}
```

## Design Principles

✅ **Environment-Agnostic** - No hardcoded environment names  
✅ **Separation of Concerns** - Only handles networking, nothing else  
✅ **Reusable** - Can be used for any workspace  
✅ **Clean Outputs** - Provides exactly what downstream modules need

## Why Separate Subnets?

Separate subnets provide:
- **Network segmentation** for security
- **Independent IP management** 
- **Easier network policy** application
- **Clear separation** between Kubernetes and compute workloads
