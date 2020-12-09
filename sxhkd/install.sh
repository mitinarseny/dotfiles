#!/bin/sh -e

CONFIG_DIR=~/.config/sxhkd
cd "$(dirname "$0")"

[ -d "${CONFIG_DIR}" ] || mkdir -p "${CONFIG_DIR}"
ln -sfv "$(pwd -P)"/sxhkdrc "${CONFIG_DIR}"
