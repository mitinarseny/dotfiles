#!/bin/sh -e

. ../helpers.sh

readonly BREW_CASK="alacritty"

case "${OS}" in
  "Linux")
    executable rustup || ../rust/install.sh

    [ -d /tmp/alacritty ] && rm -rf /tmp/alacritty
    git clone https://github.com/alacritty/alacritty.git /tmp/alacritty
    cd /tmp/alacritty
    
    sudo apt-get install --yes --no-install-recommends \
      cmake \
      pkg-config \
      libfreetype6-dev \
      libfontconfig1-dev \
      libxcb-xfixes0-dev \
      python3

    cargo build --release
    
    if ! infocmp alacritty 2>&1 > /dev/null; then
      sudo tic -xe alacritty,alacritty-direct extra/alacritty.info  
    fi

    sudo cp target/release/alacritty /usr/local/bin
    sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database

    sudo mkdir -p /usr/local/share/man/man1
    gzip -c extra/alacritty.man | sudo tee /usr/local/share/man/man1/alacritty.1.gz > /dev/null

    rm -rf /tmp/alacritty
  ;;
  "Darwin")
    brew cask install ${BREW_CASK}
  ;;
  *)
    echo "${OS} is not supported"
    exit 1
  ;;
esac
