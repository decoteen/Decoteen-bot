# راهنمای انتقال ربات به VPS

## مرحله 1: نصب وابستگی‌ها روی VPS

```bash
# به‌روزرسانی سیستم
sudo apt update && sudo apt upgrade -y

# نصب Python 3.11
sudo apt install python3.11 python3.11-pip python3.11-venv -y

# نصب git
sudo apt install git -y

# نصب screen یا tmux برای اجرای مداوم
sudo apt install screen -y
```

## مرحله 2: کپی کردن پروژه

```bash
# ایجاد دایرکتوری پروژه
mkdir -p ~/decoteen-bot
cd ~/decoteen-bot

# کپی تمام فایل‌های پروژه از Replit به VPS
# می‌توانید از git، scp یا ftp استفاده کنید
```

## مرحله 3: نصب پکیج‌ها

```bash
# ایجاد محیط مجازی
python3.11 -m venv venv
source venv/bin/activate

# نصب وابستگی‌ها
pip install python-telegram-bot==20.7
pip install requests
```

## مرحله 4: تنظیم متغیرهای محیطی

```bash
# ایجاد فایل .env
nano .env
```

محتوای فایل .env:
```env
BOT_TOKEN=your_bot_token_here
ZARINPAL_MERCHANT_ID=your_merchant_id
BOT_DOMAIN=your_domain.com
ORDER_GROUP_CHAT_ID=-4804296164
ZARINPAL_SANDBOX=false
HESABFA_API_KEY=your_hesabfa_key
HESABFA_BUSINESS_ID=your_business_id
```

## مرحله 5: اجرای مداوم ربات

### گزینه 1: استفاده از screen
```bash
# شروع session جدید
screen -S decoteen-bot

# اجرای ربات
cd ~/decoteen-bot
source venv/bin/activate
python main.py

# خروج از screen (Ctrl+A, D)
```

### گزینه 2: استفاده از systemd (پیشنهادی)
```bash
# ایجاد فایل سرویس
sudo nano /etc/systemd/system/decoteen-bot.service
```

محتوای فایل سرویس:
```ini
[Unit]
Description=DecoTeen Telegram Bot
After=network.target

[Service]
Type=simple
User=your_username
WorkingDirectory=/home/your_username/decoteen-bot
Environment=PATH=/home/your_username/decoteen-bot/venv/bin
ExecStart=/home/your_username/decoteen-bot/venv/bin/python main.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
# فعال‌سازی سرویس
sudo systemctl daemon-reload
sudo systemctl enable decoteen-bot
sudo systemctl start decoteen-bot

# بررسی وضعیت
sudo systemctl status decoteen-bot
```

## مرحله 6: مانیتورینگ و لاگ

```bash
# مشاهده لاگ‌ها
sudo journalctl -u decoteen-bot -f

# یا با screen
screen -r decoteen-bot
```

## مرحله 7: تنظیمات امنیتی

```bash
# تنظیم فایروال
sudo ufw allow ssh
sudo ufw allow 80
sudo ufw allow 443
sudo ufw enable

# محافظت از فایل .env
chmod 600 .env
```

## نکات مهم:

1. **دامنه**: اگر webhook می‌خواهید، نیاز به دامنه و SSL دارید
2. **پایگاه داده**: فایل‌های JSON در VPS حفظ می‌شوند
3. **بکاپ**: حتماً از فایل‌های data و order_data بکاپ بگیرید
4. **مانیتورینگ**: systemd بهترین روش برای اجرای مداوم است

## فایل‌های مورد نیاز برای انتقال:
- تمام فایل‌های .py
- پوشه‌های bot/, data/, utils/
- فایل‌های JSON داده‌ها
- requirements.txt
- .env (با مقادیر صحیح)