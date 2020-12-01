#!/bin/sh -e

CONFIG_DIR=~/.config

[ -d "${CONFIG_DIR}" ] || mkdir -p "${CONFIG_DIR}"

cd "$(dirname "$0")"
ln -sfv $(readlink -ev flake8) "${CONFIG_DIR}"
