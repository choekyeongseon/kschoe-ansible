# 01. Harbor Setup

## 목적
- 폐쇄망 환경에서 로컬 이미지 기반 Harbor 레지스트리 운영

## 사전 조건
- 해당 VM은 미리 생성되어 있어야 함
- OS: Rocky Linux 9.x 또는 호환 가능
- docker 및 docker-compose 설치 가능
- Harbor 패키지는 로컬 저장소에 보관 중

## 주요 작업
- docker 및 docker-compose 설치
- Harbor 설치 디렉토리 구성
- harbor.yml 설정 및 인증서 구성
- harbor 컨테이너 실행

## 고려사항
- 인증서 없이 HTTP 사용 시 브라우저 경고 발생 가능
- 관리자 패스워드 설정 필요
- 데이터 디렉토리 백업 정책 필요

## Ansible Role 설계
- 역할명: `harbor`
- 주요 태스크:
  - harbor 패키지 압축 해제
  - harbor.yml 템플릿 배포
  - install.sh 실행
  - 서비스 상태 확인 및 재기동

## 변수 예시
```yaml
harbor:
  hostname: harbor.local
  http_port: 80
  https_port: 443
  admin_password: Harbor12345
  data_path: /data/harbor
  package_path: /opt/installers/harbor-offline-installer.tgz
```

