#!/bin/sh
set -e

echo "=== Creating proxy users ==="

# Ищем все переменные вида PROXY_USER_*=login:password
for var in $(printenv | grep '^PROXY_USER_' | sort); do
    credentials="${var#*=}"
    login="${credentials%%:*}"
    password="${credentials#*:}"

    if [ -z "$login" ] || [ -z "$password" ]; then
        echo "WARN: skipping invalid entry: $var"
        continue
    fi

    # Создаём системного пользователя без домашней директории и шелла
    if id "$login" >/dev/null 2>&1; then
        echo "User '$login' already exists, updating password"
    else
        useradd -r -M -s /bin/false "$login"
        echo "Created user: $login"
    fi

    echo "$login:$password" | chpasswd
done

echo "=== Starting danted ==="
exec danted -f /etc/danted.conf