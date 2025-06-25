# Prerequisite Packages Role

## 개요
Docker와 Docker Compose를 RPM 파일을 사용하여 설치하는 역할입니다.

## 주요 기능
- Docker CE 26.0.1 설치
- Docker Compose Plugin 2.26.1 설치
- Docker 관련 의존성 패키지 설치
- Docker 서비스 시작 및 활성화
- 사용자를 docker 그룹에 추가

## 설치되는 패키지

### Docker Core
- docker-ce-26.0.1-1.el9.x86_64.rpm
- docker-ce-cli-26.0.1-1.el9.x86_64.rpm
- docker-ce-rootless-extras-26.0.1-1.el9.x86_64.rpm

### Docker Plugins
- docker-buildx-plugin-0.13.1-1.el9.x86_64.rpm
- docker-compose-plugin-2.26.1-1.el9.x86_64.rpm

### Dependencies
- containerd.io-1.6.31-3.1.el9.x86_64.rpm
- container-selinux-2.221.0-1.el9.noarch.rpm
- fuse3 관련 패키지들
- libslirp, slirp4netns 등

## 사용법

### 기본 사용
```yaml
- hosts: secloudit_vms
  roles:
    - prerequisite/packages
```

### 플레이북에서 사용
```yaml
# 패키지 설치 (secloudit VM에서만 실행)
- hosts: secloudit_vms
  roles:
    - prerequisite/packages
```

## 설치 후 확인사항
- Docker 서비스가 시작되고 활성화됨
- 사용자가 docker 그룹에 추가됨
- `docker --version` 명령어로 버전 확인 가능
- `docker compose version` 명령어로 Docker Compose 버전 확인 가능

## 주의사항
- 이 role은 secloudit_vms 그룹에서만 실행되어야 합니다.
- RPM 파일들은 role의 files/docker/ 디렉토리에 있어야 합니다.
- 설치 후 임시 파일들은 자동으로 정리됩니다. 