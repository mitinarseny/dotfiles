#!/bin/sh -e

CONFIG_DIR="${XDG_CONFIG_HOME:-"${HOME}/.config"}/yambar"
[ -d "${CONFIG_DIR}" ] || mkdir -p "${CONFIG_DIR}"

cd $(dirname $0)

ln -sfv "$(pwd -P)/config.yml" "${CONFIG_DIR}"
