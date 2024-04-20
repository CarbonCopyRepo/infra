variable "docker_image_path" {
  type        = string
  description = "The path of the docker image in Google Artifact Registry (GAR)"
}

variable "kubernetes_cluster_name" {
  type        = string
  description = "Name of kubernetes cluster"
}
