#!/bin/bash

HOSTS=("db" "de" "dc")
FILE="$1"
CMD="$2"
TS=$(date "+%Y%m%d_%H%M%S")
LOG_DIR="$HOME/deploy_logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/deploy_log_$TS.log"

if [[ -z "$FILE" ]]; then
    echo "❌ 파일명을 입력해야 합니다."
    exit 1
fi

for HOST in "${HOSTS[@]}"; do
    echo "📡 [$HOST] 파일 전송 중..." | tee -a "$LOG_FILE"
    scp "$FILE" "duri@$HOST:~/" >> "$LOG_FILE" 2>&1
    if [[ -n "$CMD" ]]; then
        echo "⚙️ [$HOST] 명령 실행: $CMD" | tee -a "$LOG_FILE"
        ssh "duri@$HOST" "$CMD" >> "$LOG_FILE" 2>&1
    fi
done

echo "✅ 배포 완료. 로그: $LOG_FILE"
