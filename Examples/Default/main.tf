provider "aws" {
  region  = "us-east-1"
  profile = "default"
}

module "example" {
  source = "../.."

  name = "example"
  tags = { Name = "example" }
}