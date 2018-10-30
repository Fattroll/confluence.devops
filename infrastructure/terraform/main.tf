provider "google" {
  project = "confluence-220616"
  region = "us-east1"
  zone = "us-east1-c"
}

resource "google_compute_instance_template" "application_instance_template" {
  name_prefix  = "instance-template-"
  machine_type = "f1-micro"

  disk {
    source_image = "cos-cloud/cos-stable"
    auto_delete  = true
    boot         = true
    }

  // networking
  network_interface {
    subnetwork = "${google_compute_subnetwork.group1.self_link}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_group_manager" "instance_group_manager" {
  name               = "instance-group-manager"
  instance_template  = "${google_compute_instance_template.application_instance_template.self_link}"
  base_instance_name = "application-instance"
  target_size        = "1"
}

resource "google_compute_instance" "jenkins-instance" {
  name         = "jenkins"
  machine_type = "f1-micro"
  tags = ["jenkins", "container"]
  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }
  network_interface {
    subnetwork = "${google_compute_subnetwork.group1.self_link}"
    access_config = {
    }
  }
}

resource "google_compute_instance" "bastion-instance" {
  name         = "bastion"
  machine_type = "f1-micro"
  tags = ["bastion", "bash", "side"]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    subnetwork = "${google_compute_subnetwork.group1.self_link}"
    access_config = {
    }
  }
  #metadata_startup_script = <<SCRIPT
  #echo "Hello, World" > index.html
  #nohup busybox httpd -f -p 8080 &
  #SCRIPT
}

resource "google_compute_instance" "worker-instance" {
  name         = "worker"
  machine_type = "f1-micro"
  tags = ["bash", "side"]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  network_interface {
    subnetwork = "${google_compute_subnetwork.group1.self_link}"
    access_config = {
    }
  }
}

resource "google_sql_database_instance" "master" {
  database_version = "POSTGRES_9_6"

  settings {
    tier = "db-f1-micro"
  }
}
