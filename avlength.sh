#!/usr/bin/env bash

check_video () {

  errorArray=()

  duration=$(ffprobe -i "${1}" 2>&1)
  duration=$(grep 'Duration: ' <(echo "$duration"))
  duration="${duration/  Duration: /}"
  duration="${duration/, */}"
  d_s=''

  if [ "${duration}" != "" ]; then
    d_hour_s=$(( 10#${duration/:*/} * 60 * 60 ))
    d_min="${duration/??:/}"
    d_min_s=$(( 10#${d_min/:*/} * 60 ))
    d_s="${duration//*:/}"
    d_s=$(bc -l <<<"${d_hour_s}+${d_min_s}+${d_s}")
  else
    d_s='--'
  fi

  echo ${d_s} \'${1}\'
}

if [ $# -eq 0 ]; then
  find ./ -type f -iname '*.mp4' -o -iname '*.mkv' | while read i; do
    check_video "${i}"
  done
else
  check_video "${1}"
fi
