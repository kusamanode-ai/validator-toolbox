#!/bin/bash

# ======================================
# Node Hardware & Network Automated Report
# ======================================

echo "=============================="
echo "Node Hardware & Network Report"
echo "=============================="

# 1. Node name
echo -e "\n1. Node name: $(hostname)"

# A) CPU
echo -e "\nA) CPU:"
lscpu | grep -E 'Model name|CPU MHz|Core|Socket' | sed 's/^/   /'

# HT/SMT status
THREADS_PER_CORE=$(lscpu | grep "Thread(s) per core" | awk '{print $4}')
echo -e "\n   HT/SMT status:"
if [ "$THREADS_PER_CORE" -gt 1 ]; then
    echo "      Hyper-Threading / SMT enabled ($THREADS_PER_CORE threads per core)"
else
    echo "      Hyper-Threading / SMT disabled"
fi

# B) Memory/RAM
echo -e "\nB) Memory/RAM:"

# NUMA settings
echo -e "\n   NUMA settings:"
if command -v numactl &> /dev/null; then
    numactl --hardware | sed 's/^/      /'
else
    echo "      numactl not installed. Install with: sudo dnf install numactl"
fi

# dmidecode memory info
echo -e "\n   Memory modules info (dmidecode):"
sudo dmidecode -t memory | grep -E 'Size|Type|Speed|Locator|Bank Locator' | sed 's/^/      /'

# C) Storage
echo -e "\nC) Storage:"
lsblk -o NAME,MODEL,SIZE,ROTA,FSTYPE,MOUNTPOINT | sed 's/^/   /'
echo -e "\n   Running 4K random read test (fio)..."
fio --name=read4k --rw=randread --bs=4k --size=1G --numjobs=1 --runtime=60 --group_reporting | tee fio_results.txt | sed 's/^/      /'

# D) Network speed
echo -e "\nD) Network speed (via Speedtest.net):"

# Проверяем наличие бинарника
if [ -x /usr/local/bin/speedtest-cli ]; then
    /usr/local/bin/speedtest-cli --simple | sed 's/^/   /'
else
    echo "   speedtest-cli not found in /usr/local/bin. Installing..."
    sudo dnf install -y python3-pip
    sudo pip3 install speedtest-cli
    /usr/local/bin/speedtest-cli --simple | sed 's/^/   /'
fi

# E) Connection type
ACTIVE_IF=$(ip -4 route get 1 | awk '{for(i=1;i<=NF;i++){if($i=="dev"){print $(i+1); exit}}}')
echo -e "\nE) Connection type:"
echo "   Active interface: $ACTIVE_IF"
echo "   IPv4 addresses:"
ip -4 addr show "$ACTIVE_IF" | grep inet | sed 's/^/      /'
echo "   IPv6 addresses:"
ip -6 addr show "$ACTIVE_IF" | grep inet6 | sed 's/^/      /'

echo -e "\n=============================="
echo "End of Report"
echo "=============================="
