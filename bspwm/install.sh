#!/bin/sh -e

CONFIG_DIR=~/.config/bspwm
cd "$(dirname "$0")"

[ -d "${CONFIG_DIR}" ] || mkdir -p "${CONFIG_DIR}"
ln -sfv \
  "$(pwd -P)"/bspwmrc \
  "$(pwd -P)"/sxhkdrc \
  "${CONFIG_DIR}"
