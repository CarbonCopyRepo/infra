resource "google_storage_bucket" "test-bucket" {
  name                     = "carbon_copy_bucket_test1"
  project                  = "carbonme"
  location                 = "US"
  force_destroy            = true
  public_access_prevention = "enforced"
}