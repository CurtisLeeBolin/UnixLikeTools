#!/usr/bin/env bash
# cddl.sh

command_array=(
  'cyberdrop-dl'
  '--download'
  '--output-folder' './'
)

if [[ "$1" == '--images' ]]; then
  shift
  command_array+=('--exclude-audio')
else
  command_array+=(
    '--exclude-images'
    '--exclude-audio'
  )
fi

"${command_array[@]}" ${@}
