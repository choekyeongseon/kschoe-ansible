# Chapter 4: Ansible 기본 개념

이 챕터에서는 Ansible의 핵심 개념들을 다룹니다.

## 목차

1. [Hosts 파일 구문](01-hosts.md)
   - 정적/동적 인벤토리
   - 호스트 파일 작성법
   - 호스트 그룹 관리

2. [File Permissions](02-permissions.md)
   - 파일 권한 개념
   - 권한 설정 방법

3. [원격 클라이언트 연결 설정](03-remote-connection.md)
   - SSH 키 설정
   - 클라이언트 연결 테스트
   - 문제 해결 방법

4. [Shell Scripts 실행](shell-scripts/)
   - 원격 서버에서 스크립트 실행
   - 스크립트 파일 전송 및 권한 설정
   - 실행 결과 수집 및 확인

5. [Cron Job 스케줄링](shell-scripts/)
   - cron 작업 생성 및 관리
   - 주기적 작업 자동화
   - 시스템 정보 수집 자동화

6. [Create and Mount New Storage](storage-mount/README.md)
   - 신규 디스크 파티션/파일시스템/마운트 자동화

7. [Pick and Choose Steps](pick-steps/README.md)
   - 특정 태스크부터 플레이북 실행

8. [Download Package from a URL](url-download/README.md)
   - get_url로 외부 패키지 다운로드

9. [Kill a Running Process](kill-process/README.md)
   - shell로 프로세스 찾고 종료

10. [User Account Management](user-management/README.md)
    - user 모듈로 계정 생성

11. [Add or Update User Password](user-password/README.md)
    - user 모듈로 패스워드 변경

## 학습 목표
- Ansible 인벤토리 관리 방법 이해
- 호스트 파일 작성 및 구성 방법 습득
- 원격 클라이언트 연결 설정 방법 학습
- 파일 권한 관리 방법 이해
- Shell Script 실행 및 관리 방법 습득
- Cron Job을 통한 작업 자동화 구현
- **주제별 실전 플레이북 작성 및 활용법 습득**

## 실습 환경
- Control Node: 13.125.229.192
- Target Node: 54.180.109.214
- OS: Amazon Linux 2
- SSH Key: ~/.ssh/ansible.pem

## ssh -i ~/.ssh/ansible.pem ec2-user@54.180.109.214 

---

각 playbook 예제는 위 디렉토리의 README에서 자세히 확인할 수 있습니다. 