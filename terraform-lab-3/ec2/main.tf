 #Create Key Pair
resource "aws_key_pair" "test_ssh_key" {
  key_name   = "testing_ssh_key1"
  public_key = file(var.ssh_public_key)
}

#Create Instance with Key Name
#Public Instance on us-east-1a
resource "aws_instance" "my_vm" {
  ami                         = var.my_ami
  instance_type               = var.my_instance_type
  subnet_id                   = var.subnet1
  vpc_security_group_ids      = [aws_default_security_group.default_sec_group.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.test_ssh_key.key_name
  user_data                   = file("entry-script.sh")
  tags = {
    Name = "EC2 Public Subnet 1a"
  }

}

#Public Instance on us-east-1b
resource "aws_instance" "my_vm2" {
  ami                         = var.my_ami
  instance_type               = var.my_instance_type
  subnet_id                   = var.subnet2
  vpc_security_group_ids      = [aws_default_security_group.default_sec_group.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.test_ssh_key.key_name
  user_data                   = file("entry-script.sh")
  tags = {
    Name = "EC2 Public Subnet 1b"
  }


  #Provisioner
  connection {
    type = "ssh"
    # bastion_user = "ubuntu"
    # bastion_host = aws_instance.bastion.public_ip
    user        = "ec2-user"
    host        = self.public_ip
    private_key = file("~/.ssh/test_rsa")
    timeout     = "60s"
  }

  provisioner "local-exec" {
    command = "echo public-ip1 ${aws_instance.my_vm.public_ip} $'\n' public-ip2 ${aws_instance.my_vm2.public_ip} >> all-ips.txt"
  }
}

#Private Instance on us-east-1a
resource "aws_instance" "my_vm3" {
  ami                         = var.my_ami
  instance_type               = var.my_instance_type
  subnet_id                   = var.subnet3
  vpc_security_group_ids      = [aws_default_security_group.default_sec_group.id]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.test_ssh_key.key_name
  user_data                   = file("entry-script.sh")
  tags = {
    Name = "EC2 Private Subnet 1a"
  }
}
#Private Instance on us-east-1b
resource "aws_instance" "my_vm4" {
  ami                         = var.my_ami
  instance_type               = var.my_instance_type
  subnet_id                   = var.subnet4
  vpc_security_group_ids      = [aws_default_security_group.default_sec_group.id]
  associate_public_ip_address = false
  key_name                    = aws_key_pair.test_ssh_key.key_name
  user_data                   = file("entry-script.sh")
  tags = {
    Name = "EC2 Private Subnet 1b"
  }

}

#Create SG
resource "aws_default_security_group" "default_sec_group" {
  vpc_id =var.vpc


  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks =["0.0.0.0/0"] 
  }

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
   cidr_blocks =["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
   cidr_blocks =["0.0.0.0/0"] 
  }

  
  tags = {
    Name = "MyInstanceSecuirtyGroup"
  }





}