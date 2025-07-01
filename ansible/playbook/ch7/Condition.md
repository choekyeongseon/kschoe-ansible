# Ansible 조건문 (Conditions)

## ✅ 조건문이란?

- 조건문을 통해 Ansible은 **특정 조건이 만족될 때에만 작업(Task)을 실행**할 수 있습니다.
- 이는 **자동화를 더 스마트하게** 만드는 핵심 기능입니다.
- `when` 키워드를 사용하여 조건을 정의합니다.

---

## 🧠 왜 조건문이 필요한가?

- OS 종류에 따라 설치해야 할 패키지가 다를 수 있음
- 설정 값에 따라 실행할 작업을 바꿔야 할 수 있음
- 한 플레이북을 여러 환경에서 공통으로 사용하기 위함

---

## 🔁 기본 예제

```yaml
- name: 서비스 시작 조건 예제
  hosts: localhost
  tasks:
    - name: 서비스 시작
      service:
        name: servicename
        state: started
      when: A == "B"

위 예제는 변수 A가 “B”일 때만 서비스를 시작합니다.

⸻

🖥️ OS에 따라 Apache 설치 분기

- name: Apache 웹서버 설치
  hosts: localhost
  tasks:
    - name: Ubuntu에 Apache 설치
      apt:
        name: apache2
        state: present
      when: ansible_os_family == "Ubuntu"

    - name: CentOS에 Apache 설치
      yum:
        name: httpd
        state: present
      when: ansible_os_family == "RedHat"


⸻

🔍 Ansible 내장 변수 사용

Ansible은 호스트의 정보를 facts로 수집하여
내장 변수(built-in variable) 형태로 제공합니다.

예: ansible_os_family, ansible_architecture, ansible_distribution 등

전체 변수 목록을 보려면 아래 명령어 사용:

ansible localhost -m setup


⸻

📌 요약

항목	설명
when	특정 조건이 참일 경우에만 task 실행
주요 변수	ansible_os_family, ansible_distribution, ansible_hostname 등
조건 분기 예시	OS, 환경, 버전 등에 따라 태스크 다르게 실행
변수 조회	ansible <호스트> -m setup 으로 확인 가능
