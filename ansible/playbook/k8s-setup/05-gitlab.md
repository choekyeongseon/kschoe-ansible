# 05. GitLab 배포

## 목적
- GitLab VM 및 서비스 자동 배포

## 주요 작업
- GitLab용 VM 생성
- 도커 설치 및 gitlab 이미지 실행 (로컬 이미지)
- 설정파일/볼륨 마운트 등

## 변수 예시
- gitlab_vm_count, gitlab_image_path 등

## Ansible 태스크 예시
- docker_container, copy, template 등

## 실행 예시
```bash
ansible-playbook 05-gitlab.yml -i inventory
```

## 주의사항
- 볼륨/데이터 백업 정책 필요 