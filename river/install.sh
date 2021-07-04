#!/bin/sh -e

CONFIG_DIR=${XDG_CONFIG_DIR:-"${HOME}/.config"}/river
[ -d "${CONFIG_DIR}" ] || mkdir -p "${CONFIG_DIR}"

cd "$(dirname "$0")"

ln -svf "$(pwd -P)"/init "${CONFIG_DIR}"
