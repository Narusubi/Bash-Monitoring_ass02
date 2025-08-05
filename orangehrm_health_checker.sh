#!/bin/bash

# URL to check
APP_URL="https://opensource-demo.orangehrmlive.com/web/index.php/auth/login"

# Log file
LOG_FILE="orangehrm_health.log"

# Timestamp
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# Perform the HTTP request (silent, get only status code)
HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}" "$APP_URL")

# Function to log result
log_status() {
    echo "[$timestamp] $1 (HTTP $HTTP_STATUS) - $APP_URL" | tee -a "$LOG_FILE"
}

# Evaluate status code
if [[ "$HTTP_STATUS" -ge 200 && "$HTTP_STATUS" -lt 400 ]]; then
    log_status "Application is UP"
else
    log_status "Application is DOWN"
fi
