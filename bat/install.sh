#!/bin/sh -e

. ../helpers.sh

install_linux () {
  info "installing bat...\n"
  sudo apt-get install --no-install-recommends --yes bat
  mkdir -p ~/.local/bin
  ln -s /usr/bin/batcat ~/.local/bin/bat
}

install_darwin () {
  info "installing bat...\n"
  brew install bat
}

install_os \
  "Linux" install_linux \
  "Darwin" install_darwin

