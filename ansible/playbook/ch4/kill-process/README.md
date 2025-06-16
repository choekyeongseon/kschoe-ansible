# Kill a Running Process

이 실습의 목적은 Ansible에서 shell 모듈을 사용해 원격 서버의 프로세스를 찾고 종료하는 방법을 익히는 것입니다.

## 실습 목적
- 프로세스 이름으로 프로세스 ID를 찾고, 해당 프로세스를 종료
- 여러 프로세스가 있을 경우 반복적으로 종료

## 예시 플레이북 (killprocess.yml)
```yaml
- name: Find a process and kill it
  hosts: 10.253.1.115
  tasks:
    - name: Get running processes from remote host
      ignore_errors: yes
      shell: "ps -few | grep top | awk '{print $2}'"
      register: running_process
    - name: Kill running processes
      ignore_errors: yes
      shell: "kill {{ item }}"
      with_items: "{{ running_process.stdout_lines }}"
```

## 실행
```bash
ansible-playbook killprocess.yml
``` 