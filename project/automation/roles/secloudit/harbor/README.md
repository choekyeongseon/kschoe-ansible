# Harbor 실행 구성 (secloudit/harbor)

## 주요 작업
- Docker 및 Docker Compose 설치 (로컬 RPM 파일 활용)
- Docker 사용자 권한 설정 및 데몬 실행
- Harbor 설치 디렉토리 구성 및 harbor.yml 설정
- Harbor 이미지 로드 후 prepare.sh → install.sh 실행
- Harbor 프로젝트 및 이미지 태깅 + push 수행

## 사전 요구사항
- SSL 인증서 생성: `secloudit/ssl-cert` role을 먼저 실행해야 합니다.

## 사용법
```yaml
- hosts: harbor-servers
  roles:
    - secloudit/ssl-cert  # SSL 인증서 생성 (먼저 실행)
    - secloudit/harbor    # Harbor 설치
```

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
  image_archive_path: /opt/images/harbor.v2.9.2.tar.gz
  project_script: /opt/scripts/harbor-project-create.sh
  push_script: /opt/scripts/tagging-push.sh
``` 