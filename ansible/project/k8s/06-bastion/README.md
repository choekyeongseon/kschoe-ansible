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


## 자세한 작업 순서
1. hostname 설정 : hostname 설정은 변수의 y/n 유무에 따라 설정 되어야 함. 변수가 y 일 경우, 변수에 지정된 호스트 명으로 설정 필요.