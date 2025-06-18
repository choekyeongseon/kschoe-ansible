# 06. Bastion VM 배포

## 목적
- Bastion(중앙 관리/접속) VM 자동 배포

## 주요 작업
- Bastion VM 생성
- SSH, 관리도구 설치 등

## 변수 예시
- bastion_vm_count 등

## Ansible 태스크 예시
- user, authorized_key, copy 등

## 실행 예시
```bash
ansible-playbook 06-bastion.yml -i inventory
```

## 주의사항
- 접근 제어, 키 관리 정책 필요 