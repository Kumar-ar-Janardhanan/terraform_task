
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow inbound traffic to Apache server"
  vpc_id= var.vpc_id
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "tf_instance_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "private_key_file" {
  content  = tls_private_key.rsa.public_key_pem
  filename = "tf_private_key.pem"
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.web_instance.id
  allocation_id = var.my_eip
}

resource "aws_instance" "web_instance" {
  ami           = "ami-0287a05f0ef0e9d9a" 
  instance_type = "t2.micro" 
  subnet_id = var.public_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name = aws_key_pair.key_pair.key_name
  user_data= <<-EOF
  #! /bin/bash
  sudo apt-get update
  sudo apt-get install -y apache2
  sudo systemctl start apache2
  sudo systemctl enable apache2
  echo "The page was created by the user data" | sudo tee /var/www/html/index.html
  EOF
  tags = {
    "Name" = "EC2-PUBLIC"
  }
}
