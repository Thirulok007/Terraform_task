terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  alias  = "mumbai"
  region = "ap-south-1"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

resource "aws_instance" "mumbai_ec2" {
  provider      = aws.mumbai
  ami           = "ami-0f58b397bc5c1f2e8"
  instance_type = "t3.micro"

  tags = {
    Name = "Mumbai-EC2"
  }
}

resource "aws_instance" "virginia_ec2" {
  provider      = aws.virginia
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t3.micro"

  tags = {
    Name = "Virginia-EC2"
  }
}
