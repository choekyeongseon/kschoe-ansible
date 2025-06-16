
# 🔧 Ansible Variables

Ansible 변수는 반복 사용되는 값을 설정 파일 내에서 재활용할 수 있도록 해줍니다.

---

## 🧠 변수 정의 규칙

- 변수명은 문자, 숫자, 밑줄 사용 가능
- 문자로 시작해야 함
- 공백, 점(.), 하이픈(-) 포함 불가

---

## 📄 Playbook 내 변수 예시

```yaml
- name: Install and start service
  hosts: all
  vars:
    pack: httpd
  tasks:
    - name: Install package
      yum:
        name: "{{ pack }}"
        state: present
    - name: Start service
      service:
        name: "{{ pack }}"
        state: started
```

---

## 📄 파일 경로를 변수로

```yaml
vars:
  srcfile: /home/user/test.txt

tasks:
  - name: Copy file
    copy:
      src: "{{ srcfile }}"
      dest: /tmp/
```

---

## 🗂 인벤토리 파일 내 변수 사용

```ini
[webservers]
server1 ansible_host=192.168.0.10

[webservers:vars]
ntpserver=ntp.example.com
proxyserver=proxy.example.com
```

---

## 🔄 실전 예제

```yaml
- name: Print message
  hosts: all
  vars:
    say: Hello World!
  tasks:
    - name: Print
      debug:
        msg: "{{ say }}"
```


---

## 📘 변수 우선순위 (중요)

Ansible 변수는 정의 위치에 따라 우선순위가 다릅니다 (낮음 → 높음 순):

1. Role defaults (`roles/rolename/defaults/main.yml`)
2. Inventory 파일 내 변수
3. Playbook 내 vars
4. Task 내 vars
5. Extra vars (명령줄 `-e` 옵션 사용 시)

---

## 🎯 변수의 활용 포인트

- 환경별 설정 분리
- 패키지 이름, 포트, 파일 경로 등을 동적으로 처리
- 템플릿 파일(.j2)과 조합 시 매우 강력

---

## 🧪 실수 방지를 위한 팁

- 변수명이 복잡하거나 헷갈릴 경우, `debug` 모듈로 중간값 확인
```yaml
- name: Print debug
  debug:
    var: some_var
```

- 조건문에서도 변수 사용 가능
```yaml
when: ansible_os_family == "RedHat"
```
