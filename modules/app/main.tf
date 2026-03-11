resource "aws_instance" "this" {
  ami = "ami-0b3c832b6b7289e44"   
  instance_type = "t3.micro"
  subnet_id = var.subnet_id
  vpc_security_group_ids = [ var.security_group_id ]
  iam_instance_profile = var.iam_instance_profile 
  associate_public_ip_address = true
  key_name = "my-key-pair"

  user_data = <<-EOF
              #!/bin/bash
              apt update
              apt install docker.io -y
              docker run -d -p 80:5000 file-upload-app
              EOF

  tags = {
    Name = "tp-app-ec2"
  }
}
