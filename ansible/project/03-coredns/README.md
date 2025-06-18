# 03. CoreDNS 배포

## 목적
- CoreDNS를 별도 VM에 컨테이너로 배포, 내부 도메인 서비스 제공

## 주요 작업
- CoreDNS VM 생성
- 도커 설치 및 coredns 이미지 실행 (로컬 이미지)
- 도메인(zone) 파일 배포 및 컨테이너 마운트

## 변수 예시
- coredns_vm_count, coredns_domain_file 등

## Ansible 태스크 예시
- docker_container, copy, template 등

## 실행 예시
```bash
ansible-playbook 03-coredns.yml -i inventory
```

## 주의사항
- 도메인(zone) 파일은 반드시 최신 상태로 준비 