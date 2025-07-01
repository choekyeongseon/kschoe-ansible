terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"

  default_tags {
    tags = {
      Project = "ansible-test"
    }
  }
}

# SSH 키 페어 등록 (절대 경로 또는 path.module 기준)
resource "aws_key_pair" "ansible_key" {
  key_name   = "ansible-key-dev"
  public_key = file("~/.ssh/id_rsa.pub")

  lifecycle {
    # prevent_destroy = true
    ignore_changes  = [public_key]
  }
}

# 기본 VPC 조회
data "aws_vpc" "default" {
  default = true
}

# 기본 VPC에 속한 서브넷 목록 조회
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# RHEL 9 AMI 조회
data "aws_ami" "rhel9" {
  most_recent = true
  owners      = ["309956199498"] # Red Hat 공식 AWS 계정

  filter {
    name   = "name"
    values = ["RHEL-9*_HVM-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# 보안 그룹 (SSH 허용)
resource "aws_security_group" "ansible_sg" {
  name        = "ansible-lab-sg-dev-v2"
  description = "Allow SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 필요시 제한할 것
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Ansible 제어 노드
resource "aws_instance" "control_node" {
  ami                         = data.aws_ami.rhel9.id
  instance_type               = "t3.medium"
  subnet_id                   = data.aws_subnets.default.ids[0]
  key_name                    = aws_key_pair.ansible_key.key_name
  vpc_security_group_ids      = [aws_security_group.ansible_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "ansible-control"
  }
}

# 대상 노드
resource "aws_instance" "target_node" {
  ami                         = data.aws_ami.rhel9.id
  instance_type               = "t3.medium"
  subnet_id                   = data.aws_subnets.default.ids[0]
  key_name                    = aws_key_pair.ansible_key.key_name
  vpc_security_group_ids      = [aws_security_group.ansible_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "ansible-target"
  }
}

# 출력 값
output "control_node_ip" {
  value = aws_instance.control_node.public_ip
}

output "target_node_ip" {
  value = aws_instance.target_node.public_ip
}

output "ssh_control_node" {
  value = "ssh -i ~/.ssh/id_rsa ec2-user@${aws_instance.control_node.public_ip}"
}

output "ssh_target_node" {
  value = "ssh -i ~/.ssh/id_rsa ec2-user@${aws_instance.target_node.public_ip}"
}