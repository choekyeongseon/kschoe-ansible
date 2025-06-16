# Add or Update User Password

이 실습의 목적은 user 모듈의 update_password 옵션과 password_hash 필터를 사용해 사용자 패스워드를 안전하게 변경하는 방법을 익히는 것입니다.

## 실습 배경 및 주요 개념
- 보안 정책상 패스워드 변경 주기적 자동화, 신규 계정 생성 시 초기 패스워드 설정 등에 활용됩니다.
- Ansible은 평문 패스워드를 허용하지 않으므로 반드시 password_hash 필터를 사용해야 합니다.
- update_password: always 옵션을 사용하면 이미 존재하는 계정의 패스워드도 강제로 변경할 수 있습니다.

## 실전 활용
- 신규 계정 생성 후 초기 패스워드 일괄 설정
- 주기적 패스워드 변경 정책 자동화
- 보안 사고 대응 시 대량 패스워드 일괄 변경

## 예시 플레이북 (changepass.yml)
```yaml
- name: Add or update user password
  hosts: all
  tasks:
    # 1. george 계정의 패스워드 변경 (sha512 해시 사용)
    - name: Change "george" password
      user:
        name: george                       # 패스워드를 변경할 사용자명
        update_password: always            # 항상 패스워드 변경
        password: "{{ newpassword|password_hash('sha512') }}"  # sha512 해시 적용
```

## 실행
```bash
ansible-playbook changepass.yml --extra-vars newpassword=abc123
```

## 참고
- password_hash 필터는 sha512, md5 등 다양한 해시 알고리즘을 지원합니다.
- 평문 패스워드는 절대 사용하지 마세요! 