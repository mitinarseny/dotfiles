#!/bin/sh -e

CONFIG_DIR=~/.config/git
[ -d "${CONFIG_DIR}" ] || mkdir -p "${CONFIG_DIR}"

[ -r ~/.gitconfig ] && mv ~/.gitconfig "${CONFIG_DIR}/config" || touch "${CONFIG_DIR}/config"

cd "$(dirname "$0")"

if ! git config --global --get include.path "$(pwd -P)"/config.local > /dev/null; then
  git config --global --add include.path "$(pwd -P)"/config.local
fi

if ! git config --global --get core.excludesfile "$(pwd -P)"/excludes > /dev/null; then
  git config --global --add core.excludesfile "$(pwd -P)"/excludes
fi

if ! git config --global --get credential.helper > /dev/null; then
  case "$(uname -s)" in
    "Linux")
      CREDENTIAL_HELPER=osxkeychain
      ;;
    "Darwin")
      CREDENTIAL_HELPER=cache
      ;;
  esac
  git config --global credential.helper "${CREDENTIAL_HELPER}"
fi

if ! git config --global --get user.email > /dev/null; then
  read -r -p 'GitHub author email: ' user_email
  git config --global user.email "${user_email}"
fi

if ! git config --global --get user.name > /dev/null; then
  read -r -p 'GitHub author name: ' user_name
  git config --global user.name "${user_name}"
fi
