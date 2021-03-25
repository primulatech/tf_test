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


