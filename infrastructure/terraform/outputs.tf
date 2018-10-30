data "google_container_registry_repository" "terraform_reg" {}
output "gcr_location" {
  value = "${data.google_container_registry_repository.terraform_reg.repository_url}"
}
