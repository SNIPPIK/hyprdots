#!/bin/bash
#  __        __    _ _
#  \ \      / /_ _| | |_ __   __ _ _ __   ___ _ __
#   \ \ /\ / / _` | | | '_ \ / _` | '_ \ / _ \ '__|
#    \ V  V / (_| | | | |_) | (_| | |_) |  __/ |
#     \_/\_/ \__,_|_|_| .__/ \__,_| .__/ \___|_|
#                     |_|         |_|
# -----------------------------------------------------
# Скрипт для управления обоями с поддержкой видео (mp4) через mpvpaper и
# двух движков обоев (swww, hyprpaper), с выбором через rofi и показом превью.

# Параметры по умолчанию
wallpaper_default_file="$HOME/Pictures/Wallpapers/hyprland.png"
wallpaper_default_dir="$HOME/Pictures/Wallpapers"
wallpaper_cache_file="$HOME/.cache/current_wallpaper"

RANDOM_WALLPAPER_INTERVAL=300    # Интервал автосмены в секундах
SWWW_FPS_WALLPAPER=50           # FPS для плавности перехода в swww

# Определяем движок: swww, hyprpaper или "install" (нет)
function find_engine() {
    if command -v pacman >/dev/null 2>&1; then
        if pacman -Qs swww >/dev/null 2>&1; then
            echo "swww"
            return
        elif pacman -Qs hyprpaper >/dev/null 2>&1; then
            echo "hyprpaper"
            return
        fi
    fi
    hyprctl notify 3 10000 "rgb(ff0000)" "Wallpaper engine not found. Please install hyprpaper or swww!"
    echo "install"
}
engine="$(find_engine)"

# Функция для сохранения текущего обоев в кэш
function saveFile() {
    echo "$1" > "$wallpaper_cache_file"
    # Для динамической смены цветов (если используешь wal)
    # wal -i "$1"
}

# Основная функция смены обоев
# Принимает полный путь к обоям $1
function change_wallpaper() {
    local wallpaper_path="$1"
    local ext="${wallpaper_path##*.}"
    ext="${ext,,}"  # к нижнему регистру

    # Обработка видео с помощью mpvpaper
    if [[ "$ext" == "mp4" ]]; then
        # Если mpvpaper запущен — убиваем старый процесс
        if pgrep -x mpvpaper >/dev/null; then
            pkill mpvpaper
        fi
        # Запускаем mpvpaper с нужными параметрами: цикл, полный экран, без сохранения пропорций
        mpvpaper -auto-pause -auto-stop -o "--loop --fs --no-keepaspect" ALL "$wallpaper_path" &
        exit 0
    else
        # Для картинок завершаем mpvpaper, если он был запущен
        if pgrep -x mpvpaper >/dev/null; then
            pkill mpvpaper
        fi
    fi

    # Работа с выбранным движком
    if [ "$engine" == "swww" ]; then
        swww img "$wallpaper_path" --transition-fps $SWWW_FPS_WALLPAPER

        # Освобождаем кеш спустя 2 секунды (для экономии памяти)
        sleep 2
        swww clear-cache &

    elif [ "$engine" == "hyprpaper" ]; then
        # Для каждого монитора устанавливаем обои
        for monitor in $(hyprctl monitors | grep 'Monitor' | awk '{print $2}'); do
            hyprpaper preload "$wallpaper_path" &
            hyprpaper wallpaper "$monitor,$wallpaper_path" &
        done

        # Разгружаем кеш через 2 секунды
        sleep 2
        hyprpaper unload all &

    else
        hyprctl notify 3 10000 "rgb(ff0000)" "Wallpaper engine not found. Please install hyprpaper or swww!"
    fi

    # Сохраняем путь в кэш
    saveFile "$wallpaper_path"
}

