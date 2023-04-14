resource "random_string" "suffix" {
  special = false
  upper   = false
  length  = 6
}
resource "google_compute_network" "dbx_private_vpc" {
  project                 = var.google_project
  name                    = "${var.prefix_vpc}-${random_string.suffix.result}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = "${var.prefix_subnet}-${random_string.suffix.result}"
  ip_cidr_range = var.ip_cidr_range
  region        = var.region 
  network       = google_compute_network.dbx_private_vpc.id
  secondary_ip_range {
    range_name    = var.secondary_ip_range_name_pods 
    ip_cidr_range = var.secondary_ip_range_pods 
  }
  secondary_ip_range {
    range_name    = var.secondary_ip_range_name_services 
    ip_cidr_range = var.secondary_ip_range_services 
  }
  private_ip_google_access = true
}

resource "google_compute_router" "router" {
  name    = "${var.prefix_router}-${random_string.suffix.result}"
  region  = google_compute_subnetwork.network-with-private-secondary-ip-ranges.region
  network = google_compute_network.dbx_private_vpc.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.prefix_nat}-${random_string.suffix.result}"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "databricks_mws_networks" "this" {

  account_id   = var.databricks_account_id
  network_name = "${var.prefix_mws_nw}-${random_string.suffix.result}"
  gcp_network_info {
    network_project_id    = var.google_project
    vpc_id                = google_compute_network.dbx_private_vpc.name
    subnet_id             = google_compute_subnetwork.network-with-private-secondary-ip-ranges.name
    subnet_region         = google_compute_subnetwork.network-with-private-secondary-ip-ranges.region
    pod_ip_range_name     = var.secondary_ip_range_name_pods
    service_ip_range_name = var.secondary_ip_range_name_services
  }
}