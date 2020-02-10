module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id                 = var.project_id
  name                       = var.platform_name
  region                     = var.region
  regional                   = false
  zones                      = var.zones
  network                    = module.gcp-network.network_name
  subnetwork                 = module.gcp-network.subnets_names[index(module.gcp-network.subnets_names, local.subnet_name)]
  ip_range_pods              = local.pods_range_name
  ip_range_services          = local.svc_range_name
  kubernetes_version         = "1.15.8-gke.2"
  http_load_balancing        = true
  horizontal_pod_autoscaling = false
  # TODO var
  network_policy             = false
  remove_default_node_pool   = true
  enable_private_endpoint    = false
  enable_private_nodes       = true
  master_ipv4_cidr_block     = "172.16.0.0/28"

  master_authorized_networks = [
    # {
    #   cidr_block   = data.google_compute_subnetwork.subnetwork.ip_cidr_range
    #   display_name = "VPC"
    # },
  ]

  node_pools = [
    {
      name               = "${var.platform_name}-node-pool"
      # TODO var
      machine_type       = "n1-standard-1"
      autoscaling        = false
      local_ssd_count    = 0
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      # TODO change
      preemptible        = true
      # TODO var
      node_count         = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    edp-cluster-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_tags = {
    all = []
  }
}
