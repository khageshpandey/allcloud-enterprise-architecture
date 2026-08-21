#!/usr/bin/env bash
set -euo pipefail
echo "=== Linux Service Health Check ==="
systemctl is-active --quiet nginx && echo "Nginx: RUNNING" || echo "Nginx: FAILED"
echo "=== Recent Critical Errors ==="
journalctl -p 3 -n 20 --no-pager
echo "=== High Disk Usage Systems ==="
df -h | awk '$5 > 85 {print $0}'