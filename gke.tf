resource "google_container_cluster" "primary" {
  name                  = var.platform_name
  location              = var.zones[0]
  initial_node_count    = 1
  network               = module.gcp-network.network_name
  subnetwork            = module.gcp-network.subnets_names[index(module.gcp-network.subnets_names, local.subnet_name)]
  min_master_version        = "1.15.8-gke.3"
  # TODO discuss more parameters
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }
  ip_allocation_policy {
    cluster_secondary_range_name  = local.pods_range_name
    services_secondary_range_name = local.svc_range_name
  }
  addons_config {
    http_load_balancing {
      disabled = true
    }
  }

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  node_config {
    preemptible  = false
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}
