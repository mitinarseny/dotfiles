#!/bin/sh

CONFIG_DIR=~/.config/fontconfig
[ -d "${CONFIG_DIR}" ] || mkdir -p "${CONFIG_DIR}"

cd $(dirname $(readlink $0 || echo $0))
ln -sfv "$(pwd -P)"/fonts.conf "${CONFIG_DIR}"

fc-cache --force --verbose
