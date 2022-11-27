# TODO: add support for non-Spot instances?

resource "aws_spot_instance_request" "main" {
  count = var.use_spot_instance ? 1 : 0

  # Assumes that you're not running this for jobs, but for long-lived services
  instance_interruption_behavior = "stop"
  spot_type                      = "persistent"
  wait_for_fulfillment           = true

  ami                    = data.aws_ami.latest.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.main.key_name
  subnet_id              = aws_subnet.public.id
  user_data              = file("../config/scripts/main.sh")
  vpc_security_group_ids = [aws_security_group.main.id]

  # To prevent unexpected shutdown of t3-family Spot instances
  credit_specification {
    cpu_credits = "standard"
  }

  root_block_device {
    volume_size = var.volume_size
  }

  tags = merge(
    { Name = var.name_tag },
    local.default_tags
  )

  # Need this to apply tags to actual instances, since this resource can't do that itself
  provisioner "local-exec" {
    command = <<-EOF
      aws ec2 create-tags \
        --resources ${self.spot_instance_id} \
        --tags \
          Key=Name,Value=${var.name_tag} \
          Key=spot_request_id,Value=${self.id}
    EOF
  }

  connection {
    host        = self.public_ip
    private_key = file(pathexpand(var.keypair_local_file))
    user        = "admin"
  }

  # # Set up Salt tree for configmgmt
  # provisioner "local-exec" {
  #   command = <<-EOF
  #     if [ '${var.app_name}' = 'configmgmt' ]; then
  #       until scp -i ${pathexpand(var.keypair_local_file)} -o StrictHostKeyChecking=no -r ../../salt admin@${self.public_ip}:/tmp; do
  #         printf 'Waiting for SSH connection...\n'
  #         sleep 1
  #       done
  #     fi
  #   EOF
  # }

  # provisioner "remote-exec" {
  #   inline = [<<-EOF
  #     export app_name='${var.app_name}'
  #     export configmgmt_address='10.0.1.10'
  #     [ -d /tmp/salt ] && sudo cp -r /tmp/salt/* /srv/
  #     sudo -E bash /usr/local/baseimg/scripts/run/main.sh
  #   EOF
  #   ]
  # }
}

resource "aws_key_pair" "main" {
  key_name   = var.name_tag
  public_key = file(pathexpand(var.keypair_local_file))

  tags = merge(
    { Name = var.name_tag },
    local.default_tags
  )
}

resource "aws_eip" "main" {
  depends_on = [aws_internet_gateway.main] # provider docs say to do this to be safe

  vpc = true

  tags = merge(
    { Name = var.name_tag },
    local.default_tags
  )
}

resource "aws_eip_association" "main" {
  allocation_id = aws_eip.main.id
  instance_id   = var.use_spot_instance ? aws_spot_instance_request.main[0].spot_instance_id : null
}
