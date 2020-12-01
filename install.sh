#!/bin/sh -e

. ./helpers.sh

for i in */install.sh; do
  log_info "Installing $(dirname $i)...\n"
  cd "$(dirname $i)" && ./$(basename $i)
done
