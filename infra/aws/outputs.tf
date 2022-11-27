output "my_ip" {
  description = "IP address of the deployer host. Can be used to e.g. scope caller Security Groups"
  value       = "${chomp(data.http.my_ip.response_body)}/32"
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.public.*.id
}
