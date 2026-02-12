#!/usr/bin/env bash
# ydp
# Downloads all videos of a playlist with index
# ydp <link> <link> ...

command_array=(
  'yt-dlp'
  '--sub-lang' 'en,id,-live_chat'
  '--embed-subs'
  '--embed-metadata'
  '--live-from-start'
  '--sleep-interval' '2'
  '--retries' '3'
  '--retry-sleep' '10'
  '--output' "%(playlist_index)s %(uploader)s - %(title)s [%(id)s].%(ext)s"
)

if [ -f cookies.txt ]; then
  command_array+=('--cookies' 'cookies.txt')
fi

if [[ "$1" == '-l' ]]; then
  command_array+=('--format' 'bv[height<=1080]+ba/b[height<=1080]')
  shift
fi

if [[ "${@}" =~ ( |\') ]]; then
  arr=(${@})
  for each in "${arr[@]}"; do
    "${command_array[@]}" ${each}
    max=60
    min=15
    sleep $(shuf -i $min-$max -n 1)
  done
else
  "${command_array[@]}" ${@}
fi
