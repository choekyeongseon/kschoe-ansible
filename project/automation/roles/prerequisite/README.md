# Prerequisite Role

## 개요
시스템 환경 설정을 위한 사전 준비 역할입니다. 시스템 최적화, 패키지 설치, 사용자 관리를 담당합니다.

## Role 구조

```
prerequisite/
├── system/          # 시스템 전역 설정 (모든 VM에서 실행)
├── packages/        # 패키지 설치 (secloudit VM에서만 실행)
└── users/           # 사용자 관리 (선택적)
```

## 하위 Roles

### 1. prerequisite/system
**실행 대상**: 모든 VM (`hosts: all`)

**주요 기능**:
- Swap 비활성화 (`swapoff -a`)
- `/etc/fstab`에서 swap 항목 주석 처리
- 방화벽 비활성화 (firewalld)
- SELinux 비활성화 (`setenforce 0`, config 파일 수정)

**사용법**:
```yaml
- hosts: all
  roles:
    - prerequisite/system
```

### 2. prerequisite/packages
**실행 대상**: secloudit VM만 (`hosts: secloudit_vms`)

**주요 기능**:
- Docker CE 26.0.1 설치
- Docker Compose Plugin 2.26.1 설치
- Docker 관련 의존성 패키지 설치
- Docker 서비스 시작 및 활성화
- 사용자를 docker 그룹에 추가

**설치되는 패키지**:
- `docker-ce-26.0.1-1.el9.x86_64.rpm`
- `docker-ce-cli-26.0.1-1.el9.x86_64.rpm`
- `docker-compose-plugin-2.26.1-1.el9.x86_64.rpm`
- `containerd.io-1.6.31-3.1.el9.x86_64.rpm`
- 기타 의존성 패키지들

**사용법**:
```yaml
- hosts: secloudit_vms
  roles:
    - prerequisite/packages
```

### 3. prerequisite/users
**실행 대상**: 선택적

**주요 기능**:
- 사용자 생성 및 관리
- 그룹 설정
- 권한 관리

## 전체 사용법

### 1. 시스템 설정만 (모든 VM)
```yaml
- hosts: all
  roles:
    - prerequisite/system
```

### 2. 패키지 설치만 (secloudit VM)
```yaml
- hosts: secloudit_vms
  roles:
    - prerequisite/packages
```

### 3. 전체 prerequisite (권장)
```yaml
# 시스템 전역 설정 (모든 VM에서 실행)
- hosts: all
  roles:
    - prerequisite/system

# 패키지 설치 (secloudit VM에서만 실행)
- hosts: secloudit_vms
  roles:
    - prerequisite/packages
```

## 플레이북 파일

### 메인 플레이북
- `playbooks/prerequisite.yml`: 전체 prerequisite 실행

### 테스트 플레이북
- `playbooks/prerequisite-system-test.yml`: system role 테스트
- `playbooks/prerequisite-packages-test.yml`: packages role 테스트
- `playbooks/docker-install-test.yml`: Docker 설치 테스트

## 실행 순서

1. **시스템 설정** (모든 VM):
   ```bash
   ansible-playbook -i inventory/hosts playbooks/prerequisite-system-test.yml
   ```

2. **패키지 설치** (secloudit VM):
   ```bash
   ansible-playbook -i inventory/hosts playbooks/prerequisite-packages-test.yml
   ```

3. **전체 prerequisite**:
   ```bash
   ansible-playbook -i inventory/hosts playbooks/prerequisite.yml
   ```

## 주의사항

- **system role**: 모든 VM에서 실행되어야 합니다.
- **packages role**: secloudit_vms 그룹에서만 실행되어야 합니다.
- **Docker 설치**: RPM 파일들이 `files/docker/` 디렉토리에 있어야 합니다.
- **권한**: root 권한이 필요합니다 (`become: true`).

## 의존성

- **system**: 없음 (독립 실행 가능)
- **packages**: system role 실행 후 권장
- **users**: 선택적 (필요시에만 실행)

## 검증

### Docker 설치 확인
```bash
# Docker 버전 확인
docker --version

# Docker Compose 버전 확인
docker compose version

# Docker 서비스 상태 확인
systemctl status docker
```

### 시스템 설정 확인
```bash
# Swap 상태 확인
swapon --summary

# Firewalld 상태 확인
systemctl status firewalld

# SELinux 상태 확인
getenforce
``` 