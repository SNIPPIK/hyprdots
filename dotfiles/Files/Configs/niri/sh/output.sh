#!/bin/sh

# 1. Функция для графического меню (ищет fuzzel, rofi или wofi)
gui_menu() {
    title="$1"
    rofi -dmenu -p "$title" -theme windows/"simple".rasi
}

if ! command -v niri >/dev/null 2>&1; then
    logger "Niri-Script Error: niri not found!"
    exit 1
fi

# Получаем данные мониторов
outputs_data=$(niri msg outputs)

# 2. Выбор монитора через GUI
# Формируем список: убираем кавычки, оставляем понятные строки
monitor_list=$(echo "$outputs_data" | grep -E '^Output ' | sed 's/^Output //; s/"//g')

if [ -z "$monitor_list" ]; then
    exit 1
fi

selected_monitor=$(echo "$monitor_list" | gui_menu "Выберите монитор")
if [ -z "$selected_monitor" ]; then
    exit 0 # Пользователь закрыл меню (нажал Esc)
fi

# Вычисляем порядковый номер выбранного монитора в списке
target_idx=$(echo "$monitor_list" | grep -n -F "$selected_monitor" | cut -d: -f1)

# Вырезаем системное имя коннектора из скобок (например, eDP-1 или DP-2)
selected_connector=$(echo "$selected_monitor" | awk -F'(' '{print $2}' | sed 's/)//')
if [ -z "$selected_connector" ]; then
    selected_connector=$(echo "$outputs_data" | grep -E '^Output ' | sed -n "${target_idx}p" | sed 's/^Output //')
fi

# 3. Выбор режима через GUI
# Достаем доступные разрешения именно для этого монитора с помощью awk
modes=$(echo "$outputs_data" | awk -v target="$target_idx" '
    /^Output / { count++ }
    count == target {
        if ($1 ~ /^[0-9]+x[0-9]+/) {
            print $1
        }
    }
')

# Формируем финальное меню для выбора частоты (auto идет первой строкой)
menu_modes="$modes"

selected_mode=$(echo "$menu_modes" | gui_menu "Режим для $selected_connector")
if [ -z "$selected_mode" ]; then
    exit 0 # Пользователь отменил выбор
fi

# 4. Применяем настройки в Niri
niri msg output "$selected_connector" mode "$selected_mode"
