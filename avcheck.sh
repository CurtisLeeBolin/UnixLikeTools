#!/usr/bin/env bash

check_video () {

  errorArray=()

  data=$(ffprobe -i "${1}" 2>&1)

  if [ $? -ne 0 ]; then
    errorArray+=('ffprobe error')
  else
    if [[ "${data}" != *"Video:"* ]]; then
      errorArray+=('Video missing')
    fi

    if [[ "${data}" != *"Audio:"* ]]; then
      errorArray+=('Audio missing')
    fi
  fi

  if [ ${#errorArray[@]} -ne 0 ]; then
    echo "${1}"
    #for (( i=0; i<${#errorArray[@]}; i++ )) do
    for i in "${errorArray[@]}"; do
      echo "${i}"
    done
    echo
  fi
}

if [ $# -eq 0 ]; then
  find ./ -type f -iname '*.mkv' | while read i; do
    check_video "${i}"
  done
else
  check_video "${1}"
fi
