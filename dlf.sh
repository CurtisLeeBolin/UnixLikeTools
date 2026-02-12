#!/usr/bin/env bash

USER_AGENT='Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'

wget --continue --user-agent="${USER_AGENT}" --output-document="${2}" "${1}"