# Функция рестарта движка обоев
function restart_engine() {
    if [ "$engine" == "swww" ]; then
        if pgrep -x swww >/dev/null; then
            pkill swww
            hyprctl notify 1 2000 "rgb(ffffff)" "Wallpaper Engine | Restarting swww"
        else
            hyprctl notify 1 2000 "rgb(ffffff)" "Wallpaper Engine | Starting swww"
        fi
        swww init &
        swww-daemon &

    elif [ "$engine" == "hyprpaper" ]; then
        if pgrep -x hyprpaper >/dev/null; then
            pkill hyprpaper
            hyprctl notify 1 2000 "rgb(ffffff)" "Wallpaper Engine | Restarting hyprpaper"
        else
            hyprctl notify 1 2000 "rgb(ffffff)" "Wallpaper Engine | Starting hyprpaper"
        fi
        hyprpaper &

    else
        hyprctl notify 3 10000 "rgb(ff0000)" "Wallpaper engine not found. Please install hyprpaper or swww!"
    fi

    # Подгружаем обои из кэша, если он есть
    if [ -f "$wallpaper_cache_file" ]; then
        wallpaper_default_file="$(cat "$wallpaper_cache_file")"
    fi

    sleep 2
    change_wallpaper "$wallpaper_default_file"
}

# Обёртка для вызова rofi с темой
function rofi_dialog_menu() {
    rofi -dmenu -i -p "Select wallpaper to change" -theme windows/wallpaper
}

# Функция выбора и генерации превью в rofi
# Аргумент $1: "random" или "select"
function support_type() {
    # Проверяем наличие каталога с обоями
    if [ ! -d "$wallpaper_default_dir" ]; then
        hyprctl notify 3 10000 "rgb(ff0000)" "Wallpaper directory not found: $wallpaper_default_dir"
        exit 1
    fi

    # Динамически проверяем наличие mpvpaper
    if command -v mpvpaper >/dev/null 2>&1; then
        can_show_videos=true
    else
        can_show_videos=false
    fi

    if [ "$engine" == "swww" ]; then

        if [ "$1" == "random" ]; then
            random_background=$(find -L "$wallpaper_default_dir" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) | shuf -n 1)
            change_wallpaper "$random_background"

        elif [ "$1" == "select" ]; then
            preview_dir="/tmp/wallpaper_previews"
            mkdir -p "$preview_dir"
            declare -A file_map
            rofi_input=""

            # Формируем список с учётом поддержки mp4
            mapfile -t rofi_lines < <(find -L "$wallpaper_default_dir" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.mp4' \) | sort)

            for full_path in "${rofi_lines[@]}"; do
                filename=$(basename "$full_path")
                ext="${filename##*.}"
                ext="${ext,,}"

                # Если mp4 и mpvpaper нет - пропускаем
                if [[ "$ext" == "mp4" && "$can_show_videos" == false ]]; then
                    continue
                fi

                file_map["$filename"]="$full_path"

                if [[ "$ext" == "mp4" ]]; then
                    preview_file="$preview_dir/${filename}.png"
                    if [ ! -f "$preview_file" ]; then
                        # Генерируем превью кадр из видео
                        ffmpeg -y -ss 2 -i "$full_path" -vframes 1 -vf "scale=320:-1" "$preview_file" >/dev/null 2>&1
                    fi
                else
                    preview_file="$full_path"
                fi

                rofi_input+="${filename}\x00icon\x1f${preview_file}\n"
            done

            selected_wallpaper=$(echo -e "$rofi_input" | rofi_dialog_menu)

            if [[ -z "$selected_wallpaper" ]]; then
                exit 1
            fi

            original_path="${file_map[$selected_wallpaper]}"
            change_wallpaper "$original_path"
        fi

    elif [ "$engine" == "hyprpaper" ]; then
        # hyprpaper не поддерживает видео, показываем только картинки

        if [ "$1" == "random" ]; then
            random_background=$(find -L "$wallpaper_default_dir" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) | shuf -n 1)
            change_wallpaper "$random_background"

        elif [ "$1" == "select" ]; then
            selected_wallpaper=$(find -L "$wallpaper_default_dir" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \) -printf "%P\x00icon\x1f${wallpaper_default_dir}/%P\n" | sort | rofi_dialog_menu)

            if [[ -z "$selected_wallpaper" ]]; then
                exit 1
            fi

            change_wallpaper "$wallpaper_default_dir/$selected_wallpaper"
        fi
    else
        hyprctl notify 3 10000 "rgb(ff0000)" "Wallpaper engine not found. Please install hyprpaper or swww!"
        exit 1
    fi
}

# Главный блок вызова по аргументу
case "$1" in
    random)
        support_type "random"
        ;;
    select)
        support_type "select"
        ;;
    auto)
        while true; do
            support_type "random"
            sleep "$RANDOM_WALLPAPER_INTERVAL"
        done
        ;;
    engine)
        restart_engine
        ;;
    *)
        echo "Usage: $0 {random|select|auto|engine}"
        exit 1
        ;;
esac
