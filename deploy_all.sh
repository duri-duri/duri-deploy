#!/bin/bash

# 🧠 DuRi 시스템 자동 배포 스크립트

HOSTS=("duri-core" "duri-evolution" "duri-brain" "duri-control")
FILE="$1"
CMD="$2"

TS=$(date "+%Y%m%d_%H%M%S")
LOG_DIR="$HOME/deploy_logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/deploy_log_$TS.log"

if [[ -z "$FILE" ]]; then
  echo "❌ 파일명을 입력해야 합니다."
  echo "사용법: ./deploy_all.sh 파일명 [명령어]"
  exit 1
fi

echo "🚀 DuRi 시스템 배포 시작: $FILE" | tee -a "$LOG_FILE"

for HOST in "${HOSTS[@]}"; do
  echo "📡 [$HOST] 파일 전송 중..." | tee -a "$LOG_FILE"
  scp "$FILE" "duri@$HOST:~/" >> "$LOG_FILE" 2>&1

  if [[ -n "$CMD" ]]; then
    echo "⚙️ [$HOST] 명령 실행: $CMD" | tee -a "$LOG_FILE"
    ssh "duri@$HOST" "$CMD" >> "$LOG_FILE" 2>&1
  fi
done

echo "✅ 배포 완료: 로그 저장됨 → $LOG_FILE"
