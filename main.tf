resource "google_storage_bucket" "carbon_copy_bucket_test1" {
  name                     = "Test"
  project                  = "carbonme"
  location                 = "US"
  force_destroy            = true
  public_access_prevention = "enforced"
}