provider "aws" {
    region = "us-east-1"
    access_key = "AKIAWFIPTCP65WBCF54G"
    secret_key = "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"
  
}

variable "ami_value" {
    description = "AMI type"
  
}

variable "instance_type" {
  
description = "instance type "
}

resource "aws_instance" "test8" {
    ami = var.ami_value
    instance_type = var.instance_type
  
}

