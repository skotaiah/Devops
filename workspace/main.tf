provider "aws" {
    region = "us-east-1"
    
  
}

variable "ami_value" {
    description = "AMI type"
  
}

variable "instance_type" {
description = "instance type "
type = map(string)

default = {
  "dev" = "t2.micro"
  "stage" = "t3.micro"
  "prod" = "t2.xlarge"
}


}

module "ec2_instance" {
    source = "./module/ec2_instance"
    ami_value = var.ami_value
    instance_type = lookup(var.instance_type, terraform.workspace)
  
}
