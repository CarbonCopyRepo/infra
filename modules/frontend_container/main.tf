# This was the code for creating a GCP container running a docker image. No longer using.
/*
resource "google_compute_network" "vpc_network" {
  project                 = var.project_id
  name                    = "vpc-ntwork"
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "ssh" {
  name          = "allow-ssh"
  project       = var.project_id
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

resource "google_compute_firewall" "allow_http_https" {
  name          = "allow-http-https"
  project       = var.project_id
  network       = google_compute_network.vpc_network.id
  target_tags   = ["allow-http", "allow-https"]
  source_ranges = ["0.0.0.0/0"]
  priority      = 1000

  allow {
    protocol = "tcp"
    ports    = ["443", "80"]
  }
}

resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "carbon_copy_storage_bucket" {
  name          = "bucket-tfstate-415616"
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  project       = var.project_id
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket" "data_storage_bucket" {
  name          = "carbon-copy-data-store-bucket"
  location      = "US"
  force_destroy = false
  storage_class = "STANDARD"
  project       = var.project_id
  versioning {
    enabled = true
  }
}


resource "google_compute_instance" "frontend_container" {
  name                      = var.frontend_image_name
  description               = "Compute engine for the frontend"
  zone                      = var.zone
  machine_type              = "e2-micro"
  project                   = var.project_id
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "gcr.io/carbonme/frontend-container-repo/carbon-copy-frontend:latest"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.id

    access_config {

    }
  }

  tags = ["http-server", "https-server"]

  metadata_startup_script = <<-EOF
    #!/bin/bash
    docker pull gcr.io/${var.project_id}/${var.frontend_image_name}:latest
    docker run -d -p 80:80 gcr.io/${var.project_id}/${var.frontend_image_name}:latest
  EOF

}
*/
