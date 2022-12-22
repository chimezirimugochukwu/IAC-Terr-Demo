# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket    = "ricks876-terraform-remote-state-demo"
    key       = "grants-website-ecs.tfstate"
    region    = "eu-west-1"
    profile   = "default"
  }
}