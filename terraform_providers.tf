provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zones[0]
}
