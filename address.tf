module "address" {
  source           = "terraform-google-modules/address/google"
  project_id       = var.project_id
  global = true
  region = var.region
  enable_cloud_dns = false
#   dns_domain       = var.domain
#   dns_managed_zone = module.dns-public-zone.name
#   dns_project      = var.project_id
  names            = ["test-edp-public-ip"]
#   dns_short_names  = ["test"]
}