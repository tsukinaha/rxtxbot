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
rx=$(vnstat -d -i enp3s0 | grep -A 1 "$(date --date="yesterday" "+%Y-%m-%d")" /tmp/vnstat.txt | head -n 1 |awk '{print $2, $3}' | tr '\n' ' ')
tx=$(vnstat -d -i enp3s0 | grep -A 1 "$(date --date="yesterday" "+%Y-%m-%d")" /tmp/vnstat.txt | head -n 1 |awk '{print $5, $6}'| tr '\n' ' ')
# Set Telegram bot token, chat ID, and message
token="114514"
chat_id="114514"
url="https://api.telegram.org/bot${token}/sendMessage"
message="[每日流量统计] ${date} ${time} ${hostname} (${local_ip}) 今日 出站 ${tx} 入站 ${rx}"
# Send message to Telegram
curl -s -X POST "${url}" -d "chat_id=${chat_id}" -d "text=${message}"
