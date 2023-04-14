
# Configure the Azure provider
provider "azurerm" {
  features {}
}


# Configure the databricks provider with the workspace url
provider "databricks" {
  azure_workspace_resource_id = module.databricks_iac_az.databricks_workspace_id
}
