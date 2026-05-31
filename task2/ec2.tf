# -------------------------
# VPCs
# -------------------------

resource "aws_vpc" "mumbai_vpc" {
  provider   = aws.mumbai
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Mumbai-VPC"
  }
}

resource "aws_vpc" "virginia_vpc" {
  provider   = aws.virginia
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "Virginia-VPC"
  }
}

# -------------------------
# Subnets
# -------------------------

resource "aws_subnet" "mumbai_subnet" {
  provider = aws.mumbai
  vpc_id   = aws_vpc.mumbai_vpc.id

  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Mumbai-Subnet"
  }
}

resource "aws_subnet" "virginia_subnet" {
  provider = aws.virginia
  vpc_id   = aws_vpc.virginia_vpc.id

  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Virginia-Subnet"
  }
}

# -------------------------
# Internet Gateway
# -------------------------

resource "aws_internet_gateway" "mumbai_igw" {
  provider = aws.mumbai
  vpc_id   = aws_vpc.mumbai_vpc.id
}

resource "aws_internet_gateway" "virginia_igw" {
  provider = aws.virginia
  vpc_id   = aws_vpc.virginia_vpc.id
}

# -------------------------
# Route Tables
# -------------------------

resource "aws_route_table" "mumbai_rt" {
  provider = aws.mumbai
  vpc_id   = aws_vpc.mumbai_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mumbai_igw.id
  }
}

resource "aws_route_table" "virginia_rt" {
  provider = aws.virginia
  vpc_id   = aws_vpc.virginia_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.virginia_igw.id
  }
}

resource "aws_route_table_association" "mumbai_assoc" {
  provider       = aws.mumbai
  subnet_id      = aws_subnet.mumbai_subnet.id
  route_table_id = aws_route_table.mumbai_rt.id
}

resource "aws_route_table_association" "virginia_assoc" {
  provider       = aws.virginia
  subnet_id      = aws_subnet.virginia_subnet.id
  route_table_id = aws_route_table.virginia_rt.id
}

# -------------------------
# Security Groups
# -------------------------

resource "aws_security_group" "mumbai_sg" {
  provider = aws.mumbai
  name     = "mumbai-sg"
  vpc_id   = aws_vpc.mumbai_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_security_group" "virginia_sg" {
  provider = aws.virginia
  name     = "virginia-sg"
  vpc_id   = aws_vpc.virginia_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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

# -------------------------
# Key Pairs
# -------------------------

resource "aws_key_pair" "mumbai_key" {
  provider   = aws.mumbai
  key_name   = "terra-nginx-key-mumbai"
  public_key = file("terra-nginx-key.pub")
}

resource "aws_key_pair" "virginia_key" {
  provider   = aws.virginia
  key_name   = "terra-nginx-key-virginia"
  public_key = file("terra-nginx-key.pub")
}

# -------------------------
# EC2 Instances
# -------------------------

resource "aws_instance" "mumbai_instance" {
  provider                    = aws.mumbai
  ami                         = "ami-0f5ee92e2d63afc18"
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.mumbai_key.key_name
  subnet_id                   = aws_subnet.mumbai_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.mumbai_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install nginx -y
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "Mumbai-Nginx-Server"
  }
}

resource "aws_instance" "virginia_instance" {
  provider                    = aws.virginia
  ami                         = "ami-0ec10929233384c7f"
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.virginia_key.key_name
  subnet_id                   = aws_subnet.virginia_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.virginia_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install nginx -y
              systemctl start nginx
              systemctl enable nginx
              EOF

  tags = {
    Name = "Virginia-Nginx-Server"
  }
}

# -------------------------
# Outputs
# -------------------------

output "mumbai_instance_public_ip" {
  value = aws_instance.mumbai_instance.public_ip
}

output "virginia_instance_public_ip" {
  value = aws_instance.virginia_instance.public_ip
}
