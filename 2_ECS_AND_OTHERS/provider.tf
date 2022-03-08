provider "aws" {
  region  = var.region
  profile = "sahidboss"
}

terraform {
  backend "s3" {}
}
