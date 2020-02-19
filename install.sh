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

ln -si "${DOTFILES}/inputrc" "${HOME}/.inputrc"

prompt "> zsh" && ${DOTFILES}/zsh/install.sh \
  && prompt "> antibody" && ${DOTFILES}/antibody/install.sh

prompt "> tmux" && ${DOTFILES}/tmux/install.sh

prompt "> nvim" && ${DOTFILES}/nvim/install.sh

prompt "> git" && ${DOTFILES}/git/install.sh

prompt "> fzf" && ${DOTFILES}/fzf/install.sh

prompt "> bat" && ${DOTFILES}/bat/install.sh

prompt "> fonts" && ${DOTFILES}/fonts/install.sh

prompt "> editorconfig" && ${DOTFILES}/editorconfig/install.sh

prompt "> vscode" && ${DOTFILES}/vscode/install.sh

[ "$(uname -s)" = "Darwin" ] && prompt "> macos defaults" && ${DOTFILES}/macos/install.sh

