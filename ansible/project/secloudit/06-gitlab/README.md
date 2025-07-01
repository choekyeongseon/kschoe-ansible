# 08. GitLab 도커 기반 배포

## 주요 작업

* Docker 및 Docker Compose 설치 (로컬 RPM 파일 활용)
* Docker 사용자 권한 설정 및 데몬 실행

  ```bash
  sudo usermod -aG docker $(whoami)
  sudo systemctl enable docker
  sudo systemctl restart docker
  ```
* GitLab 실행 디렉토리 복사 (예: `/opt/gitlab`)
* SSL 인증서 복사 및 마운트 디렉토리에 위치
* `install.sh` 스크립트 실행하여 GitLab 컨테이너 기동

## 고려 사항

* 컨테이너 실행 시 외부 도메인 기준으로 인증서 구성되어 있어야 함
* HTTP/HTTPS 포트, SSH 포트에 대한 방화벽 설정 확인
* 최초 실행 시 admin 비밀번호, 프로젝트 생성 여부 자동화 가능
* GitLab 데이터 볼륨은 config/data/logs 구분 보관 권장

## Ansible Role 설계

* 역할명: `gitlab`
* 주요 태스크:

  * Docker 및 Compose 설치
  * Docker 그룹 권한 및 데몬 설정
  * GitLab 디렉토리 복사
  * SSL 인증서 복사
  * install.sh 실행하여 컨테이너 기동

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
