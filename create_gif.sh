#!/bin/bash

create_gif() {
  local video_path="$1"
  local gif_path="$2"
  local palette_file="$3"

  # Генерация палитры
  ffmpeg -y -i "$video_path" \
    -vf "fps=30,scale=1080:-1:flags=lanczos,palettegen=max_colors=256" \
    "$palette_file" &> /dev/null

  if [[ $? -ne 0 ]]; then
    echo "$(date +"%Y-%m-%d %H:%M:%S") Ошибка при создании палитры"
    rm -f "$palette_file"
    return 1
  fi

  # Создание GIF с максимальным качеством
  ffmpeg -y -i "$video_path" -i "$palette_file" \
    -lavfi "fps=30,scale=1080:-1:flags=lanczos[x];[x][1:v]paletteuse=dither=floyd_steinberg" \
    -loop 0 "$gif_path" &> /dev/null

  if [[ $? -ne 0 ]]; then
    echo "$(date +"%Y-%m-%d %H:%M:%S") Ошибка при создании GIF"
    rm -f "$palette_file"
    return 1
  fi

  echo "$(date +"%Y-%m-%d %H:%M:%S") GIF успешно создан: $gif_path"

  # Удаление временной палитры
  rm -f "$palette_file"
}