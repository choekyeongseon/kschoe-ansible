# Ansible Project 구조 및 실습 목차

이 프로젝트는 AWS 및 온프레미스 환경에서 인프라 자동화, Kubernetes 및 다양한 서비스 설치를 Ansible로 실습/구현하는 예제입니다.

## 아키텍처 개요

### Terraform (인프라 프로비저닝)
- **역할**: EC2 인스턴스 생성 및 기본 설정
- **범위**: 리소스 프로비저닝 + util-vm에 Ansible 설치
- **환경**: AWS (테스트용)

### Ansible (자동화)
- **역할**: SSH 키 분배, 서비스 설치, 설정 관리
- **범위**: 모든 자동화 작업
- **환경**: AWS, VMware, OpenStack (모든 환경)

## 디렉토리 구조

- `prerequisite/` : 사전 준비 작업(패키지 설치, 환경설정 등)
- `secloudit/`    : Harbor, CoreDNS, ChartMuseum, GitLab, Keycloak, Custom Service, MongoDB, Fluentd 등 서비스 설치
- `k8s/`         : LoadBalancer, Bastion, Kubernetes Cluster 등 설치

## 플레이북 목록

- `ssh-key-distribution.yml` : SSH 키 분배 및 통신 설정
- `prerequisite.yml` : 사전 준비 작업
- `secloudit.yml` : Secloudit 서비스 설치
- `k8s.yml` : Kubernetes 클러스터 설치
- `site.yml` : 전체 실행

## 환경별 사용법

### 1. AWS 환경 (테스트용)

#### Terraform으로 인프라 생성
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

#### util-vm에서 Ansible 작업 실행
```bash
# util-vm에 SSH 접속
ssh -i ~/.ssh/id_rsa ec2-user@<util-vm-public-ip>

# inventory 업데이트 (Terraform output으로 IP 확인)
cd /home/ec2-user/ansible
# inventory/hosts 파일의 PLACEHOLDER_* 부분을 실제 IP로 교체

# SSH 키 분배
ansible-playbook -i inventory/hosts playbooks/ssh-key-distribution.yml

# 이후 작업들
ansible-playbook -i inventory/hosts playbooks/prerequisite.yml
ansible-playbook -i inventory/hosts playbooks/secloudit.yml
ansible-playbook -i inventory/hosts playbooks/k8s.yml
```

### 2. VMware/OpenStack 환경 (실제 운영)

#### 사전 준비
- VMware/OpenStack에서 VM들이 미리 생성되어 있어야 함
- util-vm에 Ansible 설치 필요

#### Ansible 작업 실행
```bash
# util-vm에 접속
ssh user@<util-vm-ip>

# 프로젝트 복사 또는 클론
cd /path/to/ansible/project

# inventory 업데이트 (실제 VM IP 주소로)
# inventory/hosts 파일 수정

# SSH 키 분배
ansible-playbook -i inventory/hosts playbooks/ssh-key-distribution.yml

# 이후 작업들
ansible-playbook -i inventory/hosts playbooks/prerequisite.yml
ansible-playbook -i inventory/hosts playbooks/secloudit.yml
ansible-playbook -i inventory/hosts playbooks/k8s.yml
```

## 역할 네임스페이스 구조

### Prerequisite 역할
- `prerequisite/packages` : 시스템 패키지 설치
- `prerequisite/users` : 사용자 및 그룹 관리
- `prerequisite/system` : 시스템 설정 및 최적화

### Secloudit 역할
- `secloudit/harbor` : Harbor 컨테이너 레지스트리
- `secloudit/coredns` : CoreDNS DNS 서버
- `secloudit/chartmuseum` : ChartMuseum Helm 차트 저장소
- `secloudit/gitlab` : GitLab 소스 코드 관리
- `secloudit/keycloak` : Keycloak 인증 서비스
- `secloudit/mongodb` : MongoDB 데이터베이스
- `secloudit/fluentd` : Fluentd 로그 수집기
- `secloudit/custom-service` : 커스텀 서비스

### Kubernetes 역할
- `k8s/haproxy` : HAProxy 로드밸런서
- `k8s/kubernetes` : Kubernetes 클러스터
- `k8s/bastion` : Bastion 서버

## 실습 목차 및 링크

### 0. SSH Key Distribution
- SSH 키 분배 및 통신 설정 (util-vm에서 모든 target nodes로)

### 1. Prerequisite
- [01-prerequisite](prerequisite/01-prerequisite/README.md)

