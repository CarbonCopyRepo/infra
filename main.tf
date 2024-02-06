resource "google_storage_bucket" "carbon-copy_bucket_test123223" {
  name                     = "Test"
  project                  = "carbonme"
  location                 = "US"
  force_destroy            = true
  public_access_prevention = "enforced"
}