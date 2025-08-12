#!/bin/bash

# اسکریپت بکاپ روزانه ربات دکوتین
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/home/$(whoami)/backups"
BOT_DIR="/home/$(whoami)/decoteen-bot"

# ایجاد دایرکتوری بکاپ
mkdir -p $BACKUP_DIR

# بکاپ داده‌های مهم
echo "🔄 شروع بکاپ $DATE..."

# بکاپ کل پروژه
tar -czf "$BACKUP_DIR/decoteen_full_$DATE.tar.gz" -C $BOT_DIR .

# بکاپ فقط داده‌ها
tar -czf "$BACKUP_DIR/decoteen_data_$DATE.tar.gz" -C $BOT_DIR \
    data/ order_data/ cart_data/ payment_data/ \
    .env 2>/dev/null || true

# حذف بکاپ‌های قدیمی (بیش از 7 روز)
find $BACKUP_DIR -name "decoteen_*.tar.gz" -mtime +7 -delete

echo "✅ بکاپ کامل شد: $BACKUP_DIR"
echo "📁 فایل‌های بکاپ:"
ls -la $BACKUP_DIR/decoteen_*$DATE*