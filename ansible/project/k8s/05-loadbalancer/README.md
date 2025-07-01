# 12. HAProxy 실행 구성

## 주요 작업

* HAProxy 설치 (로컬 RPM 패키지 활용)
* 설치 디렉토리 구성 및 rpm 파일 복사
* rpm 기반 설치 수행
* 기존 `haproxy.cfg` 백업 후 설정 파일 배포
* HAProxy 서비스 기동 및 상태 확인

## 자세한 작업 순서

1. HAProxy 설치

   * HAProxy 디렉토리 생성 (예: `/opt/haproxy`)
   * 설치용 RPM 복사 (예: `haproxy-2.x.rpm`)
   * `yum localinstall haproxy-2.x.rpm` 또는 `rpm -ivh` 명령으로 설치
2. 설정 구성

   * 기존 `/etc/haproxy/haproxy.cfg` 백업 (타임스탬프 백업 권장)
   * 로컬에 있는 새로운 `haproxy.cfg` 복사
3. HAProxy 서비스 실행 및 자동 시작 설정

   ```bash
   systemctl enable haproxy
   systemctl restart haproxy
   systemctl status haproxy
   ```

## 고려 사항

* 설정 파일 오류 시 서비스 시작 실패 → `haproxy -c -f /etc/haproxy/haproxy.cfg` 로 사전 검증 필요
* 방화벽 포트 설정 확인 필요 (예: 80, 443, 6443 등)
* 로그 파일 위치 및 로테이션 설정 확인

## Ansible Role 설계

* 역할명: `haproxy`
* 주요 태스크:

  * 디렉토리 및 rpm 복사
  * HAProxy 설치
  * 설정 백업 및 템플릿 배포
  * 서비스 기동 및 상태 확인

## 변수 예시

```yaml
haproxy:
  rpm_file: /opt/installers/haproxy-2.6.6-1.el9.x86_64.rpm
  config_source: /opt/configs/haproxy.cfg
  config_target: /etc/haproxy/haproxy.cfg
  backup_path: /etc/haproxy/haproxy.cfg.bak
```
