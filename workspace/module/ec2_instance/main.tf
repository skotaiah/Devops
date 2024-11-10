provider "aws" {
    region = "us-east-1"
    
  
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

