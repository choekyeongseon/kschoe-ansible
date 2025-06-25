# Keycloak 실행 구성 (secloudit/keycloak)

## 주요 작업
- Docker 및 Docker Compose 설치 (로컬 RPM 활용)
- Docker 사용자 권한 설정 및 데몬 실행
- Keycloak 실행을 위한 디렉토리 복사
- install.sh 스크립트 실행하여 Keycloak 컨테이너 기동
- 초기 admin 사용자 생성 스크립트 구성 (선택)

## 변수 예시
```yaml
keycloak:
  container_name: keycloak
  image: quay.io/keycloak/keycloak:21.1.1
  install_script: /opt/auth/install.sh
  config_path: /opt/auth/config
  restart_policy: always
  admin_user: admin
  admin_password: Keycloak1234
``` 