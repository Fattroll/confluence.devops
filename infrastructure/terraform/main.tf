provider "google" {
  project = "confluence-220616"
  region = "us-east1"
  zone = "us-east1-c"
}

#jenkins instance configuration

resource "google_compute_instance" "jenkins-instance" {
  name         = "jenkins"
  machine_type = "f1-micro"
  tags = ["jenkins", "container"]
  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }
  attached_disk {
    source = "${google_compute_disk.jenkins.self_link}"
  }
  network_interface {
    subnetwork = "${google_compute_subnetwork.confluence_internal.self_link}"
    access_config = {
    }
  }

  metadata {
    gce-container-declaration = "${file("jenkins_container.run")}"
  }
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-rw"]
  }
  depends_on = ["null_resource.jenkins_build_and_push"]
  allow_stopping_for_update = "true"
}

resource "null_resource" "jenkins_build_and_push" {
  provisioner "local-exec" {
    command = "../../docker.img/jenkins/build.sh"
  }
}
resource "google_compute_disk" "jenkins" {
  name  = "jenkins-home"
  type  = "pd-standard"
  size = "10"
}

#nginx configuration

resource "google_compute_instance" "nginx-instance" {
  name         = "nginx"
  machine_type = "f1-micro"
  tags = ["nginx", "container"]
  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }
  network_interface {
    subnetwork = "${google_compute_subnetwork.confluence_internal.self_link}"
    access_config = {
    }
  }

  metadata {
    gce-container-declaration = "${file("nginx_container.run")}"
  }
  service_account {
    scopes = ["userinfo-email", "storage-ro"]
  }
  depends_on = ["null_resource.proxy_build_and_push"]
  allow_stopping_for_update = "true"
}

resource "null_resource" "proxy_build_and_push" {
  provisioner "local-exec" {
    command = "../../docker.img/nginx/build.sh"
  }
}
#Confluence instance configuration

resource "google_compute_instance" "confluence-instance" {
  name         = "confluence"
  machine_type = "f1-micro"
  tags = ["confluence", "container"]
  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }
  attached_disk {
    source = "${google_compute_disk.confluence.self_link}"
  }
  network_interface {
    subnetwork = "${google_compute_subnetwork.confluence_internal.self_link}"
    network_ip = "10.126.0.100"
    access_config = {
    }
  }

  metadata {
    gce-container-declaration = "${file("confluence_container.run")}"
  }
  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-rw"]
  }
  depends_on = ["null_resource.confluence_build_and_push"]
  allow_stopping_for_update = "true"
}

resource "null_resource" "confluence_build_and_push" {
  provisioner "local-exec" {
    command = "../../docker.img/confluence/build.sh"
  }
}
resource "google_compute_disk" "confluence" {
  name  = "confluence-home"
  type  = "pd-standard"
  size = "10"
}

#database configuration

resource "google_sql_database_instance" "master" {
  database_version = "POSTGRES_9_6"

  settings {
    tier = "db-f1-micro"
  }
}
