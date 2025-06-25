# MongoDB 실행 구성 (secloudit/mongodb)

## 주요 작업
- Docker 및 Docker Compose 설치 (로컬 RPM 파일 활용)
- Docker 사용자 권한 설정 및 데몬 실행
- MongoDB 실행을 위한 디렉토리 복사
- install.sh 스크립트 실행하여 MongoDB 컨테이너 기동

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