#!/bin/bash

convert_video() {
  local input_path="$1"
  local output_path="$2"

  ffmpeg -y -i "$input_path" \
    -vf "scale=-2:1080" \
    -c:v libx264 -preset slow -crf 16 \
    -c:a aac -b:a 192k \
    "$output_path" &> /dev/null
}