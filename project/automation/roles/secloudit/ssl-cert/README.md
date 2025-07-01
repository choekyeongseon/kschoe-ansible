# SSL 인증서 생성 Role (secloudit/ssl-cert)

## 개요
Harbor 및 기타 서비스에서 사용할 SSL 인증서를 생성하는 역할입니다.

## 주요 기능
- 자체 서명 SSL 인증서 생성
- OpenSSL을 사용한 RSA 키 생성
- 인증서 및 키 파일 권한 설정
- 도메인별 인증서 생성 지원
- 5개 서비스에 대한 포괄적인 인증서 생성

## 사용법

### 기본 사용
```yaml
- hosts: harbor-servers
  roles:
    - secloudit/ssl-cert
```

### 변수 설정과 함께 사용
```yaml
- hosts: harbor-servers
  vars:
    ssl_cert:
      domain: "harbor.example.com"
      working_dir: "/opt/ssl-certs"
      validity_days: 730
  roles:
    - secloudit/ssl-cert
```

### Ansible Role과의 통합
```yaml
- name: Execute SSL certificate creation script
  shell: /opt/scripts/create-cert.sh "{{ ssl_cert.domain }}"
  args:
    chdir: /opt/scripts
```

## 변수

| 변수명 | 기본값 | 설명 |
|--------|--------|------|
| ssl_cert.domain | "harbor.local" | 인증서 도메인명 (필수) |
| ssl_cert.working_dir | "/opt/ssl-certs" | 스크립트 실행 디렉토리 |
| ssl_cert.script_path | "/opt/scripts/create-cert.sh" | 스크립트 경로 |
| ssl_cert.services | harbor, bootstrap-registry, service-registry, gitlab, chartmuseum | 생성될 서비스 목록 |
| ssl_cert.cert_dir | "/opt/certs" | 기존 인증서 저장 디렉토리 (하위 호환성) |
| ssl_cert.key_file | "/opt/certs/harbor.key" | 기존 개인키 파일 경로 (하위 호환성) |
| ssl_cert.cert_file | "/opt/certs/harbor.crt" | 기존 인증서 파일 경로 (하위 호환성) |
| ssl_cert.validity_days | 365 | 인증서 유효기간 (일) |
| ssl_cert.key_size | 2048 | RSA 키 크기 |

## 생성되는 파일
- `/opt/ssl-certs/harbor/`: Harbor 인증서 파일들
- `/opt/ssl-certs/bootstrap-registry/`: Bootstrap Registry 인증서 파일들
- `/opt/ssl-certs/service-registry/`: Service Registry 인증서 파일들
- `/opt/ssl-certs/gitlab/`: GitLab 인증서 파일들
- `/opt/ssl-certs/chartmuseum/`: ChartMuseum 인증서 파일들

각 디렉토리에는 다음 파일들이 포함됩니다:
- `ca.key`: CA 개인키 (600 권한)
- `ca.crt`: CA 인증서 (644 권한)
- `service.key`: 서비스 개인키 (600 권한)
- `service.crt`: 서비스 인증서 (644 권한)
- `service.csr`: 인증서 서명 요청
- `v3.ext`: x509 v3 확장 설정

## 의존성
- OpenSSL 패키지가 설치되어 있어야 합니다.

## 실행 예시

### 1. 기본 실행
```bash
# 스크립트 직접 실행
./create-cert.sh seoul-city.com
```

### 2. Ansible을 통한 실행
```bash
# SSL 인증서 생성 role 실행
ansible-playbook -i inventory/hosts playbooks/ssl-cert-test.yml
```

### 3. 생성된 파일 확인
```bash
# Harbor 인증서 확인
ls -la /opt/ssl-certs/harbor/
openssl x509 -in /opt/ssl-certs/harbor/harbor.seoul-city.com.crt -text -noout

# GitLab 인증서 확인
ls -la /opt/ssl-certs/gitlab/
openssl x509 -in /opt/ssl-certs/gitlab/gitlab.seoul-city.com.crt -text -noout
```

### 4. 전체 서비스 인증서 확인
```bash
# 모든 서비스 디렉토리 확인
ls -la /opt/ssl-certs/

# 각 서비스별 인증서 유효성 확인
for service in harbor bootstrap-registry service-registry gitlab chartmuseum; do
  echo "Checking $service certificate..."
  openssl x509 -in /opt/ssl-certs/$service/$service.seoul-city.com.crt -checkend 0
done
```

## 권장 개선사항

1. **유효기간 조정**: 100년 → 5년으로 단축
2. **sudo 제거**: `tee` 명령에서 sudo 제거
3. **권한 설정 추가**: 생성된 파일들의 권한 설정
4. **변수화**: 조직 정보를 변수로 설정
5. **에러 처리**: 더 강력한 에러 처리 추가
6. **로깅 개선**: 상세한 로그 출력 추가
7. **백업 기능**: 기존 인증서 백업 기능 추가
8. **자동 갱신**: 인증서 만료 자동 감지 및 갱신 기능 




## create-cert.sh 스크립트 분석

### 스크립트 개요
- **목적**: 5개의 서비스에 대한 SSL 인증서를 한 번에 생성
- **특징**: 각 서비스별로 독립적인 CA와 인증서 생성
- **기반**: 프로젝트 도메인을 기반으로 한 서브도메인 인증서 생성

### 사용법
```bash
./create-cert.sh <project_domain>
# 예: ./create-cert.sh seoul-city.com
```

### 생성되는 서비스별 인증서

| 서비스 | 도메인 패턴 | 디렉토리 | 설명 |
|--------|-------------|----------|------|
| **Harbor** | `harbor.<domain>` | `./harbor/` | 컨테이너 이미지 레지스트리 |
| **Bootstrap Registry** | `secloudit-bootstrap-registry.<domain>` | `./bootstrap-registry/` | 부트스트랩 레지스트리 |
| **Service Registry** | `secloudit-service-registry.<domain>` | `./service-registry/` | 서비스 레지스트리 |
| **GitLab** | `gitlab.<domain>` | `./gitlab/` | Git 저장소 관리 |
| **ChartMuseum** | `chartmuseum.<domain>` | `./chartmuseum/` | Helm 차트 저장소 |

### 각 서비스별 생성 파일

```
service_directory/
├── ca.key          # CA 개인키 (4096비트)
├── ca.crt          # CA 인증서 (10년 유효)
├── service.key     # 서비스 개인키 (4096비트)
├── service.csr     # 인증서 서명 요청
├── service.crt     # 서비스 인증서 (100년 유효)
└── v3.ext          # x509 v3 확장 설정
```

### 인증서 상세 사양

#### CA 인증서
- **알고리즘**: RSA 4096비트
- **유효기간**: 10년 (3650일)
- **주체**: `/C=KR/ST=Seoul/CN=RootCA`
- **용도**: 루트 CA

#### 서비스 인증서
- **알고리즘**: RSA 4096비트
- **유효기간**: 100년 (365000일)
- **주체**: `/C=KR/ST=Seoul/L=Jung-gu/O=Innogrid/OU=IT/CN=<service_domain>`
- **용도**: 서버 인증

#### x509 v3 확장 설정
```ini
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=<service_domain>
DNS.2=<base_domain>
```
