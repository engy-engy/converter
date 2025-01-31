#!/bin/bash

# Подключаем другие скрипты
source "$HOME/scripts/converter/check_utils.sh"
source "$HOME/scripts/converter/generate_filename.sh"
source "$HOME/scripts/converter/is_processed.sh"
source "$HOME/scripts/converter/convert_video.sh"
source "$HOME/scripts/converter/create_gif.sh"

# Директории
input_dir="$HOME/Desktop/Скриншоты/"
output_dir="$HOME/Desktop/Скриншоты/"
gif_output_dir="$HOME/Desktop/GIF/"

# Проверка наличия утилит
check_utils

# Создаём выходные директории, если их нет
mkdir -p "$output_dir" "$gif_output_dir"

# Фильтрация событий fswatch (чтобы игнорировать временные файлы)
fswatch -0 "$input_dir" | while read -d "" event; do
  file=$(basename "$event")

  # Проверяем, что файл - это видео и что он ещё не обработан
  if [[ "$file" == Запись\ экрана*.mov ]] && ! is_processed "$file"; then
    input_path="${input_dir}${file}"
    
    # Ждём, пока файл допишется (чтобы не обработать его частично)
    while lsof | grep -q "$input_path"; do
      sleep 1
    done

    new_name=$(generate_filename)
    output_path="${output_dir}video_${new_name}.mp4"

    echo "$(date +"%Y-%m-%d %H:%M:%S") Обнаружен файл: $file. Начинаю обработку..."

    # Конвертация в MP4 с максимальным качеством
    convert_video "$input_path" "$output_path"

    if [[ $? -ne 0 ]]; then
      echo "$(date +"%Y-%m-%d %H:%M:%S") Ошибка при обработке $file"
      continue
    fi

    echo "$(date +"%Y-%m-%d %H:%M:%S") Видео сохранено: $output_path"
    rm "$input_path"

    # Генерация имени GIF
    gif_name="gif_${new_name}.gif"
    palette_file=$(mktemp "/tmp/palette-XXXXXX.png")

    # Генерация палитры и создание GIF
    create_gif "$output_path" "$gif_output_dir$gif_name" "$palette_file"
  fi
done