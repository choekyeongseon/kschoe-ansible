# 05. GitLab CI Module 실행 구성

## 주요 작업

* Docker 및 Docker Compose 설치 (로컬 RPM 활용)
* Docker 사용자 권한 설정 및 데몬 실행

  ```bash
  sudo usermod -aG docker $(whoami)
  sudo systemctl enable docker
  sudo systemctl restart docker
  ```
* GitLab CI Module 실행 디렉토리 복사 (예: `/opt/gitlabci-module`)
* `install.sh` 스크립트 실행하여 gitlabci-module 컨테이너 기동

## 고려 사항

* GitLab Runner와 통신이 필요한 경우 port 및 volume 구성 확인 필요
* 환경변수 설정 파일(.env) 혹은 config 파일 구성 필요 가능성
* 도커 재시작 시 자동 기동 설정

## Ansible Role 설계

* 역할명: `gitlabci_module`
* 주요 태스크:

  * Docker 및 Compose 설치
  * Docker 그룹 권한 및 데몬 설정
  * gitlabci-module 디렉토리 복사
  * install.sh 실행하여 컨테이너 실행

## 변수 예시

```yaml
gitlabci_module:
  container_name: gitlabci-module
  image: company/gitlabci-module:latest
  install_script: /opt/gitlabci-module/install.sh
  config_path: /opt/gitlabci-module/config
  restart_policy: always
```
