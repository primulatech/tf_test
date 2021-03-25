##################################################################################
# NETWORKS AND SGs
##################################################################################

#This uses the default VPC.  It WILL NOT delete it on destroy.
resource "aws_default_vpc" "default" {

}

#Create VPC in eu-central-1
resource "aws_vpc" "vpc_master" {
#  provider             = aws.region
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-tf_exercise"
  }

}

#Create SG for allowing TCP/8080 from * and TCP/22 from your IP in us-east-1
resource "aws_security_group" "allow_ssh" {
  name        = "nginx_demo"
  description = "Allow TCP/80 & TCP/22"
  vpc_id      = aws_default_vpc.default.id
  ingress {
    description = "Allow 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }
  ingress {
    description = "Allow 80 from our public IP for Jenkins"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


