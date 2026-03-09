#!/usr/bin/env bash
# update-whisper.sh

app='whisper'

python -m venv ~/.local/lib/"${app}"

~/.local/lib/"${app}"/bin/python -m pip install --upgrade pip

# Install the CPU only version of torch
~/.local/lib/"${app}"/bin/python -m pip install --upgrade torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

~/.local/lib/"${app}"/bin/python -m pip install --upgrade pip openai-whisper

cp ~/.local/lib/"${app}"/bin/"${app}" ~/.local/bin/
