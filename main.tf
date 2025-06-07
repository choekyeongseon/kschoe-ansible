provider "aws" {
  region = "ap-northeast-2"
}




resource "aws_key_pair" "ansible_key" {
  key_name   = "ansible-key-dev"
  public_key = file("~/.ssh/id_rsa.pub")
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_ami" "rhel9" {
  most_recent = true
  owners      = ["309956199498"] # Red Hat official AWS account

  filter {
    name   = "name"
    values = ["RHEL-9*_HVM-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_security_group" "ansible_sg" {
  name        = "ansible-lab-sg-dev"
  description = "Allow SSH"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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

resource "aws_instance" "control_node" {
  ami                    = data.aws_ami.rhel9.id
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnets.default.ids[0]
  key_name               = aws_key_pair.ansible_key.key_name
  vpc_security_group_ids = [aws_security_group.ansible_sg.id]
  
  user_data = <<-EOF
              #!/bin/bash
              
              # 설치 로그 파일 생성
              exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
              
              echo "[INFO] Starting user_data script execution"
              
              # RHEL 9 시스템 업데이트 및 Python3 pip 설치
              echo "[INFO] Updating system and installing python3-pip"
              dnf update -y
              dnf install -y python3-pip
              
              # ec2-user로 Ansible 설치
              echo "[INFO] Installing Ansible for ec2-user"
              sudo -u ec2-user bash << 'ANSIBLE_INSTALL'
              pip3 install --user ansible
              echo 'export PATH=$PATH:~/.local/bin' >> /home/ec2-user/.bashrc
              source /home/ec2-user/.bashrc
              ANSIBLE_INSTALL
              
              # Ansible 설치 확인
              echo "[INFO] Verifying Ansible installation"
              sudo -u ec2-user bash -c 'source ~/.bashrc && ansible --version' > /home/ec2-user/ansible_version.txt
              
              # 기본 Ansible 설정 디렉토리 생성
              echo "[INFO] Creating Ansible configuration directory"
              mkdir -p /home/ec2-user/ansible
              chown -R ec2-user:ec2-user /home/ec2-user/ansible
              
              # 기본 inventory 파일 생성
              echo "[INFO] Creating inventory file"
              echo "[targets]" > /home/ec2-user/ansible/inventory
              echo "target ansible_host=${aws_instance.target_node.private_ip}" >> /home/ec2-user/ansible/inventory
              chown ec2-user:ec2-user /home/ec2-user/ansible/inventory
              
              # ansible.cfg 파일 생성
              echo "[INFO] Creating ansible.cfg file"
              cat <<EOT > /home/ec2-user/ansible/ansible.cfg
              [defaults]
              inventory = ./inventory
              remote_user = ec2-user
              host_key_checking = False
              EOT
              chown ec2-user:ec2-user /home/ec2-user/ansible/ansible.cfg
              
              echo "[INFO] User data script completed"
              EOF

  tags = {
    Name = "ansible-control"
  }
}

resource "aws_instance" "target_node" {
  ami                    = data.aws_ami.rhel9.id
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnets.default.ids[0] # 같은 AZ 사용 (에러 회피)
  key_name               = aws_key_pair.ansible_key.key_name
  vpc_security_group_ids = [aws_security_group.ansible_sg.id]
  tags = {
    Name = "ansible-target"
  }
}

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