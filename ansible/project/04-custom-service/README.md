# 04. Custom Service 배포

## 목적
- 자사 서비스(컨테이너) VM 및 컨테이너 자동 배포

## 주요 작업
- 서비스용 VM 생성
- 도커 설치 및 서비스 이미지 실행 (로컬 이미지)
- 환경변수/설정파일 배포

## 변수 예시
- service_vm_count, service_image_path 등

## Ansible 태스크 예시
- docker_container, copy, template 등

## 실행 예시
```bash
ansible-playbook 04-custom-service.yml -i inventory
```

## 주의사항
- 서비스별 환경변수/설정파일 관리 필요 