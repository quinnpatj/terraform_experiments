terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

module "webserver_01" {
  source        = "./modules/webserver/"
  student_alias = var.student_alias
}

#module "webserver_02" {
#  source = "./modules/webserver/"
#  #region        = "us-east-2"
#  student_alias = var.student_alias
#}
