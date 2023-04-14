#################  output #############
output "databricks_host" {
  value = "https://${azurerm_databricks_workspace.this.workspace_url}/"
  depends_on = [
    azurerm_databricks_workspace.this
  ]
}

output "databricks_workspace_id" {
  value = azurerm_databricks_workspace.this.id
  depends_on = [
    azurerm_databricks_workspace.this
  ]
}
