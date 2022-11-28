terraform {
  backend "s3" {}
}

provider "aws" {}

module "home_stuff" {
  source = "./aws"
}

output "static_ip" {
  value = module.home_stuff.static_ip
}
