#!/bin/sh -e

BIN_DIR=/usr/local/bin
[ -d ${BIN_DIR} ] || mkdir -p ${BIN_DIR}

cd $(dirname $0)

ln -sfv $(printf "$(pwd -P)/%s " $(find * -executable -type f | grep -vxF $(basename $0))) ${BIN_DIR}
