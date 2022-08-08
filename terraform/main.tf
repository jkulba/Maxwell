# Maxwell 

locals {
  subscription_id   = "85aee6d8-25f2-42c3-b3bc-a04a444e1a75"
  tenant_id         = "3794603d-0a24-4383-a08e-8b1ca6991b59"
  app-location      = "westus"
  app-environment   = "dev"
  function-app-name = "MaxwellFunctionApp"
  project-name      = "maxwell"
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  subscription_id = local.subscription_id
  tenant_id       = local.tenant_id
  features {}
}

resource "azurerm_resource_group" "resource_group" {
  name     = "${local.project-name}${local.app-environment}resourcegroup"
  location = local.app-location

  tags = {
    Application = local.function-app-name
    Env         = local.app-environment
    Team        = "DevOps"
  }
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "${local.project-name}${local.app-environment}storageaccount"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Application = local.function-app-name
    Env         = local.app-environment
    Team        = "DevOps"
  }
}

# Create the Linux App Service Plan
resource "azurerm_service_plan" "service_plan" {
  name                = "${local.project-name}${local.app-environment}serviceplan"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  os_type             = "Linux"
  sku_name            = "Y1"

  tags = {
    Application = local.function-app-name
    Env         = local.app-environment
    Team        = "DevOps"
  }
}

# Create Linux Function App
# resource "azurerm_linux_function_app" "function_app" {
#   name                 = "${local.project-name}${local.app-environment}functionapp"
#   resource_group_name  = azurerm_resource_group.resource_group.name
#   location             = azurerm_resource_group.resource_group.location
#   storage_account_name = azurerm_storage_account.storage_account.name
#   service_plan_id      = azurerm_service_plan.service_plan.id
#   https_only           = true

#   site_config {
#     minimum_tls_version = "1.2"
#   }
# }
