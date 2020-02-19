#!/bin/sh -e

ln -si $(cd "$(dirname "$0")" && pwd)/tmux.conf ${HOME}/.tmux.conf

