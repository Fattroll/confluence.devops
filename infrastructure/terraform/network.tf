

resource "google_compute_network" "application_network" {
  name                    = "confluence-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "group1" {
  name                     = "${var.name}-network"
  ip_cidr_range            = "${var.network-ip}"
  network                  = "${google_compute_network.application_network.self_link}"
  #private_ip_google_access = true
}

resource "google_compute_firewall" "ssh" {
  name    = "internal-allow-ssh"
  network = "${google_compute_network.application_network.name}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["${var.network-ip}"]
}

resource "google_compute_firewall" "web" {
  name    = "internal-allow-www"
  network = "${google_compute_network.application_network.name}"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["${var.network-ip}"]
}

resource "google_compute_firewall" "bastion-ssh" {
  name    = "external-allow-ssh"
  network = "${google_compute_network.application_network.name}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["bastion"]
}
resource "google_compute_global_forwarding_rule" "http" {
  #project    = "${var.project}"
  name       = "${var.name}"
  target     = "${google_compute_target_http_proxy.default.self_link}"
  ip_address = "${google_compute_global_address.default.address}"
  port_range = "80"
  depends_on = ["google_compute_global_address.default"]
}

resource "google_compute_global_address" "default" {
  #project    = "${var.project}"
  name       = "${var.name}-address"
}

resource "google_compute_target_http_proxy" "default" {
  #project = "${var.project}"
  name    = "${var.name}-http-proxy"
  url_map = "${google_compute_url_map.default.self_link}"
}

resource "google_compute_url_map" "default" {
  #project         = "${var.project}"
  name            = "${var.name}-url-map"
  default_service = "${google_compute_backend_service.default.self_link}"
}

resource "google_compute_backend_service" "default" {
  #project         = "${var.project}"
  name            = "${var.name}-backend"
  port_name       = "http"
  protocol        = "HTTP"
  timeout_sec     = "10"
  backend {
    group = "${google_compute_instance_group_manager.instance_group_manager.instance_group}"
  }
  #security_policy = "${var.security_policy}"
  enable_cdn      = false
  health_checks = ["${google_compute_http_health_check.default.self_link}"]
}

resource "google_compute_http_health_check" "default" {
  name               = "test"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}
