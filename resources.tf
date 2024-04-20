# Create service account for kubernetes
resource "google_service_account" "kube-cluster" {
  # TODO: Replace with unique identifier such as email ?
  account_id   = "kube-cluster"
  display_name = "Carbon Copy Kube Admin"
  project      = var.project_id
}


# Grant roles to the service account
# Allow to administer GKE clusters
resource "google_project_iam_member" "cluster_admin" {
  member  = "serviceAccount:${google_service_account.kube-cluster.email}"
  project = var.project_id
  role    = "roles/container.admin"
}

# Allow to view compute resources
resource "google_project_iam_member" "compute_viewer" {
  member  = "serviceAccount:${google_service_account.kube-cluster.email}"
  project = var.project_id
  role    = "roles/compute.viewer"
}

# Allow this service account to act as other service accounts
resource "google_project_iam_member" "service_account_user" {
  member  = "serviceAccount:${google_service_account.kube-cluster.email}"
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
}
