module "address" {
  source           = "terraform-google-modules/address/google"
  project_id       = var.project_id
  global           = true
  region           = var.region
  enable_cloud_dns = false
  names            = ["${var.platform_name}-public-ip"]
}
