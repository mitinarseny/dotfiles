#!/bin/sh

DOTFILES=$(cd "$(dirname "$0")" && pwd)

prompt() {
  while true; do
    read -p "$1 [Y/n]: " yn
    case $yn in
      [Yy]* ) return;;
      [Nn]* ) return 1;;
      * ) echo "Please answer yes or no.";;
    esac
  done
}

prompt "> tmux" && ${DOTFILES}/tmux/update.sh
prompt "> antibody" && ${DOTFILES}/antibody/update.sh

