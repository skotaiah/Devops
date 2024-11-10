provider "aws" {
    region = var.region_value
  
}

resource "aws_instance" "koti" {
    ami = var.ami_value
    instance_type = var.aws_instance_type
  
}

