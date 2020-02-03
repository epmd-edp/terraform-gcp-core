provider "google" {
  credentials = file("../epm-gcp-pl.json")
  project     = var.project_id
  region      = var.region
  zone        = var.zones[0]
}
