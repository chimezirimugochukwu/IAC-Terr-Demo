# store the terraform state file in s3
terraform {
  backend "s3" {
    bucket    = "group2-nausicaa-global-terraform-state"
    key       = "grants-website-ecs.tfstate"
    region    = "eu-west-1"
    profile   = "default"
  }
}