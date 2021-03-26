##################################################################################
# LOCALS
##################################################################################

locals {
  common_tags = {
    BillingCode = var.billing_code_tag
    Environment = var.environment_tag
  }

  s3_bucket_name = "${var.bucket_name_prefix}-${var.environment_tag}-${random_integer.rand.result}"
}
##################################################################################
# DATA
##################################################################################


#Get all available AZ's in VPC for master region
#data "aws_availability_zones" "azs" {
#  provider = aws.region-master
#  state    = "available"
#}

#Get all AZ's for current region

data "aws_availability_zones" "azs" {}

data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#alternative from SSM Parameters

#Get Linux AMI ID using SSM Parameter endpoint in eu-central-1
#data "aws_ssm_parameter" "linuxAmi" {
#  provider = aws.region
#  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
#}

#Get Ubuntu AMI ID using SSM Parameter endpoint eu-central-1
#data "aws_ssm_parameter" "ubuntuAmi" {
#  provider = aws.region
#  name     = "/aws/service/canonical/ubuntu/server/20.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
#}

#Random ID
resource "random_integer" "rand" {
  min = 10000
  max = 99999
}