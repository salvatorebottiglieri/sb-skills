#!/usr/bin/env bash
# Monitor CI for a GitHub PR until all checks complete or timeout.
# Usage: ./monitor-ci.sh <pr-number> [timeout-seconds]
# Exits 0 if all checks pass, 1 if any fail or timeout.

set -euo pipefail

PR_NUMBER="${1:?Usage: $0 <pr-number> [timeout-seconds]}"
TIMEOUT="${2:-300}"  # default 5 minutes
INTERVAL=10
MAX_ATTEMPTS=$((TIMEOUT / INTERVAL))

cd "$(git rev-parse --show-toplevel)"

echo "[monitor-ci] Watching PR #${PR_NUMBER} (timeout: ${TIMEOUT}s)..."

for i in $(seq 1 "$MAX_ATTEMPTS"); do
  output=$(gh pr checks "$PR_NUMBER" 2>&1) || true
  exit_code=$?

  if [ "$exit_code" -eq 0 ] && [ -n "$output" ]; then
    # Check if any check failed
    failed=$(echo "$output" | grep -v '^$' | grep -v 'pass' | grep -v 'skip' | grep -v 'neutral' || true)
    if [ -z "$failed" ]; then
      echo "[monitor-ci] $(date +%H:%M:%S) All checks passed:"
      echo "$output"
      exit 0
    fi
    echo "[monitor-ci] $(date +%H:%M:%S) Checks in progress or mixed status:"
    echo "$output" | head -2
  else
    echo "[monitor-ci] $(date +%H:%M:%S) Checks not yet started... ($i/$MAX_ATTEMPTS)"
  fi

  sleep "$INTERVAL"
done

echo "[monitor-ci] TIMEOUT after ${TIMEOUT}s — checks did not complete."
echo "$output"
exit 1
