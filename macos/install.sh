#!/bin/sh

if [ "$(uname -s)" != "Darwin" ]; then
	exit 0
fi

cd $(dirname "$0")

source set-defaults.sh

source set-default-apps.sh < default_apps.txt

# brew bundle -f Brewfile