### 2. Secloudit
- [02-harbor](secloudit/02-harbor/README.md)
- [03-coredns](secloudit/03-coredns/README.md)
- [03-chartmuseum](secloudit/03-chartmuseum/README.md)
- [03-gitlabci](secloudit/03-gitlabci/README.md)
- [04-keycloak](secloudit/04-keycloak/README.md)
- [05-custom-service](secloudit/05-custom-service/README.md)
- [07-mongodb](secloudit/07-mongodb/README.md)
- [08-fluentd](secloudit/08-fluentd/README.md)

### 3. K8s
- [05-loadbalancer](k8s/05-loadbalancer/README.md)
- [06-bastion](k8s/06-bastion/README.md)
- [07-k8s-cluster](k8s/07-k8s-cluster/README.md)

## 실행 방법

### SSH 키 분배 (첫 번째 실행)
```bash
ansible-playbook -i inventory/hosts playbooks/ssh-key-distribution.yml
```

### 전체 실행
```bash
ansible-playbook -i inventory/hosts playbooks/site.yml
```

### 단계별 실행
```bash
# Prerequisite만 실행
ansible-playbook -i inventory/hosts playbooks/prerequisite.yml

# Secloudit 서비스만 실행
ansible-playbook -i inventory/hosts playbooks/secloudit.yml

# Kubernetes만 실행
ansible-playbook -i inventory/hosts playbooks/k8s.yml
```

### 태그를 이용한 선택적 실행
```bash
# Prerequisite 태그만 실행
ansible-playbook -i inventory/hosts playbooks/site.yml --tags prerequisite

# 서비스 관련 태그만 실행
ansible-playbook -i inventory/hosts playbooks/site.yml --tags services

# Kubernetes 관련 태그만 실행
ansible-playbook -i inventory/hosts playbooks/site.yml --tags kubernetes
```

### 개별 역할 실행 (네임스페이스 구조)
```bash
# 특정 역할만 실행
ansible-playbook -i inventory/hosts playbooks/k8s.yml --tags "k8s.haproxy"
ansible-playbook -i inventory/hosts playbooks/k8s.yml --tags "k8s.kubernetes"
ansible-playbook -i inventory/hosts playbooks/secloudit.yml --tags "secloudit.harbor"
ansible-playbook -i inventory/hosts playbooks/prerequisite.yml --tags "prerequisite.packages"
```

## 변수 설정

### inventory/group_vars/all.yml
```yaml
---
# Ansible 기본 설정
ansible_user: vagrant
ansible_ssh_private_key_file: ~/.ssh/id_rsa

# SSH 키 분배 설정
ssh_user: "{{ ansible_user | default('ec2-user') }}"
ssh_key_type: rsa
ssh_key_bits: 4096
```

### 환경별 사용자 설정
- **AWS 환경**: `ansible_user: ec2-user`
- **VMware 환경**: `ansible_user: root` 또는 `ansible_user: ubuntu`
- **OpenStack 환경**: `ansible_user: centos` 또는 `ansible_user: ubuntu`

### 플레이북별 변수
각 플레이북에서 서비스별 변수를 정의하고 있습니다:
- `ssh-key-distribution.yml`: SSH 키 생성 및 분배 (변수화됨)
- `prerequisite.yml`: 패키지 목록, 사용자 설정
- `secloudit.yml`: Harbor, GitLab, Keycloak 등 서비스 비밀번호
- `k8s.yml`: Kubernetes 버전, 네트워크 CIDR 등

## SSH 키 분배 자동화

### 목적
- util-vm (Ansible control node)에서 모든 target nodes로 SSH 키 복사
- 모든 VM 간의 passwordless SSH 통신 설정
- Ansible 작업을 위한 사전 준비

### 대상 노드
- **Utility VMs**: auth-vm, console-vm, logging-vm
- **Master Nodes**: master1, master2, master3
- **Worker Nodes**: worker1, worker2, worker3

### 실행 순서
1. **AWS**: Terraform으로 EC2 인스턴스 생성
2. **모든 환경**: util-vm에 접속
3. **모든 환경**: inventory/hosts 파일 업데이트
4. **모든 환경**: SSH 키 분배 플레이북 실행
5. **모든 환경**: 이후 다른 Ansible 작업 실행

## 기타
- 각 디렉토리별 README.md에서 상세 실습 방법, 예시 플레이북, 변수 설명 등을 확인하세요.
- 실행 전 inventory/hosts 파일의 호스트 정보를 실제 환경에 맞게 수정하세요.
- 변수 값들은 보안을 위해 실제 환경에 맞게 변경하세요.
- 네임스페이스 구조를 통해 대규모 프로젝트에서도 체계적인 역할 관리가 가능합니다. 