output "VPC-ID-EU-CENTRAL-1" {
  value = aws_vpc.vpc_master.id
}

output "aws_instance_public_ip" {
  value = aws_instance.nginx.public_ip
}

output "aws_instance_public_dns" {
  value = aws_instance.nginx.public_dns
}
