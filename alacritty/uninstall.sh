#!/bin/sh -e

uninstall_linux () {
  rm -f \
    /usr/local/bin/alacritty \
    /usr/share/pixmaps/Alacritty.svg \
    /usr/local/share/man/man1/alacritty.1.gz
}
