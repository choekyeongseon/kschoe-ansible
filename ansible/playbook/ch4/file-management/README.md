# Ansible 파일 관리

이 섹션에서는 Ansible을 사용한 파일 관리 방법에 대해 설명합니다.

## 1. 파일 복사 (Copy Files)

### 1.1 기본 구문
```yaml
---
- name: Copy file from local to remote clients  # 플레이북 설명
  hosts: all                                    # 모든 호스트에서 실행

  tasks:                                        # 작업 목록
  - name: Copying file                         # 작업 설명
    become: true                               # 현재 사용자로 실행
    copy:                                      # copy 모듈 사용
      src: /home/iafzal/some.cfg              # 소스 파일 위치
      dest: /tmp                              # 대상 위치
      owner: iafzal                           # 파일 소유자
      group: iafzal                           # 파일 그룹
      mode: '0644'                            # 파일 권한
```

### 1.2 주요 매개변수
- `src`: 복사할 원본 파일의 경로
- `dest`: 대상 시스템의 저장 경로
- `owner`: 파일 소유자
- `group`: 파일 그룹
- `mode`: 파일 권한 (8진수 형식)
- `become`: 권한 상승 여부

## 2. 파일 권한 관리 (File Permissions)

### 2.1 기본 구문
```yaml
---
- name: Change file permissions               # 플레이북 설명
  hosts: all                                 # 모든 호스트에서 실행

  tasks:
  - name: Files Permissions                  # 작업 설명
    file:                                    # file 모듈 사용
      path: /home/iafzal/linux2             # 대상 파일 경로
      mode: a+x                             # 실행 권한 추가
```

### 2.2 권한 설정 방법
1. 숫자 표기법
   - 4: 읽기 (r)
   - 2: 쓰기 (w)
   - 1: 실행 (x)
   예: `mode: '0644'` (rw-r--r--)

2. 기호 표기법
   - `u`: 소유자
   - `g`: 그룹
   - `o`: 기타
   - `a`: 모두
   예: `mode: a+x` (모두에게 실행 권한 추가)

## 3. 실행 방법

### 3.1 파일 복사 실행
```bash
# ansible-playbook copy.yml
```

### 3.2 권한 변경 실행
```bash
# ansible-playbook filepermission.yml
```

## 4. 주의사항
- 파일 권한 변경 시 보안 영향 고려
- 상대 경로 사용 시 주의
- 대상 시스템의 디스크 공간 확인
- 권한 상승(become) 필요 여부 확인

## 5. 참고 자료
- Ansible 모듈 및 옵션 문서:
  https://docs.ansible.com/ansible/2.5/modules/
- copy 모듈: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/copy_module.html
- file 모듈: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/file_module.html 