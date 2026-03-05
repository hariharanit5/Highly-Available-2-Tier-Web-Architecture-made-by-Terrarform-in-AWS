provider "aws" {
  region = var.region
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

# Subnet 1
resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet1_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

# Subnet 2
resource "aws_subnet" "sub2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet2_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Route Table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Route Association
resource "aws_route_table_association" "a1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "a2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.rt.id
}

# Security Group
resource "aws_security_group" "web" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Server 1
resource "aws_instance" "web1" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.sub1.id
  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = <<EOF
#!/bin/bash
apt update -y
apt install apache2 -y
echo "Server 1" > /var/www/html/index.html
systemctl start apache2
EOF
}

# EC2 Server 2
resource "aws_instance" "web2" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.sub2.id
  vpc_security_group_ids = [aws_security_group.web.id]

  user_data = <<EOF
#!/bin/bash
apt update -y
apt install apache2 -y
echo "Server 2" > /var/www/html/index.html
systemctl start apache2
EOF
}

# Load Balancer
resource "aws_lb" "alb" {
  name               = "myalb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web.id]
  subnets            = [aws_subnet.sub1.id, aws_subnet.sub2.id]
}

# Target Group
resource "aws_lb_target_group" "tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

# Target Attachment
resource "aws_lb_target_group_attachment" "t1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.web1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "t2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.web2.id
  port             = 80
}

# Listener
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# S3 Bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "terraform-demo-project-bucket-2026"
}