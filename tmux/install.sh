#!/bin/sh -e

cd "$(dirname "$0")"
ln -sfv $(readlink -ev tmux.conf) ~/.tmux.conf
