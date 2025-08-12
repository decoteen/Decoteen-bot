# راهنمای کامل انتقال ربات به VPS فنلاند

## اطلاعات سرور شما:
- IP: 65.109.184.162
- Username: root
- Password: MTTtxpwhTkwuHeUmTgvC

## مرحله 1: اتصال به سرور

```bash
# اتصال SSH به سرور
ssh root@65.109.184.162
# وارد کردن پسورد: MTTtxpwhTkwuHeUmTgvC
```

## مرحله 2: آماده‌سازی سرور

```bash
# به‌روزرسانی سیستم
apt update && apt upgrade -y

# نصب Python 3.11 و ابزارهای لازم
apt install python3.11 python3.11-pip python3.11-venv git screen nano htop -y

# نصب unzip برای فایل‌های فشرده
apt install unzip -y
```

## مرحله 3: ایجاد دایرکتوری پروژه

```bash
# ایجاد دایرکتوری برای ربات
mkdir -p /root/decoteen-bot
cd /root/decoteen-bot

# ایجاد محیط مجازی Python
python3.11 -m venv venv
source venv/bin/activate

# نصب پکیج‌های مورد نیاز
pip install --upgrade pip
pip install python-telegram-bot==20.7
pip install requests
```

## مرحله 4: انتقال فایل‌های پروژه

### روش 1: آپلود مستقیم (ساده‌ترین)
```bash
# از کامپیوتر محلی، فایل‌های پروژه را با scp کپی کنید:
scp -r path/to/your/project/* root@65.109.184.162:/root/decoteen-bot/
```

### روش 2: دانلود از Replit
```bash
# در سرور، فایل‌ها را دانلود کنید
# (URL Replit پروژه خودتان را جایگزین کنید)
wget https://your-replit-url.com/project.zip
unzip project.zip
```

## مرحله 5: تنظیم فایل .env

```bash
# ایجاد فایل تنظیمات
nano /root/decoteen-bot/.env
```

محتوای فایل .env:
```env
BOT_TOKEN=7768208621:AAGBQiV_your_actual_token_here
ZARINPAL_MERCHANT_ID=fd4166f9-3643-4b9c-8307-your_merchant_id
BOT_DOMAIN=your-domain.com
ORDER_GROUP_CHAT_ID=-4804296164
ZARINPAL_SANDBOX=false
HESABFA_API_KEY=your_hesabfa_key
HESABFA_BUSINESS_ID=your_business_id
MAX_CART_ITEMS=50
```

## مرحله 6: ایجاد سرویس systemd

```bash
# ایجاد فایل سرویس
nano /etc/systemd/system/decoteen-bot.service
```

محتوای فایل سرویس:
```ini
[Unit]
Description=DecoTeen Telegram Bot
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/decoteen-bot
Environment=PATH=/root/decoteen-bot/venv/bin
ExecStart=/root/decoteen-bot/venv/bin/python main.py
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

## مرحله 7: فعال‌سازی و راه‌اندازی

```bash
# بارگذاری مجدد systemd
systemctl daemon-reload

# فعال‌سازی سرویس
systemctl enable decoteen-bot

# شروع سرویس
systemctl start decoteen-bot

# بررسی وضعیت
systemctl status decoteen-bot
```

## مرحله 8: مانیتورینگ و کنترل

```bash
# مشاهده لاگ‌های زنده
journalctl -u decoteen-bot -f

# توقف سرویس
systemctl stop decoteen-bot

# ری‌استارت سرویس
systemctl restart decoteen-bot

# غیرفعال کردن سرویس
systemctl disable decoteen-bot
```

## مرحله 9: تنظیمات امنیتی

```bash
# نصب و تنظیم فایروال
ufw allow ssh
ufw allow 80
ufw allow 443
ufw --force enable

# محافظت از فایل .env
chmod 600 /root/decoteen-bot/.env
```

## مرحله 10: بکاپ خودکار

```bash
# ایجاد اسکریپت بکاپ
nano /root/backup_bot.sh
```

محتوای اسکریپت:
```bash
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
tar -czf "/root/backups/decoteen_$DATE.tar.gz" -C /root/decoteen-bot .
find /root/backups -name "decoteen_*.tar.gz" -mtime +7 -delete
```

```bash
# اجازه اجرا
chmod +x /root/backup_bot.sh

# تنظیم cron برای بکاپ روزانه
crontab -e
# اضافه کردن خط:
0 2 * * * /root/backup_bot.sh
```

## دستورات مفید:

```bash
# مشاهده منابع سیستم
htop

# مشاهده فضای دیسک
df -h

# مشاهده پردازش‌های Python
ps aux | grep python

# تست اتصال ربات
curl -s "https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getMe"
```

## عیب‌یابی:

اگر ربات کار نکرد:
1. بررسی لاگ‌ها: `journalctl -u decoteen-bot -f`
2. بررسی فایل .env: `cat /root/decoteen-bot/.env`
3. تست دستی: `cd /root/decoteen-bot && source venv/bin/activate && python main.py`

## نکات مهم:
- حتماً BOT_TOKEN صحیح را وارد کنید
- ORDER_GROUP_CHAT_ID باید همان ID گروه پشتیبانی باشد
- برای پرداخت واقعی ZARINPAL_SANDBOX=false کنید
- فایل‌های data/ و order_data/ را حفظ کنید