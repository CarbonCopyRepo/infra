/*
terraform {
 backend "gcs" {
   bucket  = carbon_copy_storage_bucket
   prefix  = "terraform/state"
 }
}
*/

resource "google_compute_network" "vpc_network" {
  project = "CarbonCopy"
  name = "vpc-network"
  auto_create_subnetworks = true
}