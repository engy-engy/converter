is_processed() {
  local file="$1"
  
  # Генерация имени mp4 файла с датой и временем
  local timestamp=$(date "+%d.%m.%Y_%H.%M.%S")
  local mp4_file="${output_dir}video_${timestamp}.mp4"

  # Вывод для отладки
  echo "Проверка файла: $file"
  echo "Путь к проверяемому файлу: $mp4_file"

  if [[ -f "$mp4_file" ]]; then
    echo "Файл $mp4_file уже обработан"
    return 0  # Файл уже обработан
  else
    echo "Файл $mp4_file не найден, требуется обработка"
    return 1  # Файл не обработан
  fi
}