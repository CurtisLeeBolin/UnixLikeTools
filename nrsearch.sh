#!/usr/bin/env bash

query="$@"

find $HOME/staging/nr/ -type d -iname "*${query}*"

find $HOME/staging/nr/ -type f -name info -exec bash -c "if grep --ignore-case ${query} {} >/dev/null; then echo -e '{}'; fi" \;
