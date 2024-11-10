provider "aws" {
    region = var.region_value
    secret_key = var.secret_key
    access_key = var.access_key_value
  
}

resource "aws_instance" "koti" {
    ami = var.ami_value
    instance_type = var.aws_instance_type
  
}

