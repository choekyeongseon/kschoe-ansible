# Kubernetes Cluster Setup (k8s/kubernetes)

## 주요 작업
- CRI-O 설치 및 설정
- 커널 모듈 및 sysctl 구성
- kubeadm/kubelet/kubectl 설치
- 마스터 및 워커 조인 명령 분리 적용

## 변수 예시
```yaml
kubernetes:
  version: v1.30.9
  pod_subnet: 10.244.0.0/16
  cri_socket: /var/run/crio/crio.sock
  image_repository: harbor.local/k8s
  control_plane_endpoint: k8s-lb:6443
  crio_rpm_files:
    - /opt/installers/crio-runtime.rpm
    - /opt/installers/crio.rpm
  k8s_rpm_files:
    - /opt/installers/kubeadm.rpm
    - /opt/installers/kubelet.rpm
    - /opt/installers/kubectl.rpm
``` 