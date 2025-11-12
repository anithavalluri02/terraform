provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "mysql_sg" {
  name        = "mysql_sg"
  description = "Allow SSH and MySQL"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "mysql_server" {
  ami                    = var.instance_ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.vpc_security_group_id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install docker -y
    systemctl start docker
    systemctl enable docker
    usermod -aG docker ec2-user

    docker pull mysql:latest
    docker run -d \
      --name mydb \
      -e MYSQL_ROOT_PASSWORD=${var.mysql_root_password} \
      -e MYSQL_DATABASE=${var.mysql_database_name} \
      -p 3306:3306 \
      mysql:latest

    echo "✅ Docker and MySQL setup completed" > /home/ec2-user/setup-status.log
  EOF

  tags = {
    Name = var.instance_name
  }
}

# Output EC2 Public IP
output "ec2_public_ip" {
  description = "Public IP of the MySQL EC2 instance"
  value       = aws_instance.mysql_server.public_ip
}
