#!/bin/sh

bundles="$(dirname "$(readlink --canonicalize-existing "$0")")/bundles.txt"

if command -v brew >/dev/null 2>&1; then
  brew tap | grep -q 'getantibody/tap' || brew tap getantibody/tap
  brew install antibody
else
  curl -sL https://git.io/antibody | sudo sh -s -- -b /usr/local/bin
fi

antibody bundle < "${bundles}" > ~/.zsh_plugins.sh