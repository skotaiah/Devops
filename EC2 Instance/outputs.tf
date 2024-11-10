output "public_ip_address" {
    value = aws_instance.test4.public_ip
  
}

output "subnet_id" {
    value = aws_instance.test4.subnet_id
  
}

output "key_name" {
    value = aws_instance.test4.key_name
  
}
