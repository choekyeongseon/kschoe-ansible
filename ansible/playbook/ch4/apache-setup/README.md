# Apache 설치 및 방화벽 포트 설정

이 문서는 Ansible을 사용하여 Apache 웹 서버를 설치하고 방화벽 포트를 설정하는 방법을 설명합니다.

## 사전 준비 사항

- Control Node에 Ansible이 설치되어 있어야 합니다.
- Target Node에 대한 SSH 접속이 가능해야 합니다.
- Target Node의 sudo 권한이 필요합니다.

## 작업 순서

1. Apache(httpd) 패키지 상태 확인
   ```bash
   ansible target -m command -a "rpm -qa | grep http"
   ```

2. Apache 서비스 상태 확인
   ```bash
   ansible target -m command -a "systemctl status httpd"
   ```

3. 방화벽 서비스 상태 확인
   ```bash
   ansible target -m command -a "systemctl status firewalld"
   ```

4. HTTP 서비스가 방화벽에서 허용되어 있는지 확인
   ```bash
   ansible target -m command -a "firewall-cmd --list-all"
   ```

## Playbook 예제

```yaml
---
- name: Apache 설치 및 설정
  hosts: target
  become: yes
  tasks:
    - name: Apache 패키지 설치
      dnf:
        name: httpd
        state: present

    - name: Apache 서비스 시작 및 자동 시작 설정
      service:
        name: httpd
        state: started
        enabled: yes

    - name: 방화벽에서 http 서비스 허용
      firewalld:
        service: http
        permanent: yes
        state: enabled
        immediate: yes
```

## 실행 방법

1. Playbook 실행:
   ```bash
   ansible-playbook apache-setup.yaml
   ```

2. 설치 확인:
   - 웹 브라우저에서 Target Node의 IP 주소로 접속
   - `http://<target-ip>`로 접속하여 Apache 기본 페이지 확인

## 주의 사항

- SELinux가 활성화된 경우 추가 설정이 필요할 수 있습니다.
- 방화벽 규칙 변경 시 기존 설정을 백업하는 것이 좋습니다.
- 프로덕션 환경에서는 보안 설정을 추가로 검토해야 합니다.

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