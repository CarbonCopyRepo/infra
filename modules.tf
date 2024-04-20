module "kubernetes_frontend_deployment" {
  source = "./modules/kubernetes"

  docker_image_path       = "${var.artifact_registry}/${var.project_id}/${var.frontend_image_name}:${var.tag}"
  kubernetes_cluster_name = "cc-frontend"
}
