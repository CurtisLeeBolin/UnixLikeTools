#!/usr/bin/env bash
# update-mg.sh

cp ~/.local/lib/mg/bin/mg ~/.local/bin/

app='mg'

if [ -d ~/.local/lib/"${app}"/ ]; then
  rm -r ~/.local/lib/"${app}"
fi

python -m venv ~/.local/lib/"${app}"

~/.local/lib/"${app}"/bin/python -m pip install --upgrade pip

~/.local/lib/"${app}"/bin/python -m pip install ~/Projects/"${app}"/

cp ~/.local/lib/"${app}"/bin/"${app}" ~/.local/bin/
