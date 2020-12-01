#!/bin/sh -e

cd "$(dirname "$0")"
ln -sfv "$(pwd -P)"/tmux.conf ~/.tmux.conf
