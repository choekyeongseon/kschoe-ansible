# 07. 자사 서비스 도커 배포 구성

## 주요 작업

* Docker 및 Docker Compose 설치 (로컬 RPM 파일 활용)
* Docker 사용자 권한 설정 및 데몬 실행

  ```bash
  sudo usermod -aG docker $(whoami)
  sudo systemctl enable docker
  sudo systemctl restart docker
  ```
* 서비스 컨테이너 실행을 위한 SECloudit 디렉토리 복사 (예: `/opt/secloudit`)
* `install.sh` 스크립트 실행하여 SECloudit 도커 컨테이너 기동

## 고려 사항

* 컨테이너 기동 시 필요한 환경변수, 설정파일 경로 등이 사전에 준비되어야 함
* 볼륨 마운트, 포트 바인딩 설정이 서비스 요구사항에 맞게 조정되어야 함
* 로그 또는 데이터 경로는 외부 저장소 또는 백업 가능한 위치로 지정 권장
* 도커 재시작 시 자동 기동 설정 필수

## Ansible Role 설계

* 역할명: `internal_service`
* 주요 태스크:

  * Docker 및 Compose 설치
  * Docker 그룹 권한 및 데몬 설정
  * SECloudit 디렉토리 복사
  * install.sh 실행하여 서비스 컨테이너 기동

## 변수 예시

```yaml
internal_service:
  container_name: secloudit-service
  image: harbor.local/secloudit/web:latest
  install_script: /opt/secloudit/install.sh
  config_path: /opt/secloudit/config
  restart_policy: always
  ports:
    - "8080:8080"
  volumes:
    - /data/secloudit/config:/app/config
    - /data/secloudit/logs:/app/logs
  env:
    - ENV=prod
    - LOG_LEVEL=info
```
