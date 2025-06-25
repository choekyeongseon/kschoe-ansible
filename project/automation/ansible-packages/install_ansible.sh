#!/bin/bash

set -e

echo "[1/4] 압축 파일 풀기"
tar -xzvf ansible-install-packages.tar.gz

echo "[2/4] 캐시 정리 및 로컬 패키지 설치"
dnf clean all
dnf --disablerepo="*" install -y *.rpm

echo "[3/4] 버전 확인"
ansible --version

echo "[4/4] 기본 설정 디렉토리 생성"
mkdir -p /etc/ansible
touch /etc/ansible/hosts

echo "[완료] Ansible 설치 및 기본 설정 완료"