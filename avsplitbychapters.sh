#!/bin/bash
# Use this to split by chapter.
# Once you know last chapter of each
# episode, run the following:
# $ mkvmerge -o fileOut.mkv --split chapters:1,2,3 0in/fileIn.mkv


if [ -n "${1}" ]; then
  e=$(mkvmerge -o "${1%.*}_.mkv" --split chapters:all "${1}" | tee /dev/stderr)

  output_array=()

  mapfile -t a <<< "${e}"
  for i in "${a[@]}"; do
    output_string="$(echo "${i}" | sed -nE "s/.*The file '(.*)' has been opened for writing.*/\1/p")"
    if [ -n "$output_string" ]; then
      output_array+=("${output_string}")
    fi
  done

  for i in "${output_array[@]}"; do
    mkvpropedit "${i}" --chapters ''
  done
else
  echo 'Error: no file given'
  exit 1
fi

