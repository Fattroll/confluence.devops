

resource "google_compute_network" "application_network" {
  name                    = "confluence-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "confluence_internal" {
  name                     = "${var.name}-subnetwork"
  ip_cidr_range            = "${var.network-ip}"
  network                  = "${google_compute_network.application_network.self_link}"
}

resource "google_compute_firewall" "external-ssh" {
  name    = "external-allow-ssh"
  network = "${google_compute_network.application_network.name}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["container"]
}

resource "google_compute_firewall" "internal_web" {
  name    = "internal-allow-web"
  network = "${google_compute_network.application_network.name}"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["${var.network-ip}"]
  target_tags = ["container"]
}
resource "google_compute_firewall" "external_web" {
  name    = "external-allow-web"
  network = "${google_compute_network.application_network.name}"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["nginx"]
}
