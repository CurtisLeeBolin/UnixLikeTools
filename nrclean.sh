#!/usr/bin/env bash


############
#Dependences
#  - 7zip
#  - fdupes
#  - nrmvclips
############


function move {
  file="${1##*/}"
  filename="${file%.*}"
  fileext="${file##*.}"
  fileext="${fileext,,}"  #lower case file extension
  file="${filename}.${fileext}"
  if [ ! -f "${2}/${file}" ]; then
    mv "${1}" "${2}/${file}"
  else
    index=$(date +"%s%N")
    mv "${1}" "${2}/${filename}_${index}.${fileext}"
  fi
}

# find files with the same base name and rename
function base_rename {
  a=''
  while read -r i; do
    filename="${i%.*}"
    fileext="${i##*.}"
    fileext="${fileext,,}"  #lower case file extension
    if [ './info' != "${i}" ] && [ "${filename}" == "${a}" ]; then
      index=$(date +"%s%N")
      mv "${i}" "${filename}_${index}.${fileext}"
    fi
    a="${filename}"
  done
}

function clean {
  if [ ! -d images ]; then
    mkdir images
  fi
  pwd

  # extract archives
  find . -iregex '.*\(zip\|rar\|7z\)' -exec 7z x {} -y \;

  # move all images to ./images/
  find ./* -not -path './images/*' -type f -iregex '.*\(jpg\|jpeg\|png\|gif\|webp\)' | \
    while read file; do
      move "$file" images;
    done

  # move all videos to ./
  find ./* -mindepth 1 -type f -iregex '.*\(mkv\|mp4\|m4v\|mov\|avi\|wmv\|webm\|ts\)' | \
    while read file; do
      move "$file" .;
    done

  # remove files that are not images, videos, or info
  find ./* -type f -not -iregex '.*\(jpg\|jpeg\|png\|gif\|webp\|mkv\|mp4\|m4v\|mov\|avi\|wmv\|webm\|ts\|info\)' -exec rm {} \;

  # remove directories that aren't ./images/
  find ./* -type d -not -name 'images' -exec rm -r {} \; # ./* to not return . directory

  # find uppercase image file extensions and rename
  find -path './images/*' -type f -regextype posix-extended -regex '.*[A-Z].{,3}$' | \
    while read file; do
      move "$file" images;
    done

  # find uppercase video file extensions and rename
  find -maxdepth 1 -type f -regextype posix-extended -regex '.*[A-Z].{,3}$' | \
    while read file; do
      move "$file" .;
    done

  # find images with the same base name and rename
  find -path './images/*' -type f | sort | base_rename

  # find vidoes with the same base name and rename
  find -maxdepth 1 -type f | sort | base_rename

  fdupes -rdN ./
  rmdir --ignore-fail-on-non-empty images
}

if [ ! -z "$1" ]; then
  if [ -d "$1" ]; then
    original_mtime=$(stat -c %Y "$1")
    start_directory=$(pwd)
    cd "$1"
    clean
    cd "${start_directory}"
    touch -d "@$original_mtime" "$1"
  else
    echo "\'$1\' does not exist."
    exit
  fi
else
  original_mtime=$(stat -c %Y ".")
  clean
  touch -d "@$original_mtime" "."
fi
