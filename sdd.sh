#!/usr/bin/env bash
# sd
# Downloads a stream
# sd <link>


URL=$(echo "${@}" | grep -Eo '(https?://[^[:space:]]+)')
CHANNEL=$(echo "$URL" | grep -Eo 'https?://[^/]+/[^/? ]+' | grep -Eo '[^/]+$')
METADATA=$(streamlink --json "${URL}")
TITLE=$(echo "$METADATA" | jq -r '.metadata.title // "Untitled"')
TITLE="${TITLE//\//-}"
ID=$(echo "$METADATA" | jq -r '.metadata.id // "000"')
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
FILENAME_TS="${TIMESTAMP} ${CHANNEL} - ${TITLE} [${ID}].mp4"
FILENAME_MKV="${TIMESTAMP} ${CHANNEL} - ${TITLE} [${ID}].mkv"

command_array_stream=(
  'streamlink'
  '--hls-live-restart'
  '--ffmpeg-start-at-zero'
  '--force'
  '--ffmpeg-fout' 'matroska'
  '--output' "${FILENAME_TS}"
  "${URL}"
  'best'
)

command_array_stream_soop=(
  'streamlink'
  '--hls-live-restart'
  '--ffmpeg-start-at-zero'
  '--force'
  '--ffmpeg-fout' 'matroska'
  '--http-cookies-file' 'cookies.txt'
  '--output' "${FILENAME_TS}"
  "${URL}"
  'best'
)

remux () {
  if mkvmerge --output "${FILENAME_MKV}" "${FILENAME_TS}"; then
    rm "${FILENAME_TS}"
  else
    rm "${FILENAME_MKV}"
  fi
}

get_stream () {
  if [[ "${1}" == *"sooplive.com/"* ]]; then
    "${command_array_stream_soop[@]}"
    remux
  else
    "${command_array_stream[@]}"
    remux
  fi
}

get_stream "${URL}"
