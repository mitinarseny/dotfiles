#!/bin/sh -e

cd "$(dirname "$0")"
. ../helpers.sh

install_linux () {
  log_info "Installing dependencies...\n"
  sudo apt-get install --no-install-recommends --yes \
    pkg-config \
    libfreetype6-dev \
    libfontconfig1-dev \
    libxcb-xfixes0-dev \
    python3
  
  ensure_installed rustup ../rust/install.sh
  ensure_installed cmake ../cmake/install.sh

  [ -d /tmp/alacritty ] && rm -rf /tmp/alacritty
  log_info "Cloning alacritty...\n"
  git clone https://github.com/alacritty/alacritty.git /tmp/alacritty
  cd /tmp/alacritty
  
  log_info "Building alacritty...\n"
  cargo build --release
  
  if ! infocmp alacritty 2>&1 > /dev/null; then
    sudo tic -xe alacritty,alacritty-direct extra/alacritty.info  
  fi

  sudo cp target/release/alacritty /usr/local/bin
  sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  sudo desktop-file-install extra/linux/Alacritty.desktop
  sudo update-desktop-database

  log_info "Installing alacritty man pages...\n"
  sudo mkdir -p /usr/local/share/man/man1
  gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null

  rm -rf /tmp/alacritty
}

install_darwin () {
  log_info "Installing alacritty...\n"
  brew cask install alacritty
}

OS="$(uname -s)"
case "${OS}" in
  "Linux")
    install_linux
    ;;
  "Darwin")
    install_darwin
    ;;
  *)
    log_error "${OS} is not supported\n"
    ;;
esac

