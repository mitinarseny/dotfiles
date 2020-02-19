#!/bin/sh -eu

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

if ! command -v zsh > /dev/null 2>&1; then 
  echo 'zsh in not in ${PATH} and can not be set as default shell' >&2
else
  ZSH=$(command -v zsh)
  echo "Setting ${ZSH} as default shell" && chsh -s "${ZSH}"
fi

ln -si ${SCRIPT_DIR}/zshrc ${HOME}/.zshrc

