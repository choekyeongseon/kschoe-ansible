# 08. ArgoCD 배포

## 목적
- 구축된 쿠버네티스 클러스터에 ArgoCD 설치 및 연동

## 주요 작업
- ArgoCD 매니페스트 적용
- 초기 관리자 패스워드 설정 등

## 변수 예시
- argocd_namespace, argocd_manifest_path 등

## Ansible 태스크 예시
- kubectl, k8s, copy 등

## 실행 예시
```bash
ansible-playbook 08-argocd.yml -i inventory
```

## 주의사항
- kubectl context, 인증 등 사전 준비 필요 