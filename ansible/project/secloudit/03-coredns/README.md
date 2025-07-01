# 03. CoreDNS 실행 구성

## 주요 작업

* Docker 및 Docker Compose 설치 (로컬 RPM 활용)
* Docker 사용자 권한 설정 및 데몬 실행
* CoreDNS 실행 전용 디렉토리 복사 및 구성 파일 준비
* Corefile 템플릿 구성 (`domain`, `clustername` 변수화)
* CoreDNS 컨테이너 실행 스크립트 (`install.sh`) 실행
* /etc/resolv.conf 수정 또는 DNS 설정으로 CoreDNS 참조

## 자세한 작업 순서

1. Docker 및 Docker Compose 설치 (로컬 RPM 파일 활용)
2. Docker 사용자 권한 설정 및 데몬 실행

   ```bash
   sudo usermod -aG docker $(whoami)
   sudo systemctl enable docker
   sudo systemctl restart docker
   ```
3. CoreDNS 실행을 위한 디렉토리 복사 (예: `/opt/coredns`)
4. `coredns/init/Corefile`에 다음과 같은 도메인 매핑 정보 추가 (`<domain>`, `<clustername>` 변수화)

   ```
   # devopsit rule.
   <devopsit-core-ip>      harbor.<domain>
   <devopsit-core-ip>      argocd.<domain>
   <devopsit-core-ip>      gitlab.<domain>
   <devopsit-core-ip>      sonarqube.<domain>
   <devopsit-core-ip>      nexus.<domain>
   <devopsit-core-ip>      jenkins.<domain>

   <devopsit-console>      devops.<domain>

   # innogrid VMs
   <secloudit-console-ip>  secloudit.<domain>
   <innogrid-auth-ip>      keycloak.<domain>
   <tabcloudit-console-ip> tabcloudit.<domain>
   <secloudit-util-ip>     util.<domain>
   <secloudit-logging-ip>  logging.<domain>

   # kubernetes cluster
   <kubernetes-lb-ip>      <clustername>
   ```
5. `install.sh` 스크립트를 실행하여 CoreDNS 컨테이너 기동

## 고려 사항

* Corefile 및 hosts 파일은 템플릿으로 관리하여 IP 및 도메인 자동 주입 필요
* port 53 (tcp/udp) 방화벽 허용 필수
* Docker 재시작 시 자동 재기동 설정 필요
* 컨테이너 실행 시 volume mount를 통해 Corefile, hosts 파일 주입 필요

## Ansible Role 설계

* 역할명: `coredns`
* 주요 태스크:

  * Docker 및 Compose 설치
  * Docker 그룹 권한 추가 및 데몬 설정
  * CoreDNS 디렉토리 복사
  * Corefile 템플릿 및 hosts 파일 구성
  * install.sh 실행

## 변수 예시

```yaml
coredns:
  container_name: coredns
  image: coredns/coredns:1.11.1
  listen_port: 53
  config_dir: /opt/coredns
  hosts_file: /opt/coredns/hosts.txt
  corefile_path: /opt/coredns/Corefile
  restart_policy: always
  domain: secloudit.local
  clustername: k8s-cluster
  install_script_path: /opt/coredns/install.sh
```
