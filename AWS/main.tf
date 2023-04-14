
data "aws_secretsmanager_secret" "databricks_acc_pwd_secret_name" {
  name = local.databricks_configs.databricks_acc_pwd_secret_name
}

data "aws_secretsmanager_secret_version" "databricks_acc_pwd_secret_value" {
  secret_id = data.aws_secretsmanager_secret.databricks_acc_pwd_secret_name.id
}


data "aws_secretsmanager_secret" "git_token_secret_name" {
  name = local.databricks_configs.git_token_secret_name
}

data "aws_secretsmanager_secret_version" "git_token_secret_value" {
  secret_id = data.aws_secretsmanager_secret.git_token_secret_name.id
}

data "aws_secretsmanager_secret" "workspace_secret_name" {
  name = local.databricks_configs.workspace_secret_name
  depends_on = [
    module.iam-vpc-s3-ws
  ]
}

data "aws_secretsmanager_secret_version" "workspace_secret_values" {
  secret_id = data.aws_secretsmanager_secret.workspace_secret_name.id
  depends_on = [
    module.iam-vpc-s3-ws
  ]
}



module "iam-vpc-s3-ws" {
  source = "../modules/aws-databricks-iam-vpc-s3-ws"
  providers = {
      databricks = databricks.mws
     }
  prefix = local.databricks_configs.prefix
  databricks_account_id = local.databricks_configs.databricks_account_id
  cidr_block = local.databricks_configs.cidr_block
  tags = local.tags
  region = local.databricks_configs.region
  workspace_secret_name = local.databricks_configs.workspace_secret_name
  workspace_host_key_name = local.databricks_configs.workspace_host_key_name
  workspace_token_key_name = local.databricks_configs.workspace_token_key_name
}



module "workspace-resource" {
    source = "../modules/databricks-ws-resources"
    depends_on = [
      module.iam-vpc-s3-ws
    ]
    providers = {
      databricks = databricks.workspace
     }
    workspace_dir_path = local.databricks_configs.workspace_dir_path
    git_username = local.databricks_configs.git_username
    git_provider = local.databricks_configs.git_provider
    personal_access_token = jsondecode(data.aws_secretsmanager_secret_version.git_token_secret_value.secret_string)[local.databricks_configs.git_token_key_name]
    path_in_workspace = local.databricks_configs.path_in_workspace
    branch = local.databricks_configs.branch
    git_url = local.databricks_configs.git_url
    node_type_id = local.databricks_configs.node_type_id
    databrick_job_name = local.databricks_configs.databrick_job_name
    databrick_job_cron = local.databricks_configs.databrick_job_cron
    databrick_tz_id = local.databricks_configs.databrick_tz_id
    email_notify_on_success = local.databricks_configs.email_notify_on_success
    email_notify_on_start = local.databricks_configs.email_notify_on_start
    email_notify_on_failure = local.databricks_configs.email_notify_on_failure
    job_task_name = local.databricks_configs.job_task_name
    job_notebook_task_path = local.databricks_configs.job_notebook_task_path
}

module "workspace-security" {
    source = "../modules/databricks-security"
    for_each = local.databrick_users
    depends_on = [
      module.workspace-resource
    ]
    providers = {
      databricks = databricks.workspace
     }
     my_custom_directory = local.databricks_configs.workspace_dir_path
     user_name = each.value.email
     workspace_access = each.value.workspace_access
     databricks_repo_id = module.workspace-resource.databricks_repo_id
     allow_cluster_create = each.value.allow_cluster_create
     allow_instance_pool_create = each.value.allow_instance_pool_create
     databricks_sql_access = each.value.databricks_sql_access
     databricks_job_id = module.workspace-resource.databricks_job_id
     databricks_cluster_id = module.workspace-resource.databricks_cluster_id
     databricks_cluster_policy_id = module.workspace-resource.databricks_cluster_policy_id
     databricks_instance_pool_id = module.workspace-resource.databricks_instance_pool_id
  
}

