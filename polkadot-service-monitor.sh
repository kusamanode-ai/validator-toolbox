#!/bin/bash

USER_HOME="/home/$USER"
POLKADOT_BIN="$USER_HOME/polkadot-sdk/target/release/polkadot"
LOG_FILE="/var/log/ksmcc3/ksmcc3_error.log"
SERVICE_NAME="ksmcc3.service"

echo "=== Checking polkadot binary ==="
if [ -f "$POLKADOT_BIN" ]; then
    echo "File exists: $POLKADOT_BIN"
else
    echo "File not found: $POLKADOT_BIN"
    exit 1
fi

echo -e "\n=== Stopping service ==="
sudo systemctl stop $SERVICE_NAME
echo "Service $SERVICE_NAME stopped."

echo -e "\n=== Pause 5 seconds ==="
sleep 5

echo -e "\n=== Removing log file ==="
if [ -f "$LOG_FILE" ]; then
    sudo rm "$LOG_FILE"
    echo "Removed $LOG_FILE"
else
    echo "Log file not found, skipping removal"
fi
sleep 2

echo -e "\n=== Creating log file ==="
sudo touch "$LOG_FILE"
echo "Created $LOG_FILE"

echo -e "\n=== Applying SELinux context ==="
ls -Z "$POLKADOT_BIN"
sudo restorecon -v "$POLKADOT_BIN"

echo -e "\n=== Starting service ==="
sudo systemctl start $SERVICE_NAME
echo "Service $SERVICE_NAME started."

echo -e "\n=== Display last 100 log lines ==="
tail -n 100 -f "$LOG_FILE" &
TAIL_PID=$!
sleep 30
sudo kill $TAIL_PID 2>/dev/null || true

echo -e "\n=== Running Polkadot machine benchmark ==="
$POLKADOT_BIN benchmark machine
