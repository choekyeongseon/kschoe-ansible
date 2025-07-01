# Harbor Role 테스트 가이드

## 개요
Harbor 역할을 테스트하기 위한 두 가지 playbook이 제공됩니다.

## 테스트 Playbook

### 1. harbor-simple-test.yml (권장)
- **목적**: 파일 배포만 테스트 (실제 설치 없음)
- **사용법**: 
  ```bash
  ansible-playbook -i ../inventory/hosts harbor-simple-test.yml
  ```
- **특징**:
  - `/tmp/harbor-test/` 디렉토리에 파일들을 배포
  - 실제 Harbor 설치 없이 파일 배포만 확인
  - 빠르고 안전한 테스트

### 2. harbor-test.yml (전체 테스트)
- **목적**: 전체 Harbor 설치 및 실행 테스트
- **사전 요구사항**:
  - Docker 설치
  - SSL 인증서 생성
- **사용법**:
  ```bash
  ansible-playbook -i ../inventory/hosts harbor-test.yml
  ```
- **특징**:
  - 실제 Harbor 설치 및 실행
  - Docker 컨테이너 상태 확인
  - 웹 인터페이스 접근 테스트

## 테스트 전 확인사항

### 1. 인벤토리 확인
```bash
# 대상 호스트 확인
ansible secloudit_vms --list-hosts

# 연결 테스트
ansible secloudit_vms -m ping
```

### 2. 사전 요구사항 확인
```bash
# Docker 설치 확인
ansible secloudit_vms -m command -a "docker --version"

# 디스크 공간 확인
ansible secloudit_vms -m shell -a "df -h /opt"
```

## 변수 커스터마이징

### 기본 변수 수정
`project/automation/roles/secloudit/harbor/defaults/main.yml` 파일에서 기본값을 수정할 수 있습니다.

### Playbook에서 변수 오버라이드
```yaml
- hosts: secloudit_vms
  vars:
    harbor_config_path: /custom/path/config
    harbor_working_dir: /custom/path
    harbor:
      hostname: harbor.example.com
      admin_password: MySecurePassword
  roles:
    - secloudit/harbor
```

## 예상 결과

### Simple Test 성공 시
- `/tmp/harbor-test/` 디렉토리에 Harbor 파일들이 배포됨
- `harbor.yml`, `docker-compose.yml` 등 설정 파일들이 생성됨
- 스크립트 파일들이 실행 권한과 함께 배포됨

### Full Test 성공 시
- Harbor 컨테이너들이 실행됨
- 웹 인터페이스에 접근 가능 (http://hostname:80)
- Docker 컨테이너 상태가 정상

## 문제 해결

### 1. 권한 문제
```bash
# 디렉토리 권한 확인
ansible secloudit_vms -m shell -a "ls -la /opt/harbor"
```

### 2. Docker 문제
```bash
# Docker 서비스 상태 확인
ansible secloudit_vms -m service -a "name=docker state=started"
```

### 3. 포트 충돌
```bash
# 포트 사용 확인
ansible secloudit_vms -m shell -a "netstat -tlnp | grep :80"
```

## 로그 확인
```bash
# Harbor 컨테이너 로그 확인
ansible secloudit_vms -m shell -a "docker logs harbor-core"
``` 