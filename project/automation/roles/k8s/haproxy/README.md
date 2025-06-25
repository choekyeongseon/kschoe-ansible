# HAProxy 실행 구성 (k8s/haproxy)

## 주요 작업
- HAProxy 설치 (로컬 RPM 패키지 활용)
- 설치 디렉토리 구성 및 rpm 파일 복사
- rpm 기반 설치 수행
- 기존 haproxy.cfg 백업 후 설정 파일 배포
- HAProxy 서비스 기동 및 상태 확인

## 변수 예시
```yaml
haproxy:
  rpm_file: /opt/installers/haproxy-2.6.6-1.el9.x86_64.rpm
  config_source: /opt/configs/haproxy.cfg
  config_target: /etc/haproxy/haproxy.cfg
  backup_path: /etc/haproxy/haproxy.cfg.bak
``` 