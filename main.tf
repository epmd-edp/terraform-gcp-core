locals {
  network_name           = "${var.platform_name}-network"
  subnet_name            = "${var.platform_name}-subnet"
  master_auth_subnetwork = "${var.platform_name}-master-subnet"
  router_name            = "${var.platform_name}-router"
  cloud_nat_name         = "${var.platform_name}-nat"
  pods_range_name        = "ip-range-pods"
  svc_range_name         = "ip-range-svc"
}
