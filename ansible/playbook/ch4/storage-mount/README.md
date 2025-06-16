# Create and Mount New Storage

이 실습의 목적은 Ansible을 사용해 새로운 디스크에 파티션을 만들고, 파일시스템(xfs)을 생성한 뒤, 디렉토리를 만들고 마운트하는 과정을 자동화하는 것입니다.

## 실습 배경 및 주요 개념
- 클라우드/가상화 환경에서 추가 디스크를 자동으로 파티셔닝, 포맷, 마운트하는 작업은 서버 운영 자동화의 핵심입니다.
- Ansible의 parted, filesystem, file, mount 모듈을 활용하면 반복적이고 오류가 발생하기 쉬운 작업을 코드로 안전하게 관리할 수 있습니다.
- 일부 환경에서는 mount/community.general/ansible.posix collection이 필요하니, 오류 발생 시 collection 설치를 먼저 확인하세요.

## 실전 활용
- 신규 서버에 추가 EBS 볼륨, SAN, NAS 등 다양한 스토리지 자동 마운트
- 대규모 서버 운영 시 표준화된 스토리지 구성 자동화
- 반복적인 수동 작업 최소화 및 실수 방지

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
    # 1. 새 파티션 생성 (gpt, /dev/sdb1)
    - name: create new partition
      parted:
        name: files                # 파티션 이름(라벨)
        label: gpt                 # 파티션 테이블 형식 (gpt 권장)
        device: /dev/sdb           # 파티션을 생성할 디스크
        number: 1                  # 파티션 번호 (1번 파티션)
        state: present             # 파티션이 존재하도록 보장
        part_start: 1MiB           # 파티션 시작 위치
        part_end: 1GiB             # 파티션 끝 위치
    # 2. xfs 파일시스템 생성
    - name: Create xfs filesystem
      filesystem:
        dev: /dev/sdb1             # 파일시스템을 생성할 파티션
        fstype: xfs                 # 파일시스템 타입 (xfs)
    # 3. 마운트할 디렉토리 생성
    - name: Create mount directory
      file:
        path: /data                 # 생성할 디렉토리 경로
        state: directory            # 디렉토리 상태 보장
    # 4. 파일시스템 마운트
    - name: mount the filesystem
      mount:
        src: /dev/sdb1              # 마운트할 디바이스
        fstype: xfs                 # 파일시스템 타입
        state: mounted              # 마운트 상태 보장
```

## 주요 모듈
- **parted**: 디스크 파티션 생성/관리
- **filesystem**: 파일시스템 생성/포맷
- **file**: 디렉토리/파일 생성 및 속성 관리
- **mount**: 파일시스템 마운트/해제/영구화

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

## 참고
- 실습 전, VM/EC2에 추가 디스크(/dev/sdb)가 연결되어 있어야 합니다.
- 마운트가 영구적으로 적용되려면 state: mounted 옵션을 사용하세요. 