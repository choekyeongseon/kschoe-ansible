# Apache 설치 및 방화벽 포트 설정

이 문서는 Ansible을 사용하여 Apache 웹 서버를 설치하고 방화벽 포트를 설정하는 방법을 설명합니다.

## 사전 준비 사항

- Control Node에 Ansible이 설치되어 있어야 합니다.
- Target Node에 대한 SSH 접속이 가능해야 합니다.
- Target Node의 sudo 권한이 필요합니다.

## 테스트 환경 구성

1. Control Node:
   - RHEL 9 AMI
   - Ansible 사용자 레벨 설치 (`pip install --user ansible`)
   - `~/ansible/inventory` 파일에 Target Node 정보 구성

2. Target Node:
   - RHEL 9 AMI
   - SSH 키 인증 설정
   - sudo 권한 필요

## Playbook 구성 요소

### 1. 필수 패키지 설치
```yaml
- name: Install required packages
  dnf:
    name: 
      - python3-firewall
      - firewalld
    state: present
```

### 2. 방화벽 서비스 설정
```yaml
- name: Start and enable firewalld service
  service:
    name: firewalld
    state: started
    enabled: yes
```

### 3. Apache 설치 및 설정
```yaml
- name: install apache packages
  dnf:
    name: httpd
    state: present 

- name: start apache service
  service:
    name: httpd
    state: started
```

### 4. HTTP 포트 개방
```yaml
- name: open port 80 for http access 
  firewalld:
    service: http
    permanent: true
    state: enabled
```

## 발생한 문제 및 해결 방법

1. 권한 문제:
   - 문제: "This command has to be run under the root user"
   - 해결: Playbook에 `become: yes` 추가

2. Python Firewall 라이브러리 문제:
   - 문제: "Failed to import the required Python library (firewall)"
   - 해결: `python3-firewall` 패키지 설치

3. Firewalld 설정 문제:
   - 문제: "Failed to load '/etc/firewalld/firewalld.conf'"
   - 해결: `firewalld` 패키지 설치 및 서비스 시작

## 최종 Playbook

```yaml
---
- name: Apache setup
  hosts: all
  become: yes
  tasks:
    - name: Install required packages
      dnf:
        name: 
          - python3-firewall
          - firewalld
        state: present

    - name: Start and enable firewalld service
      service:
        name: firewalld
        state: started
        enabled: yes

    - name: install apache packages
      dnf:
        name: httpd
        state: present 
    
    - name: start apache service
      service:
        name: httpd
        state: started

    - name: open port 80 for http access 
      firewalld:
        service: http
        permanent: true
        state: enabled
    
    - name: Restart firewalld service to load firewalld rules
      service:
        name: firewalld
        state: reloaded
```

## 실행 결과 확인

1. Apache 서비스 상태 확인:
```bash
ansible target -m command -a "systemctl status httpd"
```

2. 방화벽 규칙 확인:
```bash
ansible target -m command -a "firewall-cmd --list-all"
```

3. 웹 서버 접속 테스트:
```bash
curl http://<target-ip>
```

## 주의 사항

1. 패키지 설치 순서:
   - firewalld 관련 패키지를 먼저 설치
   - 그 다음 Apache 설치 및 설정
   - 마지막으로 방화벽 규칙 설정

2. 서비스 의존성:
   - firewalld 서비스가 실행 중이어야 방화벽 규칙 설정 가능
   - Apache 서비스는 방화벽 규칙과 독립적으로 실행 가능

3. 보안 고려사항:
   - 프로덕션 환경에서는 필요한 포트만 개방
   - SELinux 설정 확인 필요
   - 로그 모니터링 설정 권장

## 문제 해결

1. Apache 서비스가 시작되지 않는 경우:
   ```bash
   ansible target -m command -a "journalctl -u httpd"
   ```

2. 방화벽 설정 문제:
   ```bash
   ansible target -m command -a "firewall-cmd --list-all"
   ```

3. SELinux 관련 문제:
   ```bash
   ansible target -m command -a "getenforce"
   ``` 