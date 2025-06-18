# 01. Prerequisite (사전 준비)

## 목적
- 쿠버네티스 클러스터 및 도커 컨테이너 실행을 위한 공통 환경 준비

## 주요 작업
- swapoff -a (스왑 비활성화)
- 방화벽 해제 (firewalld/iptables 등)
- SELinux 비활성화
- 커널 파라미터 조정 (k8s/컨테이너용)
- (필요시) 시간 동기화, 호스트네임 설정 등

## 변수 예시
- hosts: all 또는 그룹별(마스터/워커/서비스)

## Ansible 태스크 예시
- shell, lineinfile, systemd, service 모듈 등 활용

## 실행 예시
```bash
ansible-playbook 01-prerequisite.yml -i inventory
```

## 주의사항
- 폐쇄망 환경에서는 필요한 패키지/스크립트가 로컬에 있어야 함 