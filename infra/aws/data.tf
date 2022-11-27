data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

data "aws_ami" "latest" {
  most_recent = true
  owners      = ["136693071363"] # Debian

  filter {
    name   = "name"
    values = ["debian-11*"]
  }
}

data "http" "my_ip" {
  url = "https://ipv4.icanhazip.com"
}
