# 06. Fluentd 실행 구성

## 주요 작업

* Docker 및 Docker Compose 설치 (로컬 RPM 파일 활용)
* Docker 사용자 권한 설정 및 데몬 실행

  ```bash
  sudo usermod -aG docker $(whoami)
  sudo systemctl enable docker
  sudo systemctl restart docker
  ```
* Fluentd 실행을 위한 디렉토리 복사 (예: `/opt/fluentd`)
* `install.sh` 스크립트 실행하여 Fluentd 컨테이너 기동

## 고려 사항

* 로그 수집 경로에 대한 volume mount 필요
* output 플러그인 설정 (예: MongoDB, Elasticsearch 등)에 따라 config 파일 사전 정의 필요
* Fluentd는 포트 24224/tcp, 5140/tcp 등 열려 있어야 함 (입력 플러그인에 따라 상이)

## Ansible Role 설계

* 역할명: `fluentd`
* 주요 태스크:

  * Docker 및 Compose 설치
  * Docker 그룹 권한 및 데몬 설정
  * Fluentd 디렉토리 복사
  * install.sh 실행하여 컨테이너 실행

## 변수 예시

```yaml
fluentd:
  container_name: fluentd
  image: fluent/fluentd:v1.16-debian-1.0
  install_script: /opt/fluentd/install.sh
  config_path: /opt/fluentd/conf
  log_volume: /data/logs
  restart_policy: always
  port: 24224
```
