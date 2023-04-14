# Configure the workspace_dir_path
variable "workspace_dir_path" {
  type    = string
  default = "/DEV"
}

 #Configure the git_username
variable "git_username" {
  type    = string
  default = ""
}
# Configure the git_provider
variable "git_provider" {
  type    = string
  default = ""
}

# Configure the personal_access_token
variable "personal_access_token" {
  type    = string
  default = ""
}

# Configure the path_in_workspace
variable "path_in_workspace" {
  type    = string
  default = "/Repos/DEV/db-repo"
}

# Configure the branch
variable "branch" {
  type    = string
  default = "dev"
}

# Configure the git_url
variable "git_url" {
  type    = string
  default = ""
}

# Configure the node_type_id
variable "node_type_id" {
  type    = string
  default = ""
}

# Configure the databrick_job_name
variable "databrick_job_name" {
  type    = string
  default = ""
}

# Configure the databrick_job_cron
variable "databrick_job_cron" {
  type    = string
  default = ""
}

# Configure the databrick_tz_id
variable "databrick_tz_id" {
  type    = string
  default = ""
}

# Configure the email_notify_on_success
variable "email_notify_on_success" {
  type    = list(string)
  default = []
}

# Configure the email_notify_on_start
variable "email_notify_on_start" {
  type    = list(string)
  default = []
}
# Configure the email_notify_on_failure
variable "email_notify_on_failure" {
  type    = list(string)
  default = []
}

# Configure the job_task_name
variable "job_task_name" {
  type    = string
  default = ""
}
# Configure the job_notebook_task_path
variable "job_notebook_task_path" {
  type    = string
  default = ""
}
