# User Account Management

이 실습의 목적은 user 모듈을 사용해 원격 서버에 사용자 계정을 생성하는 방법을 익히는 것입니다.

## 실습 목적
- 사용자 계정 생성 및 홈 디렉토리, shell 환경 지정

## 예시 플레이북 (adduser.yml)
```yaml
- name: Playbook for creating users
  hosts: all
  tasks:
    - name: Create users
      user:
        name: george
        home: /home/george
        shell: /bin/bash
```

## 주요 옵션
- name: 생성할 사용자명
- home: 홈 디렉토리 경로
- shell: 로그인 shell

## 실행
```bash
ansible-playbook adduser.yml 