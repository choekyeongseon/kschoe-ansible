#!/bin/bash

# 로그 파일 경로 설정
LOG_FILE="/tmp/system_info_$(date +%Y%m%d_%H%M%S).log"

# 시작 시간 기록
echo "=== System Information Collection Started at $(date) ===" > $LOG_FILE
echo "" >> $LOG_FILE

# 시스템 기본 정보 수집
echo "=== System Overview ===" >> $LOG_FILE
echo "Hostname: $(hostname)" >> $LOG_FILE
echo "Kernel Version: $(uname -r)" >> $LOG_FILE
echo "OS Information: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)" >> $LOG_FILE
echo "" >> $LOG_FILE

# CPU 정보
echo "=== CPU Information ===" >> $LOG_FILE
echo "CPU Model: $(cat /proc/cpuinfo | grep "model name" | head -n1 | cut -d':' -f2)" >> $LOG_FILE
echo "CPU Cores: $(nproc)" >> $LOG_FILE
echo "" >> $LOG_FILE

# 메모리 정보
echo "=== Memory Information ===" >> $LOG_FILE
free -h >> $LOG_FILE
echo "" >> $LOG_FILE

# 디스크 사용량
echo "=== Disk Usage ===" >> $LOG_FILE
df -h >> $LOG_FILE
echo "" >> $LOG_FILE

# 현재 실행 중인 프로세스 수
echo "=== Process Information ===" >> $LOG_FILE
echo "Total Running Processes: $(ps aux | wc -l)" >> $LOG_FILE
echo "" >> $LOG_FILE

# 네트워크 인터페이스 정보
echo "=== Network Interfaces ===" >> $LOG_FILE
ip addr show >> $LOG_FILE
echo "" >> $LOG_FILE

# 마지막 5개의 로그인 기록
echo "=== Last 5 Logins ===" >> $LOG_FILE
last -n 5 >> $LOG_FILE
echo "" >> $LOG_FILE

# 실행 완료 메시지
echo "=== Information Collection Completed at $(date) ===" >> $LOG_FILE

# 결과 출력
echo "System information has been collected and saved to $LOG_FILE"
echo "You can view the information using: cat $LOG_FILE"
