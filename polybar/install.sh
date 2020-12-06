#!/bin/sh -e

CONFIG_DIR=~/.config/polybar
cd "$(dirname "$0")"

ln -sfv "$(pwd -P)"/config "${CONFIG_DIR}"
