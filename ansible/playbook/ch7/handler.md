# Ansible Handler란?

## ✅ Handler 개념 요약

- Handler는 **특정 작업(task)이 변경되었을 때만 실행되는 특별한 태스크**입니다.
- 일반 태스크가 모두 끝난 **플레이의 마지막에 실행**됩니다.
- 보통 아래 작업에 사용됩니다:
  - 서비스 시작 (`start`)
  - 서비스 재시작 (`restart`)
  - 서비스 다시 로드 (`reload`)
  - 서비스 정지 (`stop`)

---

## 🧠 왜 Handler를 사용하나요?

- 어떤 설정 파일을 수정한 경우에만 서비스를 재시작하고 싶을 때 유용합니다.
- 예: Apache 설정 파일이 변경되었을 때만 서비스를 재시작하고,  
  설정이 동일하면 굳이 재시작하지 않도록 방지할 수 있습니다.

> Handler는 **변경이 감지된 경우에만 실행**되기 때문에  
> 불필요한 서비스 중단을 방지할 수 있습니다.

---

## 🔁 예시 플레이북

```yaml
---
- name: Apache 설치 및 설정
  hosts: localhost
  tasks:
    - name: Apache 최신 버전 설치
      yum:
        name: httpd
        state: latest

    - name: Apache 설정 파일 복사
      copy:
        src: /tmp/httpd.conf
        dest: /etc/httpd.conf
      notify:
        - Restart apache   # 설정이 변경되면 handler 호출

    - name: Apache 서비스 실행 확인
      service:
        name: httpd
        state: started

  handlers:
    - name: Restart apache
      service:
        name: httpd
        state: restarted


⸻

💡 주의사항
	•	Handler는 반드시 고유한 이름을 가져야 합니다.
	•	notify로 연결되지 않으면 실행되지 않습니다.
	•	여러 태스크에서 같은 handler를 호출해도, 한 번만 실행됩니다.

⸻

📌 요약

항목	설명
실행 시점	플레이북 태스크가 모두 완료된 후
실행 조건	다른 태스크에서 notify로 호출되었을 경우
용도	서비스 재시작/로드/정지 등 변경 시 필요한 후처리 작업
