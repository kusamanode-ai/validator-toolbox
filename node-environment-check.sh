#!/bin/bash

echo "=== Distribution ==="
grep -E 'NAME=|VERSION=' /etc/os-release
echo

echo "=== Kernel ==="
uname -r
echo

echo "=== Filesystem ==="
lsblk -f
echo

echo "=== Mounts ==="
mount | column -t
echo

echo "=== fstab ==="
grep -v '^#' /etc/fstab | sed '/^$/d'
echo
