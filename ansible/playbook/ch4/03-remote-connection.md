# Ansible 원격 클라이언트 연결 설정

## 1. 개요
원격 클라이언트와의 연결을 설정하는 방법을 설명합니다. Ansible은 SSH를 통해 원격 호스트와 통신하므로, 적절한 SSH 설정이 필요합니다.

## 2. 기본 설정 단계

### 2.1 Linux 클라이언트 준비
1. 클라이언트 시스템 스냅샷 생성
2. 시스템 부팅 및 IP 주소 확인
3. Python이 설치되어 있는지 확인 (Ansible 요구사항)

### 2.2 Inventory 설정
1. hosts 파일에 클라이언트 정보 추가:
   ```ini
   [labclients]
   10.253.1.18
   10.253.1.20
   ```

## 3. SSH 연결 설정

### 3.1 SSH 키 생성
컨트롤 노드에서 SSH 키 생성:
```bash
# ssh-keygen
# Leave everything default and enter
```

### 3.2 SSH 키 배포
클라이언트로 SSH 키 복사:
```bash
# ssh-copy-id 10.253.1.18
# ssh-copy-id 10.253.1.20
```

### 3.3 패스워드 없는 SSH 연결 설정
1. authorized_keys 파일 권한 확인
2. SSH 설정 파일 수정 (필요한 경우):
   ```bash
   # vi ~/.ssh/config
   Host *
       StrictHostKeyChecking no
   ```

## 4. 연결 테스트

### 4.1 SSH 연결 테스트
직접 SSH 접속 테스트:
```bash
# ssh 10.253.1.18
```

### 4.2 Ansible 연결 테스트
1. 기본 ping 테스트:
   ```bash
   # ansible all -m ping
   ```

2. 원격 명령어 실행 테스트:
   ```bash
   # ansible -a "uptime" all  # 모든 호스트에서 uptime 명령어 실행
   ```

## 5. 문제 해결
- SSH 키 권한 문제
  - ~/.ssh 디렉토리: 700 (drwx------)
  - ~/.ssh/id_rsa: 600 (-rw-------)
  - ~/.ssh/id_rsa.pub: 644 (-rw-r--r--)
  - ~/.ssh/authorized_keys: 600 (-rw-------)

- Python 설치 여부
  - Control Node: python3 필수
  - Managed Node: python3 필수

- 방화벽 설정
  - SSH 포트(기본 22) 개방 확인
  - SELinux가 활성화된 경우 SSH 접속 허용

- SELinux 설정
  - SELinux 모드 확인: `getenforce`
  - 필요한 경우 임시 비활성화: `setenforce 0`

## 6. 보안 고려사항

### 6.1 SSH 키 관리
- 프라이빗 키 백업
- 정기적인 키 로테이션
- 미사용 키 제거

### 6.2 사용자 권한 설정
- 최소 권한 원칙 적용
- sudo 권한 제한적 부여
- 공유 계정 사용 제한

### 6.3 네트워크 보안
- SSH 포트 변경 고려
- 접근 제어 리스트(ACL) 설정
- 점프 호스트 사용 검토

### 6.4 감사 로깅
- SSH 접속 로그 모니터링
- Ansible 작업 로그 기록
- 실패한 접속 시도 추적 