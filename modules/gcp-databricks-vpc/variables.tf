

variable "databricks_account_id" {
    default = ""
}

variable "google_project" {
    default = ""
}

variable "prefix_vpc" {
    default = "tf-network"
}

variable "prefix_router" {
    default = "tf-router"
}

variable "prefix_nat" {
    default = "tf-nat"
}

variable "prefix_mws_nw" {
    default = "tf-mwsnw"
}


variable "prefix_subnet" {
    default = "test-dbx"
}

variable "ip_cidr_range" {
    default = "10.0.0.0/16"
}

variable "region" {
    default = "us-east4"
}

variable "secondary_ip_range_name_pods" {
    default = "pods"
}

variable "secondary_ip_range_pods" {
    default = "10.1.0.0/16"
}

variable "secondary_ip_range_name_services" {
    default = "svc"
}

variable "secondary_ip_range_services" {
    default = "10.2.0.0/20"
}
