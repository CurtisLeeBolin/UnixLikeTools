#!/usr/bin/env bash

file_type_array=(avi flv mov mp4 mpeg mpg ogg ogm ogv wmv m2ts mkv rmvb rm 3gp m4a 3g2 mj2 asf divx vob webm)

mkdir 0in 0out

for file in *; do
  [[ -d "${file}" ]] && continue

  match='false'
  for ext in "${file_type_array[@]}"; do
    if [[ "${file,,}" == *"${ext}" ]]; then
      match='true'
      break
    fi
  done
  [[ "${match}" == 'false' ]] && continue

  mv "${file}" 0in/"${file}"
  volume=$(ffmpeg -i 0in/"${file}" -video_disable -subtitle_disable -filter:a volumedetect -f null /dev/null 2>&1 | grep 'max_volume' | awk '{print $5}')
  ffmpeg -i 0in/"${file}" -codec:v copy -filter:a volume="${volume:1}" -codec:a libopus -codec:s copy 0out/"${file}"
done
