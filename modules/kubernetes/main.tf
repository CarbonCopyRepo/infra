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
          image = var.docker_image_path
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
