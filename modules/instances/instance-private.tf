resource "aws_instance" "private-ec2" {
  ami           = var.pvt-ami
  instance_type = var.pvt-ins_type
  key_name      = aws_key_pair.tf-pvt-key.key_name
  subnet_id     = var.private-subnet.id
  iam_instance_profile = var.role-name
  vpc_security_group_ids = [aws_security_group.sg-for-pvt-ec2.id]
  user_data     = filebase64("./script.sh")
  tags = {
    Name = var.name-pvt
  } 
}
resource "tls_private_key" "pvt-k" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "tf-pvt-key" {
  key_name   = var.ec2_pvt-keyname # Create a "tfKey" to AWS!!
  public_key = tls_private_key.pvt-k.public_key_openssh

  provisioner "local-exec" { # Create a "tfKey.pem" to your computer!!
    command = "echo '${tls_private_key.pvt-k.private_key_pem}' > ./new_Key.pem"
  }
}

resource "null_resource" "delete_pem_key" {
  triggers = {
    pem_key_exists = fileexists("./new_Key.pem")
  }

  provisioner "local-exec" {
    command = "rm ./new_Key.pem"
    when    = destroy
  }
}

output "pvt_private_ip" {
  value = aws_instance.private-ec2.private_ip
}

locals {
  private_ip= aws_instance.private-ec2.private_ip
}
resource "local_file" "pvt_ip_addresses" {
  content = "Private IP: ${local.private_ip}"
  filename = "pvt_ip_addresses.txt"
}