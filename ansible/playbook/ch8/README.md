````markdown
# 🔐 Ansible Vault

Ansible은 하드웨어, 운영체제, 가상화, 데이터베이스, 소프트웨어 등을 자동화할 수 있는 도구입니다.  
하지만 팀과 함께 플레이북을 공유할 때, **중요한 정보(비밀번호, API 키 등)**가 외부에 노출될 위험이 있습니다.

이때 사용하는 것이 바로 **Ansible Vault**입니다.  
Vault는 파일, 문자열, 변수 등을 **암호화하여 보호**할 수 있도록 해주는 기능입니다.

---

## 📦 암호화된 YAML 파일 생성

```bash
ansible-vault create httpbyvault.yml
````

암호화된 YAML 파일 예시:

```yaml
---
- name: Install httpd package
  hosts: localhost

  tasks:
    - name: Install package
      yum:
        name: httpd
        state: present
```

> ⚠️ 이 파일을 일반적으로 실행하면 오류 발생
> → 암호 해제 옵션을 추가해야 함

---

## ▶️ 암호화된 파일 실행

```bash
ansible-playbook httpbyvault.yml --ask-vault-pass
```

---

## 👀 Vault 파일 열람

```bash
ansible-vault view httpbyvault.yml
```

---

## ✏️ Vault 파일 편집

```bash
ansible-vault edit httpbyvault.yml
```

---

## 🔐 기존 파일 암호화

이미 존재하는 파일을 암호화하려면:

```bash
ansible-vault encrypt testbyvault.yml
```

---

## 📚 Vault 명령어 옵션 확인

```bash
ansible-vault --help
```

---

## 🔑 플레이북 내에서 문자열 암호화

Vault는 파일뿐 아니라 **개별 문자열**도 암호화할 수 있습니다.

```bash
ansible-vault encrypt_string httpd
```

출력된 문자열을 변수로 저장할 수 있습니다.

```yaml
---
- name: Test encrypted output
  hosts: localhost
  vars:
    secret: !vault |
      $ANSIBLE_VAULT;1.1;AES256
      34343066... (생략된 암호화 문자열)

  tasks:
    - name: Print encrypted string
      debug:
        var: secret
```

> 이 방식은 **플레이북 내에서 변수만 암호화**할 때 사용됩니다.

---

## 🧾 요약

| 기능              | 명령어                                       |
| --------------- | ----------------------------------------- |
| 새 파일 생성 및 암호화   | `ansible-vault create <파일명>`              |
| 기존 파일 암호화       | `ansible-vault encrypt <파일명>`             |
| 파일 보기           | `ansible-vault view <파일명>`                |
| 파일 편집           | `ansible-vault edit <파일명>`                |
| 문자열 암호화         | `ansible-vault encrypt_string <값>`        |
| 플레이북 실행 시 암호 입력 | `ansible-playbook <파일명> --ask-vault-pass` |

---

Ansible Vault는 팀 작업 시 **보안 수준을 크게 향상**시킬 수 있는 필수 기능입니다.
중요한 정보를 YAML 파일에 직접 넣는 대신, 반드시 Vault를 사용해 암호화하는 습관을 들이세요.

```
