# 05. DevOpsit-core 실행 구성

## 주요 작업

* Docker 및 Docker Compose 설치 (로컬 RPM 파일 활용)
* Docker 사용자 권한 설정 및 데몬 실행

  ```bash
  sudo usermod -aG docker $(whoami)
  sudo systemctl enable docker
  sudo systemctl restart docker
  ```
* MongoDB 실행을 위한 디렉토리 복사 (예: `/opt/mongodb`)
* `install.sh` 스크립트 실행하여 MongoDB 컨테이너 기동

## 고려 사항

* 데이터 지속성을 위한 외부 볼륨 마운트 필요
* 포트 설정 (기본 27017) 및 방화벽 허용 여부 확인
* 초기 사용자 계정, 인증 모드 구성 여부 사전 정의 필요

## Ansible Role 설계

* 역할명: `mongodb`
* 주요 태스크:

  * Docker 및 Compose 설치
  * Docker 그룹 권한 및 데몬 설정
  * MongoDB 디렉토리 복사
  * install.sh 실행하여 컨테이너 실행

## 변수 예시

```yaml
mongodb:
  container_name: mongodb
  image: mongo:6.0
  install_script: /opt/mongodb/install.sh
  data_dir: /data/mongodb
  restart_policy: always
  port: 27017
```
