#!/bin/bash

SDDM_DIR="/usr/share/sddm/faces"

# Проверка прав
if [ "$EUID" -ne 0 ]; then
    echo "Запуск с sudo..."
    exec sudo "$0" "$@"
fi

mkdir -p "$SDDM_DIR"

# Копируем все .face.icon
found=0
for user in $(ls /home); do
    source_file="/home/$user/.face.icon"
    target_file="$SDDM_DIR/${user}.face.icon"
    
    if [ -f "$source_file" ]; then
        # Удаляем если существует (даже если это ссылка или файл)
        if [ -e "$target_file" ]; then
            rm -f "$target_file"
            echo "→ Удален старый файл для $user"
        fi
        
        # Копируем новый
        cp "$source_file" "$target_file"
        echo "✓ Установлен аватар для $user"
        ((found++))
    fi
done

# Устанавливаем права
if [ $found -gt 0 ]; then
    echo "==========================="
    echo "Обновлено аватаров: $found"
else
    echo "Файлы .face.icon не найдены в /home/*/"
    echo "Создайте их: cp your_avatar.jpg ~/.face.icon"
fi