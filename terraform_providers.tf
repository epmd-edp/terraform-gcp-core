provider "google" {
  # credentials = "${file("account.json")}"
  project     = "or2-msq-epm-gcp-pl-dev-t1iylu"
  region      = var.region
  zone        = var.zone
}
