#!/bin/sh -e

FIRA_CODE_FONTS="Bold Light Medium Regular Retina"

OS="$(uname -s)"
case "${OS}" in
  "Linux")
    INSTALL_DIR=~/.fonts
    ;;
  "Darwin")
    INSTALL_DIR=~/Library/Fonts
    ;;
  *)
    echo "${OS} is not supported"
    exit 1
    ;;
esac

[ -d "${INSTALL_DIR}" ] || mkdir -p "${INSTALL_DIR}"

for f in ${FIRA_CODE_FONTS}; do
  curl --location --silent --show-error --output "${INSTALL_DIR}/FiraCode-$f.ttf" \
    "https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-$f.ttf?raw=true"
done

if [ "${OS}" = "Darwin" ] && ! command -v fc-cache > /dev/null; then
  echo "'fc-cache' not found in PATH. Install it with:\nbrew install fontconfig"
  exit 1
fi

fc-cache --force --verbose "${INSTALL_DIR}"
