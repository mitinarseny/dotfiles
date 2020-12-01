#!/bin/sh -e

CONFIG_DIR=~/.config/alacritty

[ -d "${CONFIG_DIR}" ] || mkdir -p "${CONFIG_DIR}"

ln -svf $(readlink -ev \
    alacritty.yml
  ) "${CONFIG_DIR}"
