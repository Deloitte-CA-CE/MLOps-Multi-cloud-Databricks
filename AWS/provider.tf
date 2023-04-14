

provider "aws" {
  region = local.databricks_configs.region
}

// initialize provider in "MWS" mode for account-level resources
provider "databricks" {
  alias      = "mws"
  host       = "https://accounts.cloud.databricks.com"
  username   = local.databricks_configs.databricks_account_username
  password = jsondecode(data.aws_secretsmanager_secret_version.databricks_acc_pwd_secret_value.secret_string)[local.databricks_configs.databricks_acc_pwd_key_name]
}

// initialize provider at workspace level, to create UC resources
provider "databricks" {
  alias    = "workspace"
  host     = jsondecode(data.aws_secretsmanager_secret_version.workspace_secret_values.secret_string)[local.databricks_configs.workspace_host_key_name]
  token    = jsondecode(data.aws_secretsmanager_secret_version.workspace_secret_values.secret_string)[local.databricks_configs.workspace_token_key_name]
}