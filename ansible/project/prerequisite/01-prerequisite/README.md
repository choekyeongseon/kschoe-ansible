# 01. 쿠버네티스 및 컨테이너 실행 환경 사전 준비

## 주요 작업

* swap 비활성화 (`swapoff -a`)
* `/etc/fstab`에서 swap 항목 주석 처리
* 방화벽 비활성화 (firewalld 또는 nftables)
* SELinux 비활성화 (`setenforce 0`, config 파일 수정)
* 모듈 로딩: `br_netfilter`, `overlay`, `ip_tables` 등
* sysctl 설정: `net.ipv4.ip_forward=1`, `bridge-nf-call-iptables=1` 등
* 시간 동기화: chronyd 또는 systemd-timesyncd 설정
* 호스트 이름 및 /etc/hosts 설정

## 자세한 작업 순서

1. hostname 설정 : hostname 설정은 변수의 y/n 유무에 따라 설정 되어야 함. 변수가 `y`일 경우, 변수에 지정된 호스트 명으로 설정 필요.
2. SELinux 해제
3. OS Swap 해제 및 VM 재시작 해도 OS Swap 해제 되도록 설정
4. firewalld 방화벽 해제

## 고려 사항
* 이 작업은 모든 VM에 동일하게 적용해야 함
* VM 마다 동일한 시간대(timezone) 및 시간 동기화가 되어 있어야 함
* 클러스터 구성 노드 간에 이름 기반 통신이 가능해야 함 (hosts 파일 또는 CoreDNS 활용)
* 재부팅 시 설정 유지 여부 확인 필요 (persist 설정)

## Ansible Role 설계

* 역할명: `prerequisite`
* 주요 태스크:

  * hostname 설정 (조건부로 변수 처리)
  * swap 비활성화 및 fstab 주석 처리
  * SELinux 설정 파일 수정 및 적용
  * 방화벽 서비스 정지 및 disable
  * 커널 모듈 로드 및 sysctl 적용
  * 시간 동기화 설정
  * hosts 이름 설정 및 hosts 파일 반영

## 변수 예시

```yaml
prerequisite:
  set_hostname: true
  hostname: node01
  timezone: Asia/Seoul
  disable_firewalld: true
  selinux_state: disabled
  kernel_modules:
    - overlay
    - br_netfilter
  sysctl_settings:
    net.ipv4.ip_forward: 1
    net.bridge.bridge-nf-call-iptables: 1
    net.bridge.bridge-nf-call-ip6tables: 1
```
