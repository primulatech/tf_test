##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

# provider "aws" {
#  profile = var.profile
#   region  = var.region-master
#  alias   = "region-master"
# }


##################################################################################
# NETWORKS AND SGs
##################################################################################

#This uses the default VPC.  It WILL NOT delete it on destroy.
resource "aws_default_vpc" "default" {

}

#Create VPC
resource "aws_vpc" "vpc" {
#  provider             = aws.region
  cidr_block           = var.network_address_space
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(local.common_tags, { Name = "${var.environment_tag}-vpc" })
 
}

resource "aws_internet_gateway" "igw" {
#  provider = aws.region
  vpc_id = aws_vpc.vpc.id
 tags = merge(local.common_tags, { Name = "${var.environment_tag}-vpc" })
 }

#Create subnet #1 and subnet # 2

resource "aws_subnet" "subnet1" {
#  provider          = aws.region
  cidr_block              = var.subnet1_address_space
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.azs.names[0]
  tags = merge(local.common_tags, { Name = "${var.environment_tag}-subnet1" })
}

resource "aws_subnet" "subnet2" {
#  provider          = aws.region
  cidr_block              = var.subnet2_address_space
  vpc_id                  = aws_vpc.vpc.id
  map_public_ip_on_launch = "true"
  availability_zone       = data.aws_availability_zones.azs.names[1]
  tags = merge(local.common_tags, { Name = "${var.environment_tag}-subnet2" })
}

# ROUTING #
resource "aws_route_table" "internet_route" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(local.common_tags, { Name = "${var.environment_tag}-rtb" })
}

resource "aws_route_table_association" "rta-subnet1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.internet_route.id
}

resource "aws_route_table_association" "rta-subnet2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.internet_route.id
}


#Create SG for allowing TCP/8080 from * and TCP/22 from your IP in us-east-1
resource "aws_security_group" "allow_ssh" {
  name        = "nginx_demo"
  description = "Allow TCP/80 & TCP/22"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "Allow 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }
  ingress {
    description = "Allow 80 from our public IP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.network_address_space]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 tags = merge(local.common_tags, { Name = "${var.environment_tag}-elb" })
}

resource "aws_security_group" "elb-sg" {
  name        = "nginx_elb_sg"
  description = "Allow http only"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    description = "Allow 80 from everywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 tags = merge(local.common_tags, { Name = "${var.environment_tag}-nginx" })
}

