
terraform {
  backend "azurerm" {
    resource_group_name  = "demo-db-storage-rg"
    storage_account_name = "tfdbaziac"
    container_name       = "tfdbazdevstate"
    key                  = "dev.terraform.tfstate"
  }
}