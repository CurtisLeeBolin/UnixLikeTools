#!/usr/bin/env bash

print_help () {
  echo "rngdirname - renames dirs to random strings"
  echo
  echo "'-h, --help' Prints this help."
}

d=2
if [ "${1}" == "-h" ] || [ "${1}" == "--help" ]; then
  print_help
  exit 0
fi

i=${2}
for f in */; do
  random_string=$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 13)
  echo mv "${f}" "${random_string}"
  mv "${f}" "${random_string}"
done




