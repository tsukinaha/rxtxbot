#!/bin/bash
time=$(date +"%T")
date=$(date --date="today" "+%Y-%m-%d")
# Get local hostname
hostname=$(hostname)
# Get local IP address
local_ip=$(hostname -I | awk '{print $1}')
# Run vnstat command and save output to file
vnstat -d -i enp3s0 > /tmp/vnstat.txt
# Parse rx and tx values from vnstat output
chat_id=$1
token=$2
rx=$(vnstat -d -i enp3s0 | grep -A 1 "$(date --date="today" "+%Y-%m-%d")" /tmp/vnstat.txt | head -n 1 |awk '{print $2, $3}' | tr '\n' ' ')
tx=$(vnstat -d -i enp3s0 | grep -A 1 "$(date --date="today" "+%Y-%m-%d")" /tmp/vnstat.txt | head -n 1 | awk '{print $5,$6}'| tr '\n' ' ')
url="https://api.telegram.org/bot${token}/sendMessage"
message="[每小时流量统计] ${date} ${time} ${hostname} (${local_ip}) 今日 出站 ${tx} 入站 ${rx}"
# Send message to Telegram
curl -s -X POST "${url}" -d "chat_id=${chat_id}" -d "text=${message}"
