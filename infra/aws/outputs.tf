output "my_ip" {
  description = "IP address of the deployer host. Can be used to e.g. scope caller Security Groups"
  value       = "${chomp(data.http.my_ip.response_body)}/32"
}

output "public_ip" {
  description = "Public IP address of the server instance, possibly independent of any EIP"
  value       = aws_spot_instance_request.main[0].public_ip
}

output "public_subnet_id" {
  value = aws_subnet.public.*.id
}

output "static_ip" {
  description = "AWS EIP of the server instance"
  value       = aws_eip.main.public_ip
}

output "vpc_id" {
  value = aws_vpc.main.id
}
