locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Service     = "devOps"
    Owner       = "marcsamdev"
    environment = "development"
    managedwith = "terraform"
  }
  admin_username = "elite"
}