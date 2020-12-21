#!/bin/sh -e

CONFIG_DIR=~/.ssh
[ -d "${CONFIG_DIR}" ] || mkdir -p "${CONFIG_DIR}"

cd $(dirname $0)
ln -sfv "$(pwd -P)"/config "${CONFIG_DIR}"
