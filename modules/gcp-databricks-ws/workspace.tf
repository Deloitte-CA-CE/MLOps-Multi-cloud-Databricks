resource "random_string" "suffix" {
  special = false
  upper   = false
  length  = 6
}
resource "databricks_mws_workspaces" "this" {

  account_id     = var.databricks_account_id
  workspace_name = "${var.prefix_workspace}-${random_string.suffix.result}"
  location       = var.region
  cloud_resource_container {
    gcp {
      project_id = var.google_project
    }
  }

  network_id = var.network_id
  gke_config {
    connectivity_type = "PRIVATE_NODE_PUBLIC_MASTER"
    master_ip_range   = var.master_ip_range  
  }

  token {
    comment = "Terraform"
  }


}


# this should give me the id
data "google_secret_manager_secret" "ws-host" {
  secret_id = var.workspace-host
}

# this should give me the id
data "google_secret_manager_secret" "ws-token" {
  secret_id = var.workspace-token
}

resource "google_secret_manager_secret_version" "set-host" {
  secret = data.google_secret_manager_secret.ws-host.id

  secret_data = databricks_mws_workspaces.this.workspace_url
  depends_on = [
    databricks_mws_workspaces.this
  ]
}

resource "google_secret_manager_secret_version" "set-ws-token" {
  secret = data.google_secret_manager_secret.ws-token.id

  secret_data = databricks_mws_workspaces.this.token[0].token_value
  depends_on = [
    databricks_mws_workspaces.this
  ]
}


output "databricks_host" {
  value = databricks_mws_workspaces.this.workspace_url
}

output "databricks_token" {
  value     = databricks_mws_workspaces.this.token[0].token_value
  sensitive = true
}