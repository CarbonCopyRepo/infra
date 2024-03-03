resource "google_compute_network" "vpc_network" {
  project = "CarbonCopy"
  name = "vpc-network"
  auto_create_subnetworks = true
}

resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "carbon_copy_storage_bucket" {
  name          = "${random_id.bucket_prefix.hex}-bucket-tfstate"
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}