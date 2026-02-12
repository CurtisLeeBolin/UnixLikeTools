#!/usr/bin/env bash
# update-streamlink.sh

app='streamlink'

if [ -d ~/.local/lib/"${app}"/ ]; then
  rm -r ~/.local/lib/"${app}"
fi

python -m venv ~/.local/lib/"${app}"

~/.local/lib/"${app}"/bin/python -m pip install --upgrade pip

~/.local/lib/"${app}"/bin/python -m pip install git+https://github.com/"${app}"/"${app}".git

cp ~/.local/lib/"${app}"/bin/"${app}" ~/.local/bin/
