#!/bin/sh -ex

cd "$(dirname "$0")"
ln -sfv "$(pwd -P)"/zshrc ~/.zshrc
ln -sfv "$(pwd -P)"/zprofile ~/.zprofile

# check if CI
[ -n "${CI+x}" ] && exit

if ! command -v antibody > /dev/null; then
  curl --fail --silent --show-error --location git.io/antibody | sudo sh -s - -b /usr/local/bin
fi

antibody bundle < plugins.txt > ~/.zsh_plugins.sh

if ! grep "$(command -v zsh)" /etc/shells > /dev/null; then
  echo $(command -v zsh) | sudo tee -a /etc/shells > /dev/null
fi

chsh -s "$(command -v zsh)"
