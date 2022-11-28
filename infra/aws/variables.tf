locals {
  my_ip_cidr = "${chomp(data.http.my_ip.response_body)}/32"

  default_tags = {
    source = "https://github.com/ryapric/home-stuff"
  }
}

variable "instance_type" {
  description = "AWS EC2 instance type"
  type        = string
  default     = "t3a.micro" # https://aws.amazon.com/ec2/instance-types/
}

variable "keypair_local_file_pubkey" {
  description = "Local path to the SSH pubkey to use for your EC2 keypair"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "keypair_name" {
  description = "Name of SSH Keypair used to connect to the instance"
  type        = string
  default     = ""
}

variable "name_tag" {
  description = "Tag value to be used for 'Name' fields"
  type        = string
  default     = "home-stuff"
}

variable "use_spot_instance" {
  description = "Whether or not to use EC2 Spot Instances"
  type        = bool
  default     = true
}

# variable "user_data_string" {
#   description = "Command(s) to be run at first boot. If more than a single command, consider passing the 'user_data_filepath' variable instead"
#   type        = string
#   default     = <<-EOF
#     #!/usr/bin/env bash
#     rm -rf /etc/salt/pki/
#     salt-call state.apply
#   EOF
# }

# variable "user_data_filepath" {
#   description = "Path to file containing a user data script to be run at first boot"
#   type        = string
#   default     = ""
# }

variable "volume_size" {
  description = "Size of root volume, in GiB"
  type        = number
  default     = 16
}
