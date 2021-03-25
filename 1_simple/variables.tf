##################################################################################
# VARIABLES
##################################################################################

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {
  type = string
  default = "~/.ssh/id_rsa_terraform"
}

variable "public_key_path" {
  type = string
  default = "~/.ssh/id_rsa_terraform.pub"
}

variable "key_name" {
  type = string
  default = "docker"
}
variable "region" {
  default = "eu-central-1"
}

variable "profile" {
  type    = string
  default = "terraform"
}

variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
}

variable "instance-type" {
  type    = string
  default = "t3.micro"
}
 