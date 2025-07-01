````markdown
# 📝 Ansible Template (템플릿)

## ✅ 템플릿이란?

Ansible에서 **템플릿(template)**은 `Jinja2` 문법을 사용해 변수를 포함한 설정 파일 등을 동적으로 생성할 수 있도록 해주는 기능입니다.

주로 다음과 같은 상황에서 사용됩니다:
- 서버별로 다른 값을 가진 설정 파일 생성
- 반복되는 구조의 설정 자동 생성
- 민감 정보 포함된 파일을 암호화 없이 변수로 분리

---

## 📁 디렉터리 구조 예시

```bash
project/
├── templates/
│   └── nginx.conf.j2
├── roles/
│   └── web/
│       └── tasks/
│           └── main.yml
└── inventory
````

---

## 🔤 Jinja2 문법 기초

템플릿에서 사용하는 변수 표기법:

```jinja2
server_name {{ domain }};
listen {{ port }};
```

조건문과 반복문도 가능:

```jinja2
{% if enable_ssl %}
listen 443 ssl;
{% endif %}

{% for item in items %}
echo "{{ item }}"
{% endfor %}
```

---

## 📄 템플릿 예시 파일: `nginx.conf.j2`

```jinja2
server {
    listen {{ port }};
    server_name {{ domain }};

    location / {
        proxy_pass http://{{ backend }};
    }
}
```

---

## ▶️ 플레이북 예제: `site.yml`

```yaml
- name: 웹 서버 설정 배포
  hosts: webservers
  vars:
    port: 80
    domain: example.com
    backend: 127.0.0.1:3000

  tasks:
    - name: Nginx 설정 파일 배포
      template:
        src: nginx.conf.j2
        dest: /etc/nginx/conf.d/default.conf
```

> 🔐 템플릿은 `src` 경로가 반드시 `.j2` 파일이 아니어도 되지만, 관례적으로 `.j2` 확장자를 사용함

---

## 🧪 변수 값을 호스트별로 다르게

`inventory` 또는 `host_vars/group_vars`에서 다르게 설정하면
템플릿 안의 변수는 자동으로 호스트에 맞춰 렌더링됨.

```ini
[webservers]
web1 domain=web1.example.com
web2 domain=web2.example.com
```

---

## 🔍 결과 확인

템플릿 적용 후 실제 서버에 생성되는 파일 예시:

```nginx
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://127.0.0.1:3000;
    }
}
```

---

## 📌 요약

| 항목     | 설명                       |
| ------ | ------------------------ |
| 기능     | 설정 파일 등을 변수 기반으로 동적으로 생성 |
| 모듈     | `template:` 사용           |
| 템플릿 문법 | Jinja2                   |
| 파일 확장자 | `.j2` (관례)               |
| 주요 위치  | `templates/` 디렉터리 내      |

---

## ⚠️ 유의사항

* 템플릿 파일에 들어가는 변수는 **정의되지 않으면 오류** 발생
* `default()` 필터를 통해 기본값 설정 가능

```jinja2
listen {{ port | default(80) }};
```

* 복잡한 로직은 가능하면 변수에서 처리하고 템플릿은 단순화하는 게 유지보수에 좋음

---

Ansible 템플릿은 단순히 설정을 복사하는 수준을 넘어, **서버 환경에 따라 맞춤형 설정을 자동으로 생성**하는 핵심 도구입니다.

