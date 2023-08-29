#!/bin/bash

# Telegram Bot API密钥和聊天ID（请替换为你自己的）
telegram_api_key=$1
chat_id=$2

# 生成随机端口号
new_port=$[$RANDOM%16384+49152]

# 修改SSH配置文件
sed -i "s/^#Port.*/Port $new_port/" /etc/ssh/sshd_config

# 重启SSH服务
service sshd restart

# 获取本机IP地址
ip_address=$(curl -s ip.sb -4)

# 发送通知到Telegram
message="SSH端口已修改为$new_port，当前的IP地址是：$ip_address"
echo $message
curl -s -X POST "https://api.telegram.org/bot${telegram_api_key}/sendMessage" -d "chat_id=${chat_id}&text=${message}"