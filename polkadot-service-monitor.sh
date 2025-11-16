#!/bin/bash

# Path to polkadot binary
POLKADOT_BIN="/home/$USER/polkadot-sdk/target/release/polkadot"

echo "=== Checking polkadot binary ==="
if [ -f "$POLKADOT_BIN" ]; then
    echo "File exists: $POLKADOT_BIN"
    echo "SELinux context before restore:"
    ls -Z "$POLKADOT_BIN"
    echo "Restoring SELinux context..."
    sudo restorecon -v "$POLKADOT_BIN"
    echo "SELinux context after restore:"
    ls -Z "$POLKADOT_BIN"
else
    echo "File not found: $POLKADOT_BIN"
    exit 1
fi

echo "=== Stopping ksmcc3.service ==="
sudo systemctl stop ksmcc3.service
echo "Service stopped."

echo "=== Pausing for 5 seconds ==="
sleep 5

echo "=== Removing old log file ==="
sudo rm -f /var/log/ksmcc3/ksmcc3_error.log
echo "Old log file removed."

echo "=== Pausing for 2 seconds ==="
sleep 2

echo "=== Creating new log file ==="
sudo touch /var/log/ksmcc3/ksmcc3_error.log
echo "New log file created."

echo "=== Starting ksmcc3.service ==="
sudo systemctl start ksmcc3.service

# Проверка статуса сервиса
echo "=== Checking service status ==="
SERVICE_STATUS=$(systemctl is-active ksmcc3.service)
if [ "$SERVICE_STATUS" = "active" ]; then
    echo "Service ksmcc3 is running."
else
    echo "Service ksmcc3 failed to start!"
    sudo journalctl -u ksmcc3.service --no-pager | tail -n 20
fi

echo "=== Displaying last 100 lines of log and following new entries for 30 seconds ==="
{
    tail -n 100 -f /var/log/ksmcc3/ksmcc3_error.log &
    TAIL_PID=$!
    sleep 30
    echo "Stopping tail command..."
    kill "$TAIL_PID" 2>/dev/null || true
    echo "Tail stopped."
}

echo "=== Done ==="
