# 02. Harbor 배포

## 목적
- Harbor(프라이빗 레지스트리) VM 및 컨테이너 자동 배포

## 주요 작업
- Harbor용 VM 생성
- 도커 설치 및 harbor 이미지 로드/실행 (로컬 이미지 활용)
- harbor.yml 등 설정 파일 배포

## 변수 예시
- harbor_vm_count, harbor_image_path 등

## Ansible 태스크 예시
- docker_container, copy, template, shell 등

## 실행 예시
```bash
ansible-playbook 02-harbor.yml -i inventory
```

## 주의사항
- 폐쇄망 환경: 이미지, 설정파일 모두 로컬에 위치해야 함 