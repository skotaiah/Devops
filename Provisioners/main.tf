provider "aws" {
    region = "us-east-1"
 
}

variable "instance_type" {
    default = "t2.micro"
  
}

variable "ami_value" {
    default = "ami-0a5c3558529277641"
  
}


variable "cidr" {
    default = "10.0.0.0/16"
  
}

# create key pair

resource "aws_key_pair" "koti1" {
    key_name = "koti"
    public_key = file("~/.ssh/id_rsa.pub")
      
}

resource "aws_vpc" "koti" {
    cidr_block = var.cidr
  
}

resource "aws_subnet" "koti" {
    vpc_id = aws_vpc.koti.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
  
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.koti.id

  
}

resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.koti.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
 }

 resource "aws_route_table_association" "rta1" {
    subnet_id = aws_subnet.koti.id
    route_table_id = aws_route_table.rt.id
   
 }

 resource "aws_security_group" "koti" {
    name = "web"
    vpc_id = aws_vpc.koti.id

    ingress {
        description = "http from VPC"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]

    }

    ingress {

        description = "ssh from VPC"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress {
        description = "allow outbond traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [ "0.0.0.0/0" ]

    }

    
 }

 resource "aws_instance" "test7" {
    instance_type = var.instance_type
    key_name = aws_key_pair.koti1.id
    ami = var.ami_value
    vpc_security_group_ids = [ aws_security_group.koti.id ]
    subnet_id = aws_subnet.koti.id

    connection {
        type = "ssh"
        user = "ec2-user"
        private_key = file("~/.ssh/id_rsa")
        host = self.public_ip
              
    }

    provisioner "file" {
        source = "app.py"
        destination = "/home/ec2-user/app.py"
      
    }
   
   provisioner "remote-exec" {
    inline = [ 
       "echo 'Hello from the remote instance'",
      "sudo apt update -y",  # Update package lists (for ubuntu)
      "sudo apt-get install -y python3-pip",  # Example package installation
      "cd /etc/ec2-user",
      "sudo pip3 install flask",
      "sudo python3 app.py &",

     ]
     
   }
 }



