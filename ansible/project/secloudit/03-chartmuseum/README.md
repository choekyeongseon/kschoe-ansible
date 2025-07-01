# 04. Chartmuseum 실행 구성

## 주요 작업

* Docker 및 Docker Compose 설치 (로컬 RPM 활용)
* Docker 사용자 권한 설정 및 데몬 실행

  ```bash
  sudo usermod -aG docker $(whoami)
  sudo systemctl enable docker
  sudo systemctl restart docker
  ```
* Chartmuseum 실행 디렉토리 복사 (예: `/opt/chartmuseum`)
* `install.sh` 스크립트 실행하여 Chartmuseum 컨테이너 기동

## 고려 사항

* 포트 설정 (기본 8080)과 방화벽 정책 확인 필요
* chart 저장소 디렉토리 마운트 경로 확인 및 백업 정책 고려
* 도커 재시작 시 자동 기동 설정

## Ansible Role 설계

* 역할명: `chartmuseum`
* 주요 태스크:

  * Docker 및 Compose 설치
  * Docker 그룹 권한 및 데몬 설정
  * Chartmuseum 디렉토리 복사
  * install.sh 실행하여 컨테이너 실행

## 변수 예시

```yaml
chartmuseum:
  container_name: chartmuseum
  image: chartmuseum/chartmuseum:latest
  listen_port: 8080
  data_dir: /data/chartmuseum
  install_script: /opt/chartmuseum/install.sh
  restart_policy: always
```
