#!/bin/sh -u

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

NVIMDIR="${HOME}/.config/nvim"
mkdir -p "${NVIMDIR}"
ln -si "${SCRIPT_DIR}/init.vim" "${NVIMDIR}"
ln -si "${SCRIPT_DIR}/plugins.vim" "${NVIMDIR}"
ln -si "${SCRIPT_DIR}/coc-settings.json" "${NVIMDIR}"

