##################################################################################
# DATA
##################################################################################

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

