#!/bin/sh -e

. ../helpers.sh

install_linux () {
  info "installing dependencies...\n"
  sudo apt-get install --no-install-recommends --yes \
    gnupg \
    software-properties-common \
    wget

  info "adding keys...\n"
  wget -O - "https://apt.kitware.com/keys/kitware-archive-latest.asc" 2> /dev/null \
    | gpg --dearmor - \
    | sudo apt-key add -
  
  info "adding repository...\n"
  sudo apt-add-repository 'deb https://apt.kitware.com/ubuntu/ focal main'
  
  info "updating cache...\n"
  sudo apt-get update

  info "installing cmake...\n"
  sudo apt-get install --no-install-recommends --yes \
    cmake \
    make
}

install_darwin () {
  info "installing cmake...\n"
  brew install cmake
}

install_os \
  "Linux" install_linux \
  "Darwin" install_darwin

