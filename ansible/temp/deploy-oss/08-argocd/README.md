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


## 자세한 작업 순서
1. hostname 설정 : hostname 설정은 변수의 y/n 유무에 따라 설정 되어야 함. 변수가 y 일 경우, 변수에 지정된 호스트 명으로 설정 필요.