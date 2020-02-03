locals {
  network_name           = "${var.project_id}-network"
  subnet_name            = "${var.project_id}-subnet"
  master_auth_subnetwork = "${var.project_id}-master-subnet"
  pods_range_name        = "ip-range-pods"
  svc_range_name         = "ip-range-svc"
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = var.project_id
  name                       = var.platform_name
  region                     = var.region
  regional                   = false
  zones                      = var.zones
  network                    = module.gcp-network.network_name
  subnetwork                 = module.gcp-network.subnets_names[index(module.gcp-network.subnets_names, local.subnet_name)]
  ip_range_pods              = local.pods_range_name
  ip_range_services          = local.svc_range_name
  http_load_balancing        = true
  horizontal_pod_autoscaling = false
  network_policy             = false
  remove_default_node_pool   = true

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "n1-standard-1"
      autoscaling        = false
      local_ssd_count    = 0
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = true
      node_count         = 3
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
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

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}
