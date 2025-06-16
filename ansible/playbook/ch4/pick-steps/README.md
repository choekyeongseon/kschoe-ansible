# Pick and Choose Steps

이 실습의 목적은 Ansible 플레이북에서 특정 태스크부터 실행하는 방법을 익히는 것입니다.

## 실습 목적
- 여러 태스크 중 원하는 부분만 빠르게 테스트하거나, 중단된 이후 이어서 실행할 때 사용

## 예시 명령어
```bash
ansible-playbook playbook.yml --start-at-task 'Task name'
```

## 예시 플레이북
```yaml
- name: httpd and telnet
  hosts: all
  tasks:
    - name: Install httpd
      yum:
        name: httpd
        state: present
    - name: Start httpd
      service:
        name: httpd
        state: started
    - name: Install telnet
      yum:
        name: telnet
        state: present
```

## 활용 예시
- 여러 태스크 중 특정 태스크부터 실행하고 싶을 때
- 반복 테스트, 디버깅, 중단된 작업 이어서 실행 등 