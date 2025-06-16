# Create and Mount New Storage

이 실습의 목적은 Ansible을 사용해 새로운 디스크에 파티션을 만들고, 파일시스템(xfs)을 생성한 뒤, 디렉토리를 만들고 마운트하는 과정을 자동화하는 것입니다.

## 실습 목적
- 신규 디스크(/dev/sdb)에 파티션(/dev/sdb1) 생성
- xfs 파일시스템 생성
- /data 디렉토리 생성 및 마운트
- 모든 작업을 Ansible 플레이북으로 자동화

## 예시 플레이북(newstorage.yml)
```yaml
- name: Create and mount new storage
  hosts: all
  tasks:
    - name: create new partition
      parted:
        name: files
        label: gpt
        device: /dev/sdb
        number: 1
        state: present
        part_start: 1MiB
        part_end: 1GiB
    - name: Create xfs filesystem
      filesystem:
        dev: /dev/sdb1
        fstype: xfs
    - name: Create mount directory
      file:
        path: /data
        state: directory
    - name: mount the filesystem
      mount:
        src: /dev/sdb1
        fstype: xfs
        state: mounted
```

## 주요 모듈
- parted: 파티션 생성
- filesystem: 파일시스템 생성
- file: 디렉토리 생성
- mount: 파일시스템 마운트

## collection 설치
일부 환경에서는 아래 명령어로 모듈을 설치해야 합니다.
- `ansible-galaxy collection install community.general`
- `ansible-galaxy collection install ansible.posix`

## 오류 예시 및 해결법
- `ERROR! couldn't resolve module/action 'mount'` 발생 시 위 collection을 설치하세요.

## 실행
```bash
ansible-playbook newstorage.yml
``` 