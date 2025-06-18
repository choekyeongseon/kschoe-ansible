# 09. 시스템 파드 배포 (ArgoCD + GitLab)

## 목적
- ArgoCD와 GitLab을 활용해 여러 시스템 파드(calico, istio, prometheus 등) 자동 배포

## 주요 작업
- GitLab에 배포용 manifest 저장
- ArgoCD로 앱 동기화 및 배포

## 변수 예시
- app_list, gitlab_repo_url 등

## Ansible 태스크 예시
- kubectl, k8s, git 등

## 실행 예시
```bash
ansible-playbook 09-apps-with-argocd.yml -i inventory
```

## 주의사항
- 앱별 manifest, 네임스페이스, 의존성 관리 필요 