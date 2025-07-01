
# Ansible 반복문 (Loops)

## ✅ Loop이란?

- 루프는 특정 작업을 **여러 번 반복해서 수행**할 수 있도록 해주는 Ansible의 기능입니다.
- 반복 작업을 수동으로 하나씩 작성하는 대신, loop를 사용하여 **동일한 작업을 여러 항목에 적용**할 수 있습니다.

---

## 🧠 왜 Loop이 필요한가?

다음과 같은 작업에서 유용하게 사용됩니다:

- 수십 명의 사용자 생성
- 여러 패키지 설치
- 수백 개의 파일 권한 설정

---

## 👤 사용자 생성 예제

리눅스에서 다음과 같이 반복문을 사용할 수 있습니다:

```bash
for u in jerry kramer eliane; do useradd $u; done

Ansible에서는 아래처럼 작성할 수 있습니다:

예제 1: loop 사용

# userbyloop1.yml
---
- name: Create users thru loop
  hosts: localhost

  tasks:
    - name: Create users
      user:
        name: "{{ item }}"
      loop:
        - jerry
        - kramer
        - eliane

예제 2: 변수 + with_items 사용

# userbyloop2.yml
---
- name: Create users thru loop
  hosts: localhost
  vars:
    users: [jerry, kramer, eliane]

  tasks:
    - name: Create users
      user:
        name: "{{ item }}"
      with_items: "{{ users }}"


⸻

📦 패키지 설치 예제

리눅스 명령 예시:

for p in ftp telnet htop; do yum install $p -y; done

Ansible로는 이렇게 쓸 수 있습니다:

예제 1: 변수 + with_items 사용

# installbyloop1.yml
---
- name: Install packages thru loop
  hosts: localhost
  vars:
    packages: [ftp, telnet, htop]

  tasks:
    - name: Install package
      yum:
        name: "{{ item }}"
        state: present
      with_items: "{{ packages }}"

예제 2: 변수 + loop 사용 (권장 방식)

# installbyloop2.yml
---
- name: Install packages thru loop
  hosts: localhost
  vars:
    packages: [ftp, telnet, htop]

  tasks:
    - name: Install package
      yum:
        name: "{{ item }}"
        state: present
      loop: "{{ packages }}"


⸻

🔍 loop vs with_items 차이

항목	설명
loop	최신 문법, 대부분의 반복에서 사용
with_items	구 버전 문법, 일부 호환 목적 사용

→ 되도록이면 loop 사용을 권장합니다.

⸻

📌 요약
	•	반복할 항목이 많아질수록 loop를 사용하면 코드가 짧고 깔끔해집니다.
	•	반복할 대상은 직접 작성하거나 vars에 리스트로 정의할 수 있습니다.
	•	다른 반복 패턴(with_dict, with_nested, with_subelements 등)도 있지만, 대부분의 경우 loop로 충분합니다.

