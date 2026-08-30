#!/usr/bin/env bash

command_array=(
  'ofscraper'
  '--posts' 'all'
  '--download-area' 'all'
  '--action' 'download'
  '--after' '2000'
)



if [[ "$1" == '--media-id' ]]; then
  shift
  command_array+=('--media-id' "${1}")
  shift
else
  if [[ "$1" == '--images' ]]; then
    shift
    command_array+=('--mediatype' 'Images,Videos')
  fi
fi

command_array+=('--username' "${1}")
shift

"${command_array[@]}" ${@}
