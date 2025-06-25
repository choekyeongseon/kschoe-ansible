# Prerequisite 시스템 설정 (prerequisite/system)

## 주요 작업
* swap 비활성화 (`swapoff -a`)
* `/etc/fstab`에서 swap 항목 주석 처리
* 방화벽 비활성화 (firewalld 또는 nftables)
* SELinux 비활성화 (`setenforce 0`, config 파일 수정)

## 변수 예시
```yaml
prerequisite_kernel_params:
  - name: vm.swappiness
    value: "1"
  - name: vm.max_map_count
    value: "262144"
``` 