locals {
  project_name = "carbonme"
}

resource "google_compute_network" "vpc_network" {
  project                 = local.project_name
  name                    = "vpc-network"
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "ssh" {
  name          = "allow-ssh"
  project       = local.project_name
  direction     = "INGRESS"
  network       = google_compute_network.vpc_network.id
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]

  allow {
    ports    = ["22"]
    protocol = "tcp"
  }
}

resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "carbon_copy_storage_bucket" {
  name          = "${random_id.bucket_prefix.hex}-bucket-tfstate"
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  project       = local.project_name
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket" "data_storage_bucket" {
  name          = "carbon-copy-data-store-bucket"
  location      = "US"
  force_destroy = false
  storage_class = "STANDARD"
  project       = local.project_name
  versioning {
    enabled = true
  }
}

resource "google_compute_instance" "frontend_container" {
  name                      = "carboncopy-frontend-terraform-container"
  description               = "Compute engine for the frontend"
  zone                      = "us-central1-a"
  machine_type              = "e2-micro"
  project                   = local.project_name
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.id

    access_config {

    }
  }

}