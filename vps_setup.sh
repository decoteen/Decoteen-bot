#!/bin/bash

# اسکریپت راه‌اندازی ربات روی VPS
echo "🚀 شروع نصب ربات دکوتین روی VPS..."

# به‌روزرسانی سیستم
echo "📦 به‌روزرسانی سیستم..."
sudo apt update && sudo apt upgrade -y

# نصب Python 3.11
echo "🐍 نصب Python 3.11..."
sudo apt install python3.11 python3.11-pip python3.11-venv git screen -y

# ایجاد دایرکتوری پروژه
echo "📁 ایجاد دایرکتوری پروژه..."
mkdir -p ~/decoteen-bot
cd ~/decoteen-bot

# ایجاد محیط مجازی
echo "🔧 ایجاد محیط مجازی..."
python3.11 -m venv venv
source venv/bin/activate

# نصب وابستگی‌ها
echo "📚 نصب پکیج‌های Python..."
pip install --upgrade pip
pip install python-telegram-bot==20.7
pip install requests

# ایجاد فایل .env نمونه
echo "⚙️ ایجاد فایل تنظیمات..."
cat > .env << 'EOF'
# تنظیمات ربات دکوتین
BOT_TOKEN=your_bot_token_here
ZARINPAL_MERCHANT_ID=your_merchant_id
BOT_DOMAIN=your_domain.com
ORDER_GROUP_CHAT_ID=-4804296164
ZARINPAL_SANDBOX=false
HESABFA_API_KEY=your_hesabfa_key
HESABFA_BUSINESS_ID=your_business_id
EOF

# ایجاد فایل سرویس systemd
echo "🔄 ایجاد سرویس systemd..."
USERNAME=$(whoami)
cat > decoteen-bot.service << EOF
[Unit]
Description=DecoTeen Telegram Bot
After=network.target

[Service]
Type=simple
User=$USERNAME
WorkingDirectory=/home/$USERNAME/decoteen-bot
Environment=PATH=/home/$USERNAME/decoteen-bot/venv/bin
ExecStart=/home/$USERNAME/decoteen-bot/venv/bin/python main.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

echo "✅ نصب پایه کامل شد!"
echo ""
echo "📋 مراحل باقی‌مانده:"
echo "1. فایل‌های ربات را کپی کنید"
echo "2. فایل .env را ویرایش کنید"
echo "3. سرویس را فعال کنید:"
echo "   sudo cp decoteen-bot.service /etc/systemd/system/"
echo "   sudo systemctl daemon-reload"
echo "   sudo systemctl enable decoteen-bot"
echo "   sudo systemctl start decoteen-bot"