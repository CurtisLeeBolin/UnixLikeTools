#!/usr/bin/env bash

file_type_array=(avi flv mov mp4 mpeg mpg ogg ogm ogv wmv m2ts mkv rmvb rm 3gp m4a 3g2 mj2 asf divx vob webm)

for file in *; do
  match='false'
  for ext in "${file_type_array[@]}"; do
    if [[ "${file,,}" == *"${ext}" ]]; then
      match='true'
      break
    fi
  done
  [[ "${match}" == 'false' ]] && continue
  ffmpeg -i "${file}" "${file%.*}.ass"
done
