output "VPC-ID-EU-CENTRAL-1" {
  value = aws_vpc.vpc.id
}

output "aws_instance_public_ip" {
  value = aws_instance.nginx1.public_ip
}

output "aws_instance_public_dns" {
  value = aws_instance.nginx1.public_dns
}

output "aws_elb_public_dns" {
  value = aws_elb.web.dns_name
}
