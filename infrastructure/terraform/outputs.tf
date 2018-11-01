data "google_container_registry_repository" "terraform_reg" {}
output "gcr_location" {
  value = "${data.google_container_registry_repository.terraform_reg.repository_url}"
}
 output "external_ip" {
    value = "${google_compute_instance.nginx-instance.network_interface.0.access_config.0.nat_ip}"
   }
 
