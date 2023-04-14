
resource "databricks_directory" "my_custom_directory" {

  path = "${var.workspace_dir_path}" 
}

# Configure the databricks_git_credential resource
resource "databricks_git_credential" "ado" {

  git_username          = var.git_username 
  git_provider          = var.git_provider 
  personal_access_token = var.personal_access_token 
}

# Configure the remote git repository for the workspace
# configured for the dev branch of the code repo
resource "databricks_repo" "nutter_in_home" {

  git_provider =  var.git_provider 
  path         = var.path_in_workspace 
  branch       = var.branch 
  url          = var.git_url 
}

# fetch the databricks current user
data "databricks_current_user" "me" {

}

# fetch the databricks spark version
data "databricks_spark_version" "latest" {

}
data "databricks_node_type" "smallest" {

  local_disk = true
  min_cores  = 1
}

# Create resource databricks_secret_scope
resource "databricks_secret_scope" "this" {

  name = "tf-secret-${data.databricks_current_user.me.alphanumeric}"
}

# Create resourece databricks_token
resource "databricks_token" "pat" {

  comment          = "Created from ${abspath(path.module)}"
  lifetime_seconds = 3600
}

# Create resourece databricks_secret
resource "databricks_secret" "token" {

  string_value = databricks_token.pat.token_value
  scope        = databricks_secret_scope.this.name
  key          = "token"
}

# Create resource databricks_cluster
resource "databricks_cluster" "this" {
  cluster_name            = "Exploration (${data.databricks_current_user.me.alphanumeric})"
  spark_version           = data.databricks_spark_version.latest.id
  instance_pool_id        = databricks_instance_pool.smallest_nodes.id
  autotermination_minutes = 20
  autoscale {
    min_workers = 1
    max_workers = 2
  }
}

# Create databricks_cluster_policy
resource "databricks_cluster_policy" "this" {
  name = "Minimal (${data.databricks_current_user.me.alphanumeric})"
  definition = jsonencode({
    "dbus_per_hour" : {
      "type" : "range",
      "maxValue" : 10
    },
    "autotermination_minutes" : {
      "type" : "fixed",
      "value" : 20,
      "hidden" : true
    }
  })
}

# Create databricks_instance_pool
resource "databricks_instance_pool" "smallest_nodes" {
  instance_pool_name = "Smallest Nodes (${data.databricks_current_user.me.alphanumeric})"
  min_idle_instances = 0
  max_capacity       = 30
  node_type_id       = var.node_type_id 
  preloaded_spark_versions = [
    data.databricks_spark_version.latest.id
  ]

  idle_instance_autotermination_minutes = 20
}

# Create databricks job
resource "databricks_job" "name_of_my_job" {
  name                = var.databrick_job_name 
  max_concurrent_runs = 1

  # job schedule
  schedule {
    quartz_cron_expression = var.databrick_job_cron 
    timezone_id            = var.databrick_tz_id 
  }

  # notifications at job level
  email_notifications {
    on_success = var.email_notify_on_success 
    on_start   = var.email_notify_on_start 
    on_failure = var.email_notify_on_failure 
  }

  # reference to git repo. Add the git credential separately
  # through a databricks_git_credential resource
  git_source {
    url      = var.git_url 
    provider = var.git_provider 
    branch   = var.branch 
  }

  # Create blocks for Tasks here #
  task {
    task_key = var.job_task_name 

    notebook_task {
      notebook_path = var.job_notebook_task_path 
      source        = "GIT"
    }


    existing_cluster_id = databricks_cluster.this.id 

    # notifications at task level
    email_notifications {
      on_success = var.email_notify_on_success 
      on_start   = var.email_notify_on_start 
      on_failure = var.email_notify_on_failure 
    }


  }
}
