
resource "databricks_user" "usr" {
  user_name    = var.user_name
  workspace_access = var.workspace_access
  allow_cluster_create = var.allow_cluster_create
  allow_instance_pool_create = var.allow_instance_pool_create
  databricks_sql_access = var.databricks_sql_access
  active = var.active

}


resource "databricks_permissions" "folder_usage" {

  directory_path = var.my_custom_directory

    access_control {
    user_name        = databricks_user.usr.user_name
    permission_level = "CAN_MANAGE"
  }
}



resource "databricks_permissions" "repo_usage" {

  repo_id = var.databricks_repo_id

    access_control {
    user_name        = databricks_user.usr.user_name
    permission_level = "CAN_MANAGE"
  }
}


resource "databricks_permissions" "job" {
  
  job_id = var.databricks_job_id

  access_control {
    user_name        = databricks_user.usr.user_name
    permission_level = "CAN_MANAGE"
  }
}

resource "databricks_permissions" "cluster" {
  
  cluster_id = var.databricks_cluster_id
  access_control {
    user_name        = databricks_user.usr.user_name
    permission_level = "CAN_MANAGE"
  }
}

resource "databricks_permissions" "policy" {

  cluster_policy_id = var.databricks_cluster_policy_id
  access_control {
    user_name        = databricks_user.usr.user_name
    permission_level = "CAN_USE"
  }
}

resource "databricks_permissions" "pool" {

  instance_pool_id = var.databricks_instance_pool_id
  access_control {
    user_name        = databricks_user.usr.user_name
    permission_level = "CAN_MANAGE"
  }
}