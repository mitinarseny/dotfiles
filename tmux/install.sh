#!/bin/sh -e

ln -si $(cd "$(dirname "$0")" && pwd)/tmux.conf ${HOME}/.tmux.conf

command -v tmux > /dev/null 2>&1 || (echo 'tmux is not in ${PATH}'; exit 1)

[ ! -d "${HOME}/.tmux/plugins/tpm" ] \
  && git clone https://github.com/tmux-plugins/tpm "${HOME}/.tmux/plugins/tpm"

${HOME}/.tmux/plugins/tpm/bin/install_plugins
