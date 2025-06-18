Ansible 기반 폐쇄망 인프라 자동화 설계 문서

✅ 설계 목적

폐쇄망 환경에서 VM 기반 인프라를 자동화로 구축하고, 도커 기반 서비스 및 쿠버네티스 클러스터를 Ansible을 통해 일관되게 배포 및 관리함. 최종적으로 GitOps 기반으로 ArgoCD와 GitLab을 통해 인프라 서비스(Calico, Istio 등)를 자동화 배포한다.

⸻

✅ 전체 서비스 구성 순서

순서	구성요소	유형	관련 조건 / 설명
1	Harbor	VM + Docker	로커 이미지 활용, 포트 바인딩
2	CoreDNS	VM + Docker	hosts 파일 필요, 내부 DNS 기능
3	자사 서비스	VM + Docker	Harbor 또는 CoreDNS 보관
4	GitLab	VM + Docker	GitOps 기반 통사 통보
5	Bastion	VM	SSH/네트워크 중계기
6	K8s Cluster	VM (kubeadm)	방화범 해제, 현개 건설
7	ArgoCD	K8s App	GitLab 연동 설정 필요
8	Infra Apps	K8s App	ArgoCD가 발행 (calico, istio, prometheus)


⸻

✅ Role 기능 정보

Role 이름	기능 요약
vm_provision	VM 처음 설정, terraform/개발기 연동 (optional)
common	OS 통역 테크입 설정, 방화범, 버전, docker 설치
harbor	docker 기반 harbor 실행, config/secret 설정
coredns	docker 기반 CoreDNS 설정, hosts 파일 동기화
internal_service	자사 서비스 docker 실행
gitlab	GitLab 설치 및 초기 프로젝트 구성
bastion	SSH 프록시/접속 중계 설정
kubernetes	kubeadm 기반 마스터/워커 배포, 방화벽 해제 등
argocd	ArgoCD 배포, GitLab 연동 설정
deploy_apps	ArgoCD Application CR 배포 (calico, istio 등)


⸻

✅ Inventory 설계

all:
  children:
    harbor:
      hosts:
        harbor01:
    coredns:
      hosts:
        coredns01:
    gitlab:
      hosts:
        gitlab01:
    bastion:
      hosts:
        bastion01:
    service:
      hosts:
        service01:
    master:
      hosts:
        master1:
        master2:
        master3:
    worker:
      hosts:
        worker1:
        worker2:
        worker3:


⸻

✅ 실행 단계별 Playbook 흐름

단계	Playbook 이름	설명
01	setup_harbor.yml	Harbor VM → Docker 설치 → Harbor 기동
02	setup_coredns.yml	CoreDNS 컨테이너 실행 + hosts 적용
03	deploy_internal.yml	자사 서비스 배포 (컨테이너)
04	setup_gitlab.yml	GitLab 설치 및 SSH Key 준비
05	setup_bastion.yml	중계 VM SSH 및 라우팅 구성
06	deploy_k8s.yml	kubeadm 기반 클러스터 구성
07	deploy_argocd.yml	K8s 내 ArgoCD 배포
08	deploy_apps.yml	ArgoCD Application CR 생성 (calico, etc)


⸻

✅ 변수 설계 기준
	•	group_vars/all.yml → 전체 공통 변수 (K8s 버전, 도커 경로, 시간대 등)
	•	group_vars/<role>.yml → 역할별 세부 설정 변수
	•	환경별 분리 시 host_vars/ 고려 가능

⸻

✅ 확장/유지보수 고려 사항

항목	전략
VM 수 유동성	inventory 에서 그룹만 늘리면 자동 대응
재사용	Role 단위 템플릿화, 변수파일 분리로 구성
롤백	idempotent task 구성 + 상태 체크 조건 처리
GitOps 확장	ArgoCD App-of-Apps 또는 Helm + Argo 연계 가능
테스트 전략	ansible-playbook --check, 단계별 tag 사용


⸻

✅ 다음 단계 제안
	1.	해당 설계 기준으로 팀과 공유 가능한 문서화 진행 (이 문서)
	2.	inventory/hosts.yml 작성 (초기 IP 입력)
	3.	group_vars/all.yml 구성
	4.	Harbor부터 Role 및 Task 구성 → 소규모 테스트 시작