# CoreDNS 실행 구성 (secloudit/coredns)

## 주요 작업
- Docker 및 Docker Compose 설치 (로컬 RPM 활용)
- Docker 사용자 권한 설정 및 데몬 실행
- CoreDNS 실행 전용 디렉토리 복사 및 구성 파일 준비
- Corefile 템플릿 구성 (domain, clustername 변수화)
- CoreDNS 컨테이너 실행 스크립트 (install.sh) 실행
- /etc/resolv.conf 수정 또는 DNS 설정으로 CoreDNS 참조

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