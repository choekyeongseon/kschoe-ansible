# Chartmuseum 실행 구성 (secloudit/chartmuseum)

## 주요 작업
- Docker 및 Docker Compose 설치 (로컬 RPM 활용)
- Docker 사용자 권한 설정 및 데몬 실행
- Chartmuseum 실행 디렉토리 복사
- install.sh 스크립트 실행하여 Chartmuseum 컨테이너 기동

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