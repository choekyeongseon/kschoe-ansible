# User Account Management

이 실습의 목적은 user 모듈을 사용해 원격 서버에 사용자 계정을 생성하는 방법을 익히는 것입니다.

## 실습 배경 및 주요 개념
- 서버 운영 시 표준 계정 생성, 홈 디렉토리/쉘 환경 지정 등 반복 작업을 자동화할 수 있습니다.
- Ansible의 user 모듈은 계정 생성, 삭제, 속성 변경 등 다양한 계정 관리 작업을 지원합니다.
- 대규모 환경에서 일관된 계정 정책 적용에 매우 유용합니다.

## 실전 활용
- 신규 서버 배포 시 표준 계정 자동 생성
- 계정 속성(홈 디렉토리, shell 등) 일괄 변경
- 보안 정책에 따라 계정 관리 자동화

## 예시 플레이북 (adduser.yml)
```yaml
- name: Playbook for creating users
  hosts: all
  tasks:
    # 1. george 계정 생성 및 홈 디렉토리, shell 지정
    - name: Create users
      user:
        name: george         # 생성할 사용자명
        home: /home/george   # 홈 디렉토리 경로
        shell: /bin/bash     # 로그인 shell
```

## 주요 옵션
- **name**: 생성할 사용자명
- **home**: 홈 디렉토리 경로
- **shell**: 로그인 shell

## 실행
```bash
ansible-playbook adduser.yml
```

## 참고
- 이미 존재하는 계정에 대해 실행하면 속성만 변경됩니다.
- 계정 삭제, 잠금 등도 user 모듈로 관리할 수 있습니다.