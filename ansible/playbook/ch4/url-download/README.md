# Download Package from a URL

이 실습의 목적은 get_url 모듈을 사용해 외부 URL에서 패키지(예: tomcat)를 다운로드하고, 디렉토리 및 권한을 설정하는 방법을 익히는 것입니다.

## 실습 배경 및 주요 개념
- 서버 초기 세팅 시 외부에서 소프트웨어 패키지, 설정 파일 등을 자동으로 다운로드해야 할 때가 많습니다.
- get_url 모듈은 wget/curl 없이도 Ansible로 파일을 안전하게 배포할 수 있습니다.
- 파일 배치 전 디렉토리 생성, 권한/소유자 설정도 함께 자동화할 수 있습니다.

## 실전 활용
- Tomcat, JDK, custom script 등 외부 패키지 자동 배포
- 사내/공개 저장소에서 설정 파일, 바이너리 등 자동 다운로드

## 실습 목적
- 외부 URL에서 파일 다운로드 및 배치 자동화
- 디렉토리 생성 및 권한 설정

## 예시 플레이북 (tomcat.yml)
```yaml
- name: Download Tomcat from tomcat.apache.org
  hosts: localhost
  tasks:
    # 1. Tomcat 설치 디렉토리 생성
    - name: Create a Directory /opt/tomcat
      file:
        path: /opt/tomcat      # 생성할 디렉토리 경로
        state: directory       # 디렉토리 상태 보장
        mode: 0755             # 디렉토리 권한
        group: root            # 그룹 소유자
        owner: root            # 사용자 소유자
    # 2. Tomcat 패키지 다운로드 및 권한 설정
    - name: Download Tomcat using get_url
      get_url:
        url: https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.78/bin/apache-tomcat-8.5.78.tar.gz  # 다운로드 URL
        dest: /opt/tomcat/     # 저장 경로
        mode: 0755             # 파일 권한
        group: iafzal          # 그룹 소유자
        owner: iafzal          # 사용자 소유자
```

## 실행
```bash
ansible-playbook tomcat.yml
```

## 참고
- 파일이 이미 존재하면 get_url은 기본적으로 덮어쓰지 않습니다. (force 옵션 참고)
- 내부망에서만 접근 가능한 저장소라면 proxy 설정이 필요할 수 있습니다.