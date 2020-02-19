#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

ln -si "${SCRIPT_DIR}/editorconfig" "${HOME}/.editorconfig"
