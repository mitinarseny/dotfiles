#!/bin/sh -e

APPS_DIR=${XDG_DATA_HOME:-~/.local/share}/applications
[ -d "${APPS_DIR}" ] || mkdir -p "${APPS_DIR}"

cd "$(dirname "$0")"

ln -sfv $(printf "$(pwd -P)/%s " *.desktop) "${APPS_DIR}"

xdg-settings set default-web-browser firefox.desktop
