# Add or Update User Password

이 실습의 목적은 user 모듈의 update_password 옵션과 password_hash 필터를 사용해 사용자 패스워드를 안전하게 변경하는 방법을 익히는 것입니다.

## 실습 목적
- 사용자 패스워드 추가/변경 자동화
- 평문 패스워드 대신 hash 사용

## 예시 플레이북 (changepass.yml)
```yaml
- name: Add or update user password
  hosts: all
  tasks:
    - name: Change "george" password
      user:
        name: george
        update_password: always
        password: "{{ newpassword|password_hash('sha512') }}"
```

## 실행
```bash
ansible-playbook changepass.yml --extra-vars newpassword=abc123
```

## 참고
- Ansible은 평문 패스워드를 허용하지 않으므로 반드시 password_hash 필터를 사용해야 합니다. 