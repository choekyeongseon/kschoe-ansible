
# 🏷 Ansible Tags

Tags는 Playbook 실행 시 특정 작업만 선택적으로 실행하거나 건너뛸 수 있게 해주는 기능입니다.

---

## 🎯 사용 목적

- 전체 Playbook 중 특정 작업만 실행하고 싶을 때
- 반복 실행 없이 빠르게 테스트하거나 디버깅할 때 유용

---

## 📄 예시 Playbook

```yaml
- name: Setup Apache server
  hosts: localhost
  tasks:
    - name: Install httpd
      yum:
        name: httpd
        state: present
      tags: install

    - name: Start httpd
      service:
        name: httpd
        state: started
      tags: start
```

---

## ⚙️ 실행 명령 예시

```bash
# install 태그만 실행
ansible-playbook httpd.yml --tags install

# 태그 목록 보기
ansible-playbook httpd.yml --list-tags

# 특정 태그 제외하고 실행
ansible-playbook httpd.yml --skip-tags install

# 특정 태스크에서 시작
ansible-playbook httpd.yml --start-at-task "Start httpd"
```


---

## 📘 Tags 관련 주의사항 및 팁

- Tags는 `tasks`, `roles`, `block` 에 적용 가능
- 여러 태그를 동시에 지정하려면 리스트로:
```yaml
tags:
  - install
  - web
```

- 태그는 작업 단위로 필터링 가능하므로, 대규모 플레이북 디버깅 시 매우 유용함

---

## 🚫 한계점

- 태그 이름 중복 시 모든 매칭 태스크가 실행됨
- 태그로 건너뛴 태스크 간 의존성 충돌 주의

