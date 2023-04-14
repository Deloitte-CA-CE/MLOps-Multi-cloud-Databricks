
data "azurerm_key_vault" "existing" {
  name                = local.databricks_configs.key_vault_name
  resource_group_name = local.databricks_configs.resource_group
}

data "azurerm_key_vault_secret" "tfdbaz" {
  name         = local.databricks_configs.secret_key_name
  key_vault_id = data.azurerm_key_vault.existing.id
}


module "databricks_iac_az" {
    source = "../modules/databricks-ws-resources-azure"
    azure_region = local.databricks_configs.azure_region
    prefix = local.databricks_configs.prefix
    tag_environment= local.databricks_configs.tag_environment
    workspace_dir_path = local.databricks_configs.workspace_dir_path
    git_username = local.databricks_configs.git_username
    git_provider = local.databricks_configs.git_provider
    personal_access_token = data.azurerm_key_vault_secret.tfdbaz.value 
    path_in_workspace = local.databricks_configs.path_in_workspace
    branch = local.databricks_configs.branch
    git_url = local.databricks_configs.git_url
    node_type_id = local.databricks_configs.node_type_id
    databrick_job_name = local.databricks_configs.databricks_job_name
    databrick_job_cron = local.databricks_configs.databricks_job_cron
    databrick_tz_id = local.databricks_configs.databricks_tz_id
    email_notify_on_success = local.databricks_configs.email_notify_on_success
    email_notify_on_start = local.databricks_configs.email_notify_on_start
    email_notify_on_failure = local.databricks_configs.email_notify_on_failure
    job_task_name = local.databricks_configs.job_task_name
    job_notebook_task_path = local.databricks_configs.job_notebook_task_path
}

resource "databricks_user" "me" {
    depends_on = [
      module.databricks_iac_az
    ]
    for_each = local.databrick_users
  user_name = each.value.email
  workspace_access = each.value.workspace_access
}
