output "databricks_secret_scope_name" {
  value = databricks_secret_scope.this.name
}


output "databricks_repo_id" {
  value = databricks_repo.nutter_in_home.id
}

output "databricks_cluster_id" {
  value = databricks_cluster.this.id
}

output "databricks_instance_pool_id" {
  value = databricks_instance_pool.smallest_nodes.id
}


output "databricks_job_id" {
  value = databricks_job.name_of_my_job.id
}


output "databricks_cluster_policy_id" {
  value = databricks_cluster_policy.this.id
}
