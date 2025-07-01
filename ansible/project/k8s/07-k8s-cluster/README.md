# 12. Kubernetes Cluster Setup

## 주요 작업 (모든 마스터 및 워커 노드 공통)

### 1. CRI-O 설치

* CRI-O 디렉토리 생성
* CRI-O 설치용 RPM 복사
* 로컬 RPM 설치 수행

### 2. CRI-O 설정

* 커널 모듈 설정 파일 작성

  ```bash
  cat <<EOF | sudo tee /etc/modules-load.d/crio.conf
  overlay
  br_netfilter
  EOF

  cat <<EOF | sudo tee /etc/modules-load.d/istio-iptables.conf
  br_netfilter
  nf_nat
  xt_REDIRECT
  xt_owner
  iptable_nat
  iptable_mangle
  iptable_filter
  EOF
  ```

  * 이유: `overlay`, `br_netfilter` 모듈은 컨테이너 네트워크 및 파일시스템 동작에 필수

* 커널 모듈 즉시 적재

  ```bash
  modprobe overlay
  modprobe br_netfilter
  modprobe nf_nat
  modprobe xt_REDIRECT
  modprobe xt_owner
  modprobe iptable_nat
  modprobe iptable_mangle
  modprobe iptable_filter
  ```

  * 확인: `lsmod | grep -E 'overlay|br_netfilter'`

* 브리지 네트워크 관련 sysctl 파라미터 설정

  ```bash
  cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
  net.bridge.bridge-nf-call-iptables = 1
  net.ipv4.ip_forward = 1
  net.bridge.bridge-nf-call-ip6tables = 1
  EOF
  ```

* 설정 적용 및 CRI-O 서비스 기동

  ```bash
  sudo sysctl --system
  sudo systemctl daemon-reload
  sudo systemctl enable crio
  sudo systemctl start crio
  sudo systemctl status crio
  ```

### 3. kubeadm, kubelet, kubectl 설치

* kubernetes-install 디렉토리 생성
* kubeadm, kubelet, kubectl 설치용 RPM 복사
* 설치 실행

---

## 클러스터 구성 작업 (마스터 노드 기준)

### 4. 마스터 노드 조인 (다중 마스터 구성 시)

* 첫 번째 마스터는 `kubeadm init`으로 클러스터 초기화
* 이후 마스터 노드는 `--control-plane` 플래그를 포함하여 조인 수행

### 5. 워커 노드 조인

* 각 워커 노드는 마스터에서 생성된 조인 토큰으로 `kubeadm join` 실행

---

## Ansible Role 설계

* 역할명: `kubernetes`
* 주요 태스크:

  * CRI-O 설치 및 설정
  * 커널 모듈 및 sysctl 구성
  * kubeadm/kubelet/kubectl 설치
  * 마스터 및 워커 조인 명령 분리 적용

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
