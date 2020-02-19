module "address" {
  source     = "terraform-google-modules/address/google"
  project_id = var.project_id
  # TODO var and with DNS
  global           = true
  region           = var.region
  enable_cloud_dns = false
  # TODO variable
  names = ["test-edp-public-ip"]
}
