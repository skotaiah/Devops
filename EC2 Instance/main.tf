provider "aws" {
    region = var.region_value
    access_key = var.access_key_value
    secret_key = var.secret_key


  
}

resource "aws_instance" "test4" {
    ami = var.ami_value
    instance_type = var.aws_instance_type
      
}