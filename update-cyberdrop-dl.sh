#!/usr/bin/env bash
# update-cyberdrop-dl.sh

app='cyberdrop-dl'

if [ -d ~/.local/lib/"${app}"/ ]; then
  rm -r ~/.local/lib/"${app}"
fi

python -m venv ~/.local/lib/"${app}"

~/.local/lib/"${app}"/bin/python -m pip install --upgrade pip

#~/.local/lib/"${app}"/bin/python -m pip install git+https://github.com/evan-sm/"${app}".git
~/.local/lib/"${app}"/bin/python -m pip install "${app}[extra]"

cp ~/.local/lib/"${app}"/bin/"${app}" ~/.local/bin/
