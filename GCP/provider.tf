
provider "google" {
  project = local.databricks_configs.google_project 
  region  = local.databricks_configs.gcp_region 
  zone    = local.databricks_configs.google_zone 
  impersonate_service_account = local.databricks_configs.databricks_google_service_account 

}

// initialize provider in "accounts" mode to provision new workspace
provider "databricks" {
  alias                  = "accounts"
  host                   = "https://accounts.gcp.databricks.com"
  google_service_account = local.databricks_configs.databricks_google_service_account
  account_id             = local.databricks_configs.databricks_account_id
}

provider "databricks" {
  alias                  = "workspace"
  host = data.google_secret_manager_secret_version.ws_host_name.secret_data
  token = data.google_secret_manager_secret_version.ws_token.secret_data
}

data "google_client_openid_userinfo" "me" {
}

data "google_client_config" "current" {
}

