module "network" {
  source              = "./network"
  resource_group_name = "my-rg"
  location            = "West Europe"
  vnet_name           = "my-vnet"
  vnet_address_space  = "10.0.0.0/16"
  subnet_name         = "my-subnet"
  subnet_address_prefix = "10.0.1.0/24"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "myaks"
  location            = module.network.location
  resource_group_name = module.network.resource_group_name
  dns_prefix          = "myaks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
    vnet_subnet_id = module.network.subnet_id
  }

  network_profile {
    network_plugin     = "azure"
    service_cidr       = "10.1.0.0/16"
    dns_service_ip     = "10.1.0.2"
    docker_bridge_cidr = "172.17.0.1/16"
  }

  identity {
    type = "SystemAssigned"
  }
}

provider "azurerm" {
  features {}
}
