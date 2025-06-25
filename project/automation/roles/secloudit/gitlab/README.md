# GitLab 도커 기반 배포 (secloudit/gitlab)

## 주요 작업
- Docker 및 Docker Compose 설치 (로컬 RPM 파일 활용)
- Docker 사용자 권한 설정 및 데몬 실행
- GitLab 실행 디렉토리 복사
- SSL 인증서 복사 및 마운트 디렉토리에 위치
- install.sh 스크립트 실행하여 GitLab 컨테이너 기동

## 변수 예시
```yaml
gitlab:
  container_name: gitlab
  image: gitlab/gitlab-ce:16.2.0
  install_script: /opt/gitlab/install.sh
  config_path: /opt/gitlab/config
  cert_path: /opt/gitlab/certs
  restart_policy: always
  http_port: 80
  https_port: 443
  ssh_port: 22
  external_url: https://gitlab.local
``` 