resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-template"
  image_id      = "ami-018bef78e20688ef5"   
  instance_type = "t3.micro"
  key_name = "my-key-pair"
  iam_instance_profile {
    name = var.profile
  }

  user_data = base64encode(<<-EOF
  #!/bin/bash

sudo yum update -y
sudo amazon-linux-extras install docker -y

sudo systemctl start docker
sudo systemctl enable docker

sudo docker run -d -p 80:5000 \
phutawan1906/phutw-cloud-project:v2
              EOF
  )
  network_interfaces {
    security_groups = [ var.ec2_sg ]
  }
}

