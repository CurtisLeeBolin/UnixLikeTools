#!/usr/bin/env bash
# ydda
# Downloads all audio of a channel/user/playlist or list of videos with date
# ydda <link> <link> ...

url="$@"

download_video () {
  yt-dlp \
  --embed-metadata \
  --extract-audio \
  --prefer-free-formats \
  --output "%(upload_date)s %(title)s [%(id)s].%(ext)s"  \
  $2 \
  $1
}

cookies=""
if [ -f cookies.txt ]; then
  cookies="--cookies cookies.txt"
fi

if [[ "$url" =~ ( |\') ]]; then
  arr=(${url})
  for each in "${arr[@]}"; do
    download_video ${each} "${cookies}"
  done
else
  download_video ${url} "${cookies}"
fi
