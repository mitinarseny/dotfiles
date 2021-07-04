#!/bin/sh -e

CONFIG_DIR=${XDG_CONFIG_DIR:-"${HOME}/.config"}/foot
[ -d "${CONFIG_DIR}" ] || mkdir -p "${CONFIG_DIR}"

cd "$(dirname "$0")"

ln -svf "$(pwd -P)"/foot.ini "${CONFIG_DIR}"
ln -svf "$(pwd -P)"/spotlight.ini "${CONFIG_DIR}"
