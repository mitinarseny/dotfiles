#!/bin/sh -e

CONFIG_DIR=~/.config/i3

[ -d "${CONFIG_DIR}" ] || mkdir -p "${CONFIG_DIR}"
cd "$(dirname "$0")"

ln -sfv "$(pwd -P)"/config "${CONFIG_DIR}"
