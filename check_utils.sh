#!/bin/bash

check_utils() {
  for cmd in fswatch ffmpeg; do
    command -v "$cmd" >/dev/null 2>&1 || { echo "Ошибка: $cmd не найден. Установите его."; exit 1; }
  done
}