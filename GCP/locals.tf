locals {
  databricks_configs = yamldecode(file("input.yaml"))

   databrick_users = { 
    for obj in local.databricks_configs.users : obj.email => obj
  }

}
