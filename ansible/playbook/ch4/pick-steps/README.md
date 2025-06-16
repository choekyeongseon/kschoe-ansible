# Pick and Choose Steps

이 실습의 목적은 Ansible 플레이북에서 특정 태스크부터 실행하는 방법을 익히는 것입니다.

## 실습 배경 및 주요 개념
- 플레이북이 길거나, 중간에 실패한 경우 특정 태스크부터 이어서 실행하고 싶을 때 유용합니다.
- 반복 테스트, 디버깅, 일부 태스크만 빠르게 재실행할 때 활용합니다.
- --start-at-task 옵션은 태스크의 name과 정확히 일치해야 하므로 오타에 주의하세요.

## 실전 활용
- 대규모 배포 작업 중 일부 단계만 재실행
- 개발/테스트 환경에서 반복적으로 특정 태스크만 실행

## 예시 명령어
```bash
ansible-playbook playbook.yml --start-at-task 'Task name'
```

## 예시 플레이북
```yaml
- name: httpd and telnet
  hosts: all
  tasks:
    # 1. httpd 설치
    - name: Install httpd
      yum:
        name: httpd         # 설치할 패키지명
        state: present      # 패키지가 설치된 상태로 유지
    # 2. httpd 서비스 시작
    - name: Start httpd
      service:
        name: httpd         # 서비스명
        state: started      # 서비스가 실행 중이어야 함
    # 3. telnet 설치
    - name: Install telnet
      yum:
        name: telnet        # 설치할 패키지명
        state: present      # 패키지가 설치된 상태로 유지
```

## 활용 예시
- 여러 태스크 중 특정 태스크부터 실행하고 싶을 때
- 반복 테스트, 디버깅, 중단된 작업 이어서 실행 등 