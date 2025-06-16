
# 📘 Ansible Ad-Hoc Commands

이 문서는 반복되지 않는 일회성 작업을 위해 Ansible Ad-Hoc 명령어를 사용하는 방법을 다룹니다.  
Ad-Hoc 명령은 빠르게 작업을 처리하거나 테스트할 때 유용합니다.

---

## 🧩 기본 문법

```bash
ansible [대상 호스트] -m [모듈] -a "[모듈 옵션들]"
```

- `-m`: 사용할 모듈 (예: ping, copy, file, yum, service 등)
- `-a`: 모듈에 전달할 인자
- `-i`: 인벤토리 파일 지정 (생략 시 기본: `/etc/ansible/hosts`)

---

## 💡 주요 예제 모음

### ✅ Ping 테스트
```bash
ansible localhost -m ping
```
- **목적**: 대상 서버 연결 여부 확인
- **결과**: 정상일 경우 `pong` 출력

---

### 📁 파일 생성 및 삭제

#### ▶️ 파일 생성
```bash
ansible all -m file -a "path=/home/user/test.txt state=touch mode=600"
```
- `path`: 생성할 파일 경로
- `state=touch`: 파일 생성
- `mode=600`: 권한 설정

#### ❌ 파일 삭제
```bash
ansible all -m file -a "path=/home/user/test.txt state=absent"
```
- `state=absent`: 해당 경로의 파일 삭제

---

### 📄 파일 복사
```bash
ansible all -m copy -a "src=/tmp/file.txt dest=/home/user/file.txt"
```
- `src`: 컨트롤 노드에 있는 파일 경로
- `dest`: 대상 서버에서의 저장 경로

---

### 📦 패키지 설치/삭제

#### ▶️ 패키지 설치
```bash
ansible all -m yum -a "name=httpd state=present"
```

#### ❌ 패키지 삭제
```bash
ansible all -m yum -a "name=httpd state=absent"
```
- `yum` 모듈은 RHEL 계열에서 사용
- `state=present`: 설치 / `state=absent`: 제거

---

### 🛠 서비스 제어

#### ▶️ 서비스 시작
```bash
ansible all -m service -a "name=httpd state=started"
```

#### ▶️ 부팅 시 자동 시작
```bash
ansible all -m service -a "name=httpd state=started enabled=yes"
```

---

### 👤 사용자 관리

#### ▶️ 유저 생성
```bash
ansible all -m user -a "name=jsmith state=present shell=/bin/bash"
```

#### ❌ 유저 삭제
```bash
ansible all -m user -a "name=jsmith state=absent"
```

---

### 🖥 시스템 정보 수집

```bash
ansible all -m setup
```
- 목적: 대상 시스템의 하드웨어, OS, 네트워크 정보 등을 가져옴
- 출력이 많음 → `| less` 혹은 `--filter` 옵션 사용 가능

---

### ⚡ 원격 쉘 명령 실행

```bash
ansible all -m shell -a "systemctl status httpd"
```

또는 별도 모듈 없이 직접 실행:
```bash
ansible client1 -a "/sbin/reboot"
```

---

## 🔚 참고 사항

- Ad-Hoc 명령어는 **긴급 대응**이나 **테스트용**으로 적합
- 자주 반복되는 작업은 **Playbook 또는 Role**로 구성할 것
