terraform {
 backend "gcs" {
   bucket  = "CarbonCopyTerraformStateBucket"
   prefix  = "terraform/state"
 }
}