# Ansible을 사용한 Shell Script 실행 및 Cron Job 스케줄링

이 장에서는 Ansible을 사용하여 원격 클라이언트에서 shell script를 실행하고, cron job을 스케줄링하는 방법을 학습합니다.

## 1. Shell Script 실행

### 1.1 개요
- 원격 클라이언트에서 shell script 실행
- shell 모듈을 사용한 스크립트 실행
- 실행 권한 및 보안 고려사항

### 1.2 Playbook 구성
```yaml
# shellscript.yml
---
- name: Playbook for shell script
  hosts: all  # 또는 특정 호스트
  tasks:
    - name: Run shell script
      shell: "/home/iafzal/cfile.sh"
```

### 1.3 주요 구성 요소
- shell 모듈 사용
- 스크립트 경로 지정
- 실행 권한 설정
- 결과 확인 방법

## 2. Cron Job 스케줄링

### 2.1 개요
- cron 작업 자동화
- 정기적인 작업 스케줄링
- root 권한으로 작업 실행

### 2.2 Playbook 구성
```yaml
# cronjob.yml
---
- name: Create a cron job
  hosts: all
  tasks:
    - name: Schedule cron
      cron:
        name: "This job is scheduled by Ansible"
        minute: "0"
        hour: "10"
        day: "*"
        month: "*"
        weekday: "4"
        user: root
        job: "/home/iafzal/cfile.sh"
```

### 2.3 Cron 설정 요소
- minute: 분 (0-59)
- hour: 시간 (0-23)
- day: 일 (1-31)
- month: 월 (1-12)
- weekday: 요일 (0-6, 0=일요일)
- user: 실행 사용자
- job: 실행할 명령어 또는 스크립트

## 3. 실습 준비사항

1. 필요한 디렉토리 구조:
```
ansible/playbook/ch4/shell-scripts/
├── shellscript.yml
├── cronjob.yml
└── scripts/
    └── cfile.sh
```

2. 권한 설정:
- 스크립트 실행 권한: `chmod +x scripts/cfile.sh`
- sudo 권한 필요 시 설정

3. 호스트 설정:
- inventory 파일에 대상 호스트 정의
- SSH 접속 가능 확인

## 4. 주의사항

1. 보안:
   - 스크립트 실행 권한 관리
   - root 권한 사용 시 주의
   - 민감한 정보 보호

2. 모니터링:
   - 작업 실행 로그 확인
   - 오류 발생 시 디버깅
   - 실행 결과 검증

3. 유지보수:
   - 스크립트 버전 관리
   - 문서화
   - 백업 관리 