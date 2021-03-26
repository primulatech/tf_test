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
 
variable "network_address_space" {
  default = "10.1.0.0/16"
}
variable "subnet1_address_space" {
  default = "10.1.0.0/24"
}
variable "subnet2_address_space" {
  default = "10.1.1.0/24"
}

variable "bucket_name_prefix" {}
variable "billing_code_tag" {}
variable "environment_tag" {}