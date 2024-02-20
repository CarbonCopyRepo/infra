terraform {
 backend "gcs" {
   bucket  = carbon_copy_storage_bucket
   prefix  = "terraform/state"
 }
}