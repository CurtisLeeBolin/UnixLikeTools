#!/usr/bin/env bash
# ydd
# Downloads all videos of a channel/user/playlist or list of videos with date
# ydd <link> <link> ...


finale_command_array=()

command_array=(
  'yt-dlp'
  '--sub-lang' 'en,id,-live_chat'
  '--embed-subs'
  '--embed-metadata'
  '--sleep-interval' '2'
  '--retries' '3'
  '--retry-sleep' '10'
  #'--trim-filenames' '255'
)

if [ -f cookies.txt ]; then
  command_array+=('--cookies' 'cookies.txt')
fi

if [[ "$1" == '-l' ]]; then
  command_array+=('--format' 'bv[height<=1080]+ba/b[height<=1080]')
  shift
fi

if [[ "$1" == '--lfs' ]]; then
  command_array+=('--live-from-start')
  shift
fi

append_output_template() {
  local media_string="${1}"
  local -n src_ref_array=$2
  local -n dest_ref_array=$3
  local local_copy_array=("${src_ref_array[@]}")
  if [[ "${media_string}" == *'twitch.tv/'*'/clip/'* ]]; then
    local_copy_array+=('--output' "%(upload_date)s %(creator)s - %(title)s [%(id)s].%(ext)s")
  elif [[ "${media_string}" == *'twitch.tv/'* ]]; then
    local_copy_array+=('--output' "%(upload_date)s %(uploader_id)s - %(title)s [%(id)s].%(ext)s")
  else
    local_copy_array+=('--output' "%(upload_date)s %(uploader)s - %(title)s [%(id)s].%(ext)s")
  fi
  dest_ref_array=("${local_copy_array[@]}")
}

if [[ "${@}" =~ ( |\') ]]; then
  arr=(${@})
  for each in "${arr[@]}"; do
    append_output_template "${each}" command_array finale_command_array
    "${finale_command_array[@]}" ${each}
    max=60
    min=15
    sleep $(shuf -i $min-$max -n 1)
  done
else
  append_output_template "${@}" command_array finale_command_array
  "${finale_command_array[@]}" ${@}
fi
