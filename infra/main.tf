terraform {
  backend "s3" {}
}

provider "aws" {}

module "home_stuff" {
  source = "./aws"
}
