#############################################################################
# PROVIDERS
#############################################################################
provider "azurerm" {
  features {}
  version         = ">2.21.0"
  subscription_id = "dead8329-b12b-4816-8b97-943531d50a18"
}

variable "resource_group_name" {
  type        = string
  description = "name of resource group"
  default     = "Azdemo-rg01"
}

#############################################################################
# RESOURCES
#############################################################################

resource "azurerm_template_deployment" "vwan" {
  name                = "azdeployment01"
  resource_group_name = var.resource_group_name

  template_body = file("az-sharedisk.json")

  parameters = {
    "dataDiskName" = "azshared-clsuter-disk01"
      }

  deployment_mode = "Incremental"
}