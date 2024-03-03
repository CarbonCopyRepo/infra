terraform {
  backend "gcs" {
    bucket = "691274f3e16ef0e4-bucket-tfstate"
    prefix = "terraform/state"
  }
}
