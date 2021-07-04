#!/bin/sh -e

CONFIG_DIR=${XDG_CONFIG_DIR:-"${HOME}/.config"}/waylock
[ -d "${CONFIG_DIR}" ] || mkdir -p "${CONFIG_DIR}"

cd "$(dirname "$0")"

ln -svf "$(pwd -P)"/waylock.toml "${CONFIG_DIR}"
ln -svf "$(pwd -P)"/onsuspend ~/.onsuspend
