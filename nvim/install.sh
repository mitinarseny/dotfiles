#!/bin/sh -e

CONFIG_DIR=~/.config/nvim

cd "$(dirname "$0")"

[ -d "${CONFIG_DIR}" ] || mkdir -p "${CONFIG_DIR}"
ln -sfv $(printf "$(pwd -P)/%s " init.vim plugins.vim) "${CONFIG_DIR}"

[ -d "${CONFIG_DIR}/ftplugin" ] || mkdir -p "${CONFIG_DIR}/ftplugin"
ln -sfv $(printf "$(pwd -P)/%s " ftplugin/*.vim) "${CONFIG_DIR}/ftplugin"
