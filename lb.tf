resource "google_compute_global_forwarding_rule" "frontend" {
  name       = "${var.platform_name}-frontend"
  target     = google_compute_target_https_proxy.load_balancer.self_link
  port_range = "443"
  ip_address = module.address.addresses[0]
}

resource "google_compute_target_https_proxy" "load_balancer" {
  name             = "${var.platform_name}-https-proxy"
  url_map          = google_compute_url_map.url_map.self_link
  ssl_certificates = [google_compute_ssl_certificate.wild_cert.self_link]
}

resource "google_compute_ssl_certificate" "wild_cert" {
  name        = "${var.platform_name}-certificate"
  private_key = file("${var.private_key_path}")
  certificate = file("${var.certificate_path}")
}

resource "google_compute_url_map" "url_map" {
  name            = "${var.platform_name}-url-map"
  default_service = google_compute_backend_service.lb-backend.self_link
}

resource "google_compute_health_check" "tcp-health-check" {
  name = "${var.platform_name}-health-check"
  timeout_sec        = 5
  check_interval_sec = 5
  tcp_health_check {
    port = "32767"
  }
}

resource "google_compute_backend_service" "lb-backend" {
  name          = "${var.platform_name}-lb-backend"
  port_name     = "ng-ingress"
  health_checks = [google_compute_health_check.tcp-health-check.self_link]
  backend {
    # TODO define it
    group                   = google_container_cluster.primary.instance_group_urls[0]
  }

}

resource "null_resource" "set_named_port" {
  provisioner "local-exec" {
    command = "gcloud compute instance-groups set-named-ports ${google_container_cluster.primary.instance_group_urls[0]} --named-ports=ng-ingress:32767"
  }
  depends_on = [
    google_container_cluster.primary,
  ]
}
