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


/*
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

# This configuration creates a kubernetes cluster on GCP
# named "primary" and the autopilot mode ensures that
# GCP manages all the underlying GKE infrastructure.
resource "google_container_cluster" "primary" {
  name     = "cc-frontend-primary"
  location = "us-west1"

  enable_autopilot = true

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

}

provider "kubernetes" {
  host  = "https://${google_container_cluster.primary.endpoint}"
  token = data.google_client_config.default.access_token

  client_certificate     = base64decode(google_container_cluster.primary.master_auth[0].client_certificate)
  client_key             = base64decode(google_container_cluster.primary.master_auth[0].client_key)
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}

data "google_client_config" "default" {}

# This file specifies what should be run on the GKE
# cluster - the docker image, the # of replicas etc.
resource "kubernetes_deployment" "cc-frontend" {
  metadata {
    name = "cc-frontend-deploy"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        App = "cc-frontend"
      }
    }

    template {
      metadata {
        labels = {
          App = "cc-frontend"
        }
      }

      spec {
        container {
          image = "${var.artifact_registry}/${var.project_id}/${var.frontend_image_name}:${var.tag}"
          name  = "cc-frontend"

          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

# This file exposes the backend as a service to
# be accessible to the outside world
resource "kubernetes_service" "cc-frontend" {
  metadata {
    name = "cc-frontend"
  }

  spec {
    selector = {
      App = "cc-frontend"
    }

    type = "LoadBalancer"

    port {
      port        = 3000 # External traffic comes in on this port
      target_port = 3000 # Traffic to the pods is routed on this port
    }
  }
}
