module "gcp-network" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 2.0"
  project_id   = var.project_id
  network_name = local.network_name

  subnets = [
    {
      subnet_name   = local.subnet_name
      subnet_ip     = "10.0.0.0/17"
      subnet_region = var.region
      subnet_private_access = "true"
    },
    {
      subnet_name   = local.master_auth_subnetwork
      subnet_ip     = "10.60.0.0/17"
      subnet_region = var.region
      subnet_private_access = "true"
    },
  ]

  secondary_ranges = {
    "${local.subnet_name}" = [
      {
        range_name    = local.pods_range_name
        ip_cidr_range = "192.168.0.0/18"
      },
      {
        range_name    = local.svc_range_name
        ip_cidr_range = "192.168.64.0/18"
      },
    ]
  }
}

module "cloud-nat" {
  create_router   = true
  source          = "terraform-google-modules/cloud-nat/google"
  project_id      = "${var.project_id}"
  region          = "${var.region}"
  router          = "${local.router_name}"
  network         = module.gcp-network.network_name
}

# Requires roles/compute.securityAdmin
resource "google_compute_firewall" "iap" {
  name    = "iap-allow"
  network = module.gcp-network.network_name
  source_ranges = ["35.235.240.0/20"]
  allow {
    protocol      = "tcp"
    ports         = ["22"]
  }
}
