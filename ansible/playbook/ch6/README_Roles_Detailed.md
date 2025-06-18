
# 📘 Ansible Roles

Ansible Roles는 복잡한 Playbook을 구조적으로 관리하고 재사용 가능하게 만드는 기능입니다.

---

## 🔹 개요

- **Roles**는 Tasks, Variables, Handlers 등을 논리적으로 그룹화한 디렉토리 구조
- 복잡한 작업을 여러 파일로 나누어 관리 가능
- 환경별 분리, 재사용성 향상, 협업에 유리

---

## 📁 기본 디렉토리 구조 예시

```bash
/etc/ansible/roles/
└── webserver/
    ├── tasks/
    │   └── main.yml
    ├── vars/
    │   └── main.yml
    ├── handlers/
    │   └── main.yml
```

---

## 🛠 Role 생성 절차

```bash
cd /etc/ansible/roles
mkdir fullinstall
mkdir fullinstall/tasks
touch fullinstall/tasks/main.yml
```

---

## 📋 예시

```yaml
# playbook.yml
- name: Full install
  hosts: east-webservers
  roles:
    - fullinstall
```

```yaml
# fullinstall/tasks/main.yml
- name: Install httpd package
  yum:
    name: httpd
    state: present

- name: Start httpd
  service:
    name: httpd
    state: started

- name: Open port
  firewalld:
    service: http
    permanent: true
    state: enabled

- name: Restart firewalld
  service:
    name: firewalld
    state: reloaded
```

---

## 🌐 Ansible Galaxy 사용

- 사전 정의된 Role을 다운로드 가능
- 주소: [https://galaxy.ansible.com](https://galaxy.ansible.com)


---

## 📘 주요 개념 정리

### 1. Role 디렉토리 구성
각 디렉토리는 특정 기능 단위로 구성되며 다음과 같은 구성 요소를 포함할 수 있습니다:

| 디렉토리 이름 | 설명 |
|---------------|------|
| `tasks/`      | 실행할 작업들을 정의하는 곳 (반드시 필요) |
| `handlers/`   | 특정 작업 이후 호출되는 핸들러 정의 |
| `vars/`       | 일반적인 변수 정의 파일 |
| `defaults/`   | 기본값 변수 정의, 사용자가 덮어쓸 수 있음 |
| `files/`      | 배포할 파일들 위치 |
| `templates/`  | Jinja2 템플릿 위치 |
| `meta/`       | Role의 의존성 등 메타 정보 |

---

## 🎯 언제 Roles를 써야 할까?

- 여러 환경(dev/test/prod)에 공통 설정을 적용해야 할 때
- 여러 팀이 같은 작업을 공유할 때
- 반복되는 Playbook 블록이 많을 때
- Playbook이 지나치게 길고 복잡해졌을 때



-----

# Ansible Role 기반 Playbook 구성 가이드

Ansible의 **Role** 기능은 복잡한 Playbook을 더 작은 단위로 분리하여 구성, 재사용, 관리가 쉬운 형태로 만드는 데 유용합니다.

## ✅ Role이란?

- 복잡한 Playbook을 `tasks`, `handlers`, `variables` 등으로 나눠 관리할 수 있게 해줍니다.
- 역할별로 디렉토리를 분리하고 각 디렉토리 내에서 필요한 작업들을 정의합니다.
- 여러 환경이나 서버 유형에 따라 역할(Role)을 구분하면 유지보수와 코드 공유가 쉬워집니다.

---

## 📦 예시: 웹 서버 Role 구분

### 시나리오
- **East Web Servers**: `httpd` 패키지 설치, 서비스 시작, 방화벽 설정 포함
- **West Web Servers**: `httpd` 패키지 설치 및 서비스 시작만 수행

---

## 📁 디렉토리 구조

```
/etc/ansible/
├── roles/
│   ├── full_install/
│   │   └── tasks/
│   │       └── main.yml
│   └── basic_install/
│       └── tasks/
│           └── main.yml
└── playbooks/
    └── by_role.yml
```

---

## 📜 Role 구성 예시

### `roles/full_install/tasks/main.yml`
```yaml
---
- name: Install httpd
  yum:
    name: httpd
    state: present

- name: Start httpd service
  service:
    name: httpd
    state: started

- name: Allow HTTP through firewall
  firewalld:
    service: http
    permanent: yes
    state: enabled
    immediate: yes

- name: Reload firewalld
  service:
    name: firewalld
    state: reloaded
```

### `roles/basic_install/tasks/main.yml`
```yaml
---
- name: Install httpd
  yum:
    name: httpd
    state: present

- name: Start httpd service
  service:
    name: httpd
    state: started
```

---

## ▶️ 최종 Playbook (`playbooks/by_role.yml`)
```yaml
---
- name: Full Install
  hosts: east_webservers
  roles:
    - full_install

- name: Basic Install
  hosts: west_webservers
  roles:
    - basic_install
```

---

## 💡 운영 팁

- 역할은 **서버 유형**, **기능**, **부서별 요구사항** 등에 따라 구분할 수 있습니다.
- 역할 안의 디렉토리 및 파일 명은 Ansible이 자동으로 인식하는 구조이므로 변경하면 안 됩니다 (`tasks/main.yml` 등).
- `ansible-playbook by_role.yml` 명령으로 전체 플레이북 실행.

---

## ✅ 결과 검증

각 Role에 따라 지정된 패키지가 설치되고 서비스가 동작함을 다음 명령어로 확인 가능:

```bash
rpm -q httpd
systemctl status httpd
firewall-cmd --list-all
```

---

Ansible Role을 사용하면 유지보수와 협업, 재사용성이 크게 향상됩니다.
