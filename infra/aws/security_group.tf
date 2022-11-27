resource "aws_security_group" "main" {
  description = var.name_tag
  name        = var.name_tag
  vpc_id      = aws_vpc.main.id

  tags = merge(
    { Name = var.name_tag },
    local.default_tags
  )
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  description       = "Allow all"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "ping" {
  type              = "ingress"
  description       = "Ping from deployer IP"
  from_port         = 8
  to_port           = 0
  protocol          = "icmp"
  cidr_blocks       = [local.my_ip_cidr]
  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "deployer_ssh" {
  type              = "ingress"
  description       = "SSH from deployer IP"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [local.my_ip_cidr]
  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "pihole_dns" {
  for_each = toset(["tcp", "udp"])

  type              = "ingress"
  description       = "PiHole access for DNS (${each.value})"
  from_port         = 53
  to_port           = 53
  protocol          = each.value
  cidr_blocks       = [local.my_ip_cidr]
  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "pihole_web" {
  type              = "ingress"
  description       = "PiHole access for web console"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = [local.my_ip_cidr]
  security_group_id = aws_security_group.main.id
}
