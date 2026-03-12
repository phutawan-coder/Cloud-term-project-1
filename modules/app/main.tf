resource "aws_instance" "this" {
  ami                         = "ami-018bef78e20688ef5"
  instance_type               = "t3.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  iam_instance_profile        = var.iam_instance_profile
  associate_public_ip_address = true
  key_name                    = "my-key-pair"

  user_data = <<-EOF
  #!/bin/bash

sudo yum update -y
sudo amazon-linux-extras install docker -y

sudo systemctl start docker
sudo systemctl enable docker

sudo docker run -d -p 80:5000 \
phutawan1906/phutw-cloud-project:v2
              EOF

  tags = {
    Name = "tp-app-ec2"
  }
}
