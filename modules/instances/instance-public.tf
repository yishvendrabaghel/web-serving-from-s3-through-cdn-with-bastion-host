resource "aws_instance" "public-ec2" {
  ami           = var.pub-ami
  instance_type = var.pub-ins_type
  key_name      = var.ec2_key_name
  subnet_id     = var.public-subnet.id
  vpc_security_group_ids = [aws_security_group.sg-for-pub-ec2.id]
  tags = {
    Name = var.name-pub
  } 
}


resource "tls_private_key" "pub-k" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "tf-pub-key" {
  key_name   = var.ec2_key_name
  public_key = file("~/.ssh/id_rsa.pub")

}
output "public_ip" {
  value = aws_instance.public-ec2.public_ip
}

output "pub_private_ip" {
  value = aws_instance.public-ec2.private_ip
}

locals {
  public_ip = aws_instance.public-ec2.public_ip
  }

resource "local_file" "ip_addresses" {
  content = "Public IP: ${local.public_ip}"
  filename = "pub_ip_addresses.txt"
}