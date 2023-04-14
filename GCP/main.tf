data "google_secret_manager_secret_version" "azkey" {
  secret = local.databricks_configs.git_token_secret
  project = local.databricks_configs.google_project
}


data "google_secret_manager_secret_version" "ws_host_name" {
  secret = local.databricks_configs.db_ws_host_secret
  project = local.databricks_configs.google_project
  depends_on = [
      module.workspace
    ]
}

data "google_secret_manager_secret_version" "ws_token" {
  secret = local.databricks_configs.db_ws_token_secret
  project = local.databricks_configs.google_project
  depends_on = [
      module.workspace
    ]
}



module "vpc"{
    source = "../modules/gcp-databricks-vpc"
    providers = {
      databricks = databricks.accounts
     }
    google_project = local.databricks_configs.google_project
    databricks_account_id = local.databricks_configs.databricks_account_id
    region = local.databricks_configs.gcp_region
    secondary_ip_range_name_pods = local.databricks_configs.gke_pods_secondary_ip_range_name
    secondary_ip_range_pods = local.databricks_configs.gke_pods_secondary_ip_range
    secondary_ip_range_name_services = local.databricks_configs.gke_services_secondary_ip_range_name
    secondary_ip_range_services = local.databricks_configs.gke_services_secondary_ip_range
}

module "workspace" {
    source = "../modules/gcp-databricks-ws"
    depends_on = [
      module.vpc
    ]
    providers = {
      databricks = databricks.accounts
     }
    databricks_account_id = local.databricks_configs.databricks_account_id
    region = local.databricks_configs.gcp_region
    google_project = local.databricks_configs.google_project
    network_id = module.vpc.network_id
    master_ip_range = local.databricks_configs.master_ip_range
    workspace-host = local.databricks_configs.db_ws_host_secret
    workspace-token = local.databricks_configs.db_ws_token_secret
}

module "workspace-resource" {
    source = "../modules/databricks-ws-resources"
    depends_on = [
      module.workspace
    ]
    providers = {
      databricks = databricks.workspace
     }
    workspace_dir_path = local.databricks_configs.workspace_dir_path
    git_username = local.databricks_configs.git_username
    git_provider = local.databricks_configs.git_provider
    personal_access_token = data.google_secret_manager_secret_version.azkey.secret_data
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
