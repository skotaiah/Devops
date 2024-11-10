provider "aws" {
    region = "us-east-1"
    
  
}


resource "aws_key_pair" "test1" {
    key_name   = "deployer-key"
  public_key ="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDLTC5QXqibMOyt1P1ocYkwRsqzjm8JBDRTIX5zHXUWwQbRgyctHdxgVeuhgnbGV/hPtYYleetcFQz8JJK4iFvzqT5XbG+ga00jn+k4LeCjzl8TmU7zlFPwxqwD9krr17go/4oTV/eM6q4lXp4Cc3c96HwqQoGBXxoEHq9NqxPIOmifVJ2buV/jJanI4fL43S57sGUAiVsQbdFen6WbwsoTj07u+JgjvbJ9RfbtAJCp7Ev8bdI5lycWA3N6MvPdMfc3mi95JCxiZAPTKX/ySf+LIDDIZhxPE/budlOiukj6vCViA5/ZqH1CovnzPnyyIKBEXx+1f7GEMUPX44H/8MxcNq2wXkQt2WYY8LtQEJzYu3rDb/FoXaKdWrrySmZhb/hcetqg3oQvdSRF2RIdC17h+d46SqsjwHhZ5itGpSY602XhuCm2tc6DthS/9DhRZXudpIg+GWfZcTK6spa/62a1e4N1QZGI/ya9LeHw/Y6c8lSxAanlC5xE5A8g2e1BwOk= kotai@KotaiahS"
  
}

resource "aws_vpc" "docker" {
    cidr_block = "10.0.0.0/16"
  
}

resource "aws_subnet" "koti" {
    vpc_id = aws_vpc.docker.id
    availability_zone = "us-east-1a"
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = true
  
}

resource "aws_security_group" "dockersg" {
     name = "dockersg"
     vpc_id = aws_vpc.docker.id

     ingress {
        description = " allow SSH"
        to_port = 22
        from_port = 22
        cidr_blocks = [ "0.0.0.0/0" ]
        protocol = "TCP"
     }

     egress {
        description = "allow outbond"
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = [ "0.0.0.0/0" ]
     }
  
}
   
resource "aws_internet_gateway" "docker" {
    vpc_id = aws_vpc.docker.id
      
}

resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.docker.id

    route {

        gateway_id = aws_internet_gateway.docker.id
        cidr_block = "0.0.0.0/0"
    }

     
}

resource "aws_route_table_association" "docker" {
    subnet_id = aws_subnet.koti.id
    route_table_id = aws_route_table.rt.id
  
}
 

resource "aws_instance" "test8" {
    ami = "ami-0866a3c8686eaeeba"
    instance_type = "t2.micro"
    key_name = aws_key_pair.test1.id
    subnet_id = aws_subnet.koti.id
    vpc_security_group_ids = [ aws_security_group.dockersg.id ]
    user_data = base64encode(file("docker.sh"))


      
}

resource "aws_instance" "test9" {
    ami = "ami-0866a3c8686eaeeba"
    instance_type = "t2.micro"
    key_name = aws_key_pair.test1.id
    subnet_id = aws_subnet.koti.id
    vpc_security_group_ids = [ aws_security_group.dockersg.id ]
    user_data = base64encode(file("docker.sh"))
}

resource "aws_instance" "test10" {
    ami = "ami-0866a3c8686eaeeba"
    instance_type = "t2.micro"
    key_name = aws_key_pair.test1.id
    subnet_id = aws_subnet.koti.id
    vpc_security_group_ids = [ aws_security_group.dockersg.id ]
    user_data = base64encode(file("docker.sh"))

}


  

