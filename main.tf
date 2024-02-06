resource "google_storage_bucket" "CarbonCopyTestBucket" {
  name                     = "Test"
  project                  = "carbonme"
  location                 = "US"
  force_destroy            = true
  public_access_prevention = "enforced"
}