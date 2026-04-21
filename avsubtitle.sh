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
  ffmpeg -i 0in/"${file}" -vn -sn -ar 16000 -ac 1 -c:a pcm_s16le 0in/"${file%.*}.wav"
  whisper 0in/"${file}" --model large --device cpu --fp16 False --language English --output_format vtt --output_dir 0in
  if [[ "${file,,}" =~ \.(mkv|webm)$ ]]; then
    ffmpeg -i 0in/"${file}" -i 0in/"${file%.*}.vtt" -codec copy 0out/"${file}"
  else
    ffmpeg -i 0in/"${file}" -i 0in/"${file%.*}.vtt" -codec copy 0out/"${file%.*}.mkv"
  fi
done
