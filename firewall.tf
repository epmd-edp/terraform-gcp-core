## Requires roles/compute.securityAdmin
## If service account has such permission, uncomment resources bellow
## Otherwise, add the firewall rules manually

# resource "google_compute_firewall" "iap" {
#   name          = "iap-allow"
#   network       = module.gcp-network.network_name
#   source_ranges = ["35.235.240.0/20"]
#   allow {
#     protocol = "tcp"
#     ports    = ["22"]
#   }
# }

# resource "google_compute_firewall" "health-check" {
#   name    = "health-check-allow"
#   network = module.gcp-network.network_name
#   source_ranges = [
#     "35.191.0.0/16",
#     "130.211.0.0/22"
#   ]
#   allow {
#     protocol = "tcp"
#   }
# }
