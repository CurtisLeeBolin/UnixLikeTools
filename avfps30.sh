#!/usr/bin/env bash

dir_in='0in'
dir_out='0out'

if [ ! -d "${dir_out}" ]; then
  mkdir "${dir_in}" "${dir_out}"
fi

for i in *.mp4; do
  ffmpeg -discard nokey -i "${i}" -r 30 -codec copy -y "${dir_out}/${i%.*}.mkv"
  if [ $? -eq 0 ]; then
    mv "${i}" "${dir_in}/${i}"
  fi
done
