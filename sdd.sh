#!/usr/bin/env bash
# sd
# Downloads a stream
# sd <link>


url=$(echo "${@}" | grep -Eo '(https?://[^[:space:]]+)')

command_array_stream=(
  'streamlink'
  '--hls-live-restart'
  '--ffmpeg-start-at-zero'
  '--force'
  '--output' '{time:%Y%m%d%H%M%S} {author} - {title} [{id}].mp4'
  "${url}"
  'best'
)

command_array_clip=(
  'streamlink'
  '--hls-live-restart'
  '--ffmpeg-start-at-zero'
  '--force'
  '--output' '{author} - {title} [{id}].mp4'
  "${url}"
  'best'
)

command_array_stream_soop=(
  'streamlink'
  '--hls-live-restart'
  '--ffmpeg-start-at-zero'
  '--force'
  '--http-cookies-file' 'cookies.txt'
  '--output' '{time:%Y%m%d%H%M%S} {author} - {title} [{id}].mp4'
  "${url}"
  'best'
)

get_stream () {
  if [[ "${1}" == *"/clip/"* ]]; then
    "${command_array_clip[@]}"
  elif [[ "${1}" == *"sooplive.com/"* ]]; then
    "${command_array_stream_soop[@]}"
  else
    "${command_array_stream[@]}"
  fi
}

get_stream "${url}"
