# CI is setup via github actions. anything pushed to main *WILL* be reflected in GCP. be careful not to charge my credit card please!


## Style Guide
* Followed these guides
    * https://www.hashicorp.com/resources/terraform-repository-best-practices
    * https://cloud.google.com/docs/terraform/best-practices-for-terraform

### File structure:
* main.tf
    * Provider and terraform blocks
* variables.tf - self explanatory
* resources.tf
    * Actual cloud resources code. Can be separated by logical resource if file gets too big
* outputs.tf
    * Allow resource attributes be applied to outside world
* modules.tf
    * Holds all of the modules

### Naming
* Name all configurations/objects in snake_case (i.e resource "resource" resource_name)
* Make names singular
* Don't include resource type in the name
* Name singleton resource as "main"



#### Work in progress:
  * Reasonable file structure
  * Variables
  * Actual container setup
  * Store state files in storage bucket


#### Documentation collected:
* https://developer.hashicorp.com/terraform/tutorials/cli
    * Terraform docs
* https://www.youtube.com/watch?v=0PwvhWa3OOY 
    * Followed along with this tutorial to setup CI pipeline with GCP
* https://cloud.google.com/docs/terraform/resource-management/managing-infrastructure-as-code#granting_permissions_to_your_cloud_build_service_account
    * More in-depth docs. Store in storage bucket, etc
