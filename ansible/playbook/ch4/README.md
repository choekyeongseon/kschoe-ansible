# Ansible Hosts File Syntax Study

## Overview
이 저장소는 Ansible의 인벤토리(hosts) 파일 구문과 사용법에 대한 학습 내용을 담고 있습니다.

## Ansible Hosts File
- 위치: `/etc/ansible/hosts`
- 목적: Ansible이 관리하는 모든 원격 클라이언트의 인벤토리 정보 저장
- 특징: Ansible 설치 시 자동으로 생성됨

## 호스트 파일 구문

### 1. 기본 구문
```ini
[그룹명]
서버별칭 ansible_ssh_host=IP주소
```

예시:
```ini
[servers]
server1 ansible_ssh_host=10.91.50.110
server2 ansible_ssh_host=10.91.50.111
```

### 2. 그룹화
- 서버들을 목적이나 역할별로 그룹화 가능
- 대괄호 [ ]를 사용하여 그룹 정의

예시:
```ini
[appserver]
server1
server2

[webserver]
server3
server4

[dbservers]
server5
server6
```

### 3. 호스트 지정 방법
1. 도메인명 사용
   ```ini
   app1.example.com
   app2.example.com
   ```

2. IP 주소 사용
   ```ini
   206.198.210.35
   205.168.20.13
   ```

3. IP 범위 지정
   ```ini
   205.168.20.[11:14]  # 11부터 14까지의 IP 주소
   ```

### 4. 특별 그룹
- `[all]` 또는 `[allservers]`: 모든 서버를 포함하는 기본 그룹
- Ansible이 자동으로 모든 호스트를 이 그룹에 포함시킴

### 5. 사용자 정의 위치
- 기본 위치(`/etc/ansible/hosts`) 외에 다른 위치에 호스트 파일 지정 가능
- 실행 시 `-i` 옵션으로 위치 지정:
  ```bash
  ansible-playbook -i /path/to/hosts playbook.yml
  ```

## 주의사항
- 각 호스트는 한 줄에 하나씩 정의
- 그룹은 중첩 가능
- 한 호스트가 여러 그룹에 속할 수 있음
- 호스트 파일의 문법 오류는 Ansible 실행 오류의 주요 원인이 될 수 있음 