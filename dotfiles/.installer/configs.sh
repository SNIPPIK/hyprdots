#!/usr/bin/env bash
set -euo pipefail  # Строгий режим: выход при ошибке, запрет неинициализированных переменных

# Ассоциативный массив: целевая базовая директория (относительно $HOME) -> исходная базовая директория в репозитории
declare -A CONFIG_BASES=(
    [".config"]="$HOME/hyprdots/dotfiles/Files/Configs"
    [".local/state"]="$HOME/hyprdots/dotfiles/Files/State"
)

# Универсальная функция для создания симлинков в разные базовые директории
linkConfig() {
    local name="$1"
    local target_base="${2:-.config}"
    local source_base="${CONFIG_BASES[$target_base]}"

    if [[ -z "$source_base" ]]; then
        echo "Ошибка: неизвестная целевая база '$target_base'" >&2
        echo "Доступные базы: ${!CONFIG_BASES[*]}" >&2
        return 1
    fi

    local target="$HOME/$target_base/$name"
    local source="$source_base/$name"

    if [[ ! -e "$source" ]]; then
        echo "Ошибка: исходный файл/папка '$source' не существует" >&2
        return 1
    fi

    # Если цель уже существует — делаем бэкап с уникальным именем
    if [[ -e "$target" || -L "$target" ]]; then
        local backup="${target}.bak.$(date +%Y%m%d%H%M%S).$$"
       rm -rf "$target"
        echo "Существующий '$target' перемещён в '$backup' (или удалён)"
    fi

    # Создаём симлинк
    ln -s "$source" "$target"
    echo "Создана ссылка: $target -> $source"
}

# Функция для линковки отдельных файлов (например, .bashrc)
linkFile() {
    local file="$1"
    local target="$HOME/$file"
    local source="$HOME/hyprdots/dotfiles/Files/Additions/$file"

    if [[ ! -e "$source" ]]; then
        echo "Ошибка: исходный файл '$source' не существует" >&2
        return 1
    fi

    if [[ -e "$target" || -L "$target" ]]; then
        local backup="${target}.bak.$(date +%Y%m%d%H%M%S).$$"
        rm -f "$target"
        echo "Существующий '$target' перемещён в '$backup' (или удалён)"
    fi

    ln -s "$source" "$target"
    echo "Создана ссылка: $target -> $source"
}

# Линковка директорий из Configs
configs_dir="$HOME/hyprdots/dotfiles/Files/Configs"
if [[ -d "$configs_dir" ]]; then
    for path in "$configs_dir"/*; do
        [[ -e "$path" ]] || continue
        name="$(basename "$path")"
        linkConfig "$name"
    done
fi

# Линковка директорий из State
state_dir="$HOME/hyprdots/dotfiles/Files/State"
if [[ -d "$state_dir" ]]; then
    for path in "$state_dir"/*; do
        [[ -e "$path" ]] || continue
        name="$(basename "$path")"
        linkConfig "$name" ".local/state"
    done
fi

# Линковка отдельных файлов
for file in ".bashrc" ".gtkrc-2.0"; do
    linkFile "$file"
done

# Настройка обоев
pictures_dir="$HOME/Pictures"
wallpapers_src="$HOME/hyprdots/dotfiles/Pictures/Wallpapers"
wallpapers_dst="$pictures_dir/Wallpapers"

mkdir -p "$pictures_dir"

if [[ -d "$wallpapers_src" ]]; then
    if [[ -d "$wallpapers_dst" || -L "$wallpapers_dst" ]]; then
        # Копируем только нужные файлы (можно использовать install для одиночных файлов)
        install -Dm644 "$wallpapers_src/hyprland.png" "$wallpapers_dst/hyprland.png"
        install -Dm644 "$wallpapers_src/hyprlock.png" "$wallpapers_dst/hyprlock.png"
    else
        # Если каталога Wallpapers нет — копируем целиком
        cp -r "$wallpapers_src" "$wallpapers_dst"
    fi
else
    echo "Предупреждение: исходная папка с обоями '$wallpapers_src' не найдена"
fi

# Установка шрифтов
echo "Установка шрифтов..."

fonts_dir="$HOME/.fonts"
mkdir -p "$fonts_dir"

fonts_src="$HOME/hyprdots/dotfiles/Files/Fonts"
if [[ -d "$fonts_src" ]]; then
    for font in "$fonts_src"/*; do
        [[ -f "$font" ]] || continue
        cp "$font" "$fonts_dir/"
    done
else
    echo "Предупреждение: исходная папка со шрифтами '$fonts_src' не найдена"
fi

# Обновление кэша шрифтов
fc-cache -f -v