#!/usr/bin/env bash

find . -maxdepth 1 -type f | while read file; do mv "${file}" "${file:2:-4}/$(date +%s%N).zip"; done
