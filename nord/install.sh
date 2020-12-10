#!/bin/sh

CONFIG_DIR=~/.config/nord
[ -d "${CONFIG_DIR}" ] || mkdir -p "${CONFIG_DIR}"

cd $(dirname $(readlink $0 || echo $0))
ln -sfv "$(pwd -P)"/colors.sh "${CONFIG_DIR}" 
