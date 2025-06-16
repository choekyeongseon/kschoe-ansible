
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

