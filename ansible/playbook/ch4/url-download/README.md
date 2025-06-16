# Download Package from a URL

이 실습의 목적은 get_url 모듈을 사용해 외부 URL에서 패키지(예: tomcat)를 다운로드하고, 디렉토리 및 권한을 설정하는 방법을 익히는 것입니다.

## 실습 목적
- 외부 URL에서 파일 다운로드 및 배치 자동화
- 디렉토리 생성 및 권한 설정

## 예시 플레이북 (tomcat.yml)
```yaml
- name: Download Tomcat from tomcat.apache.org
  hosts: localhost
  tasks:
    - name: Create a Directory /opt/tomcat
      file:
        path: /opt/tomcat
        state: directory
        mode: 0755
        group: root
        owner: root
    - name: Download Tomcat using get_url
      get_url:
        url: https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.78/bin/apache-tomcat-8.5.78.tar.gz
        dest: /opt/tomcat/
        mode: 0755
        group: iafzal
        owner: iafzal
```

## 실행
```bash
ansible-playbook tomcat.yml 