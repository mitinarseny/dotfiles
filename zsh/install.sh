#!/bin/sh -e

cd "$(dirname "$0")"
ln -sfv $(readlink -ev zshrc) ~/.zshrc

# check if CI
[ -z "${CI+x}" ] && exit

if ! command -v antibody > /dev/null; then
  curl --fail --silent --show-error --location git.io/antibody | sh -s - -b /usr/local/bin
fi

antibody bundle < plugins.txt > ~/.zsh_plugins.sh

if ! grep "$(command -v zsh)" /etc/shells > /dev/null; then
  sudo sh -c "echo $(command -v zsh) >> /etc/shells"
fi

chsh -s "$(command -v zsh)"
