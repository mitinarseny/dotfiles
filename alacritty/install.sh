#!/bin/sh -e

. ../helpers.sh

install_linux () {
  info "installing dependencies...\n"
  sudo apt-get install --no-install-recommends --yes \
    pkg-config \
    libfreetype6-dev \
    libfontconfig1-dev \
    libxcb-xfixes0-dev \
    python3
  
  ensure_installed rustp ../rust/install.sh
  ensure_installed cmake ../cmake/install.sh

  [ -d /tmp/alacritty ] && rm -rf /tmp/alacritty
  info "cloning alacritty...\n"
  git clone https://github.com/alacritty/alacritty.git /tmp/alacritty
  cd /tmp/alacritty
  
  info "building alacritty...\n"
  cargo build --release
  
  if ! infocmp alacritty 2>&1 > /dev/null; then
    sudo tic -xe alacritty,alacritty-direct extra/alacritty.info  
  fi

  sudo cp target/release/alacritty /usr/local/bin
  sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  sudo desktop-file-install extra/linux/Alacritty.desktop
  sudo update-desktop-database

  info "installing alacritty man pages...\n"
  sudo mkdir -p /usr/local/share/man/man1
  gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null

  rm -rf /tmp/alacritty
}

install_darwin () {
  info "installing alacritty...\n"
  brew cask install alacritty
}

install_os \
  "Linux" install_linux \
  "Darwin" install_darwin

