#!/usr/bin/env bash

command_array=(
  'ofscraper'
  '--posts' 'all'
  '--download-area' 'all'
  '--action' 'download'
  '--after' '2000'
)

if [[ "$1" == '--images' ]]; then
  shift
  command_array+=('--filter' 'Images,Videos')
else
  command_array+=('--filter' 'Videos')
fi

command_array+=('--username' ${1})


"${command_array[@]}"
