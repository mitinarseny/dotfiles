#!/bin/sh -e

CONFIG_DIR=~/.config/bat

[ -d "${CONFIG_DIR}" ] || mkdir -p "${CONFIG_DIR}"
cd "$(dirname "$0")"

ln -svf "$(pwd -P)"/config "${CONFIG_DIR}"

