terraform {
 backend "gcs" {
   bucket  = carbon-copy-storage-bucket
   prefix  = "terraform/state"
 }
}
