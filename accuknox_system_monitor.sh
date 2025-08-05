#!/bin/bash

# Thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=90
LOG_FILE="system_health.log"

# Date/time for log
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
CPU_USAGE_INT=${CPU_USAGE%.*}

# Memory usage
MEM_USAGE=$(free | awk '/Mem/ {printf("%.0f", $3/$2 * 100)}')

# Disk usage (root partition)
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

# Running processes
PROCESS_COUNT=$(ps aux | wc -l)

# Function to log alerts
log_alert() {
    echo "[$timestamp] ALERT: $1" | tee -a "$LOG_FILE"
}

# CPU check
if [[ "$CPU_USAGE_INT" =~ ^[0-9]+$ ]] && [ "$CPU_USAGE_INT" -gt "$CPU_THRESHOLD" ]; then
    log_alert "High CPU usage: ${CPU_USAGE_INT}%"
fi

# Memory check
if [[ "$MEM_USAGE" =~ ^[0-9]+$ ]] && [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ]; then
    log_alert "High Memory usage: ${MEM_USAGE}%"
fi

# Disk check
if [[ "$DISK_USAGE" =~ ^[0-9]+$ ]] && [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    log_alert "Low disk space: ${DISK_USAGE}% used"
fi

# Print current status
echo "[$timestamp] System Health Summary:"
echo "CPU Usage: ${CPU_USAGE_INT:-Unavailable}%"
echo "Memory Usage: ${MEM_USAGE:-Unavailable}%"
echo "Disk Usage (/): ${DISK_USAGE:-Unavailable}%"
echo "Running Processes: $PROCESS_COUNT"
