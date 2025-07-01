# 06. Keycloak 실행 구성

## 주요 작업

* Docker 및 Docker Compose 설치 (로컬 RPM 활용)
* Docker 사용자 권한 설정 및 데몬 실행

  ```bash
  sudo usermod -aG docker $(whoami)
  sudo systemctl enable docker
  sudo systemctl restart docker
  ```
* Keycloak 실행을 위한 디렉토리 복사 (예: `/opt/auth`)
* `install.sh` 스크립트 실행하여 Keycloak 컨테이너 기동

## 고려 사항

* Keycloak은 JVM 기반으로 실행되므로 메모리 자원 고려 필요
* 초기 admin 계정 설정 및 realm import 자동화 가능성 고려
* 포트 (기본 8080 또는 8443) 방화벽 허용 여부 확인
* 볼륨 마운트를 통한 구성 파일 관리 권장

## Ansible Role 설계

* 역할명: `keycloak`
* 주요 태스크:

  * Docker 및 Compose 설치
  * Docker 그룹 권한 및 데몬 설정
  * Keycloak 디렉토리 복사
  * install.sh 실행하여 컨테이너 실행
  * 초기 admin 사용자 생성 스크립트 구성 (선택)

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
