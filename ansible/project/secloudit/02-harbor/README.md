# 02. Harbor 실행 구성

## 주요 작업

* SSL 인증서 생성 스크립트 실행 (`create-cert.sh`)
* Docker 및 Docker Compose 설치 (로컬 RPM 파일 활용)
* Docker 사용자 권한 설정 및 데몬 실행
* Harbor 설치 디렉토리 구성 및 harbor.yml 설정
* Harbor 이미지 로드 후 prepare.sh → install.sh 실행
* Harbor 프로젝트 및 이미지 태깅 + push 수행

## 자세한 작업 순서

1. `create-cert.sh` 실행하여 파라미터로 전달된 도메인에 대해 SSL 인증서 생성

   * 예시: `./create-cert.sh {고객사명}.com`
2. Docker 및 Docker Compose 설치

   * 설치에 필요한 `.rpm` 파일은 지정된 디렉토리에 존재함
3. Docker 실행 권한 부여 및 서비스 시작

   * 예시:

     ```bash
     sudo usermod -aG docker $(whoami)
     systemctl enable docker
     systemctl restart docker
     ```
4. Harbor 설치

   * harbor.yml 설정 파일 배포
   * 로컬 이미지 로드: `docker load -i harbor.v2.9.2.tar.gz`
   * `prepare.sh` → `install.sh` 순서로 실행하여 harbor 컨테이너 기동
5. Harbor 기동 후 시스템 이미지 등록

   * `harbor-project-create.sh` 실행
   * `tagging-push.sh` 실행하여 로컬 이미지 업로드

## 고려 사항

* 폐쇄망 환경이므로 Harbor 설치에 필요한 이미지와 패키지는 모두 로컬에 존재해야 함
* harbor.yml 내 도메인/포트/데이터 경로 설정 정확성 필요
* 프로젝트 및 이미지 업로드 스크립트는 idempotent 하게 반복 실행 가능해야 함

## Ansible Role 설계

* 역할명: `harbor`
* 주요 태스크:

  * SSL 인증서 스크립트 실행 (`create-cert.sh`)
  * Docker / Compose 설치 및 데몬 설정
  * harbor 이미지 로드
  * harbor.yml 구성 및 prepare/install 스크립트 실행
  * 초기 프로젝트 생성 및 이미지 push 스크립트 실행

## 변수 예시

```yaml
harbor:
  hostname: harbor.local
  http_port: 80
  https_port: 443
  admin_password: Harbor12345
  data_path: /data/harbor
  package_path: /opt/installers/harbor-offline-installer.tgz
  config_path: /opt/harbor/harbor.yml
  cert_enabled: true
  cert_domain: customer.com
  cert_script_path: /opt/scripts/create-cert.sh
  image_archive_path: /opt/images/harbor.v2.9.2.tar.gz
  project_script: /opt/scripts/harbor-project-create.sh
  push_script: /opt/scripts/tagging-push.sh
```




