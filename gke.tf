resource "google_container_cluster" "primary" {
  name     = var.platform_name
  location = var.zone
  # TODO Change before merge to 4
  initial_node_count = 1
  network            = module.gcp-network.network_name
  subnetwork         = module.gcp-network.subnets_names[index(module.gcp-network.subnets_names, local.subnet_name)]
  min_master_version = var.kubernetes_version
  resource_labels    = { "project" : "${var.platform_name}" }
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
    # TODO Change before merge
    preemptible  = true
    machine_type = "custom-2-10240"
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

resource "google_container_node_pool" "workload_node_pool" {
  name       = "workload-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name
  node_count = var.min_node_count
  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  node_config {
    preemptible  = var.is_preemptible
    machine_type = var.machine_type
    metadata = {
      disable-legacy-endpoints = "true"
    }
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
