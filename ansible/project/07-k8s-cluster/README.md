# 07. Kubernetes Cluster 구축

## 목적
- 마스터/워커 노드로 구성된 쿠버네티스 클러스터 자동 구축

## 주요 작업
- VM 생성(마스터/워커)
- kubeadm, kubelet, kubectl 설치
- 클러스터 초기화 및 조인
- 방화벽 해제, 네트워크 플러그인 적용 등

## 변수 예시
- master_count, worker_count, k8s_version 등

## Ansible 태스크 예시
- shell, template, lineinfile, systemd 등

## 실행 예시
```bash
ansible-playbook 07-k8s-cluster.yml -i inventory
```

## 주의사항
- 노드 수, 역할 등은 변수로 유연하게 관리
- 폐쇄망 환경: 이미지, 바이너리, 패키지 모두 로컬에 위치해야 함 