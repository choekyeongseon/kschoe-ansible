# Kill a Running Process

이 실습의 목적은 Ansible에서 shell 모듈을 사용해 원격 서버의 프로세스를 찾고 종료하는 방법을 익히는 것입니다.

## 실습 배경 및 주요 개념
- 서버 운영 중 불필요하거나 비정상적으로 동작하는 프로세스를 자동으로 종료해야 할 때가 있습니다.
- Ansible의 shell 모듈과 with_items(loop)을 활용하면 여러 프로세스를 한 번에 관리할 수 있습니다.
- ps/grep/awk 등 리눅스 명령어와 연동하여 유연하게 활용 가능합니다.

## 실전 활용
- 특정 서비스/프로세스 자동 종료 및 재시작
- 배포 전 불필요한 프로세스 정리
- 장애 대응 자동화 스크립트 작성

## 실습 목적
- 프로세스 이름으로 프로세스 ID를 찾고, 해당 프로세스를 종료
- 여러 프로세스가 있을 경우 반복적으로 종료

## 예시 플레이북 (killprocess.yml)
```yaml
- name: Find a process and kill it
  hosts: 10.253.1.115
  tasks:
    # 1. 원격 호스트에서 프로세스 ID 추출
    - name: Get running processes from remote host
      ignore_errors: yes         # 에러 무시(프로세스가 없을 경우 대비)
      shell: "ps -few | grep top | awk '{print $2}'"  # 프로세스 ID 추출 명령
      register: running_process  # 결과를 변수에 저장
    # 2. 추출된 프로세스 ID 반복 종료
    - name: Kill running processes
      ignore_errors: yes         # 에러 무시(이미 종료된 경우 등)
      shell: "kill {{ item }}"   # 추출된 ID로 kill 명령 실행
      with_items: "{{ running_process.stdout_lines }}"  # 반복(loop) 처리
```

## 실행
```bash
ansible-playbook killprocess.yml
```

## 참고
- shell 모듈은 명령어 실행 결과를 register로 받아 반복(loop) 처리할 수 있습니다.
- 프로세스가 없을 경우 에러가 발생할 수 있으니 ignore_errors 옵션을 활용하세요. 