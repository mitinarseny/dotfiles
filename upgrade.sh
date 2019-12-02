#!/bin/sh
#
# Run all dotfiles installers.
set -e

cd "$(dirname "$0")"

# find the installers and run them iteratively
git ls-tree --name-only -r HEAD | grep upgrade.sh | while read -r upgrader; do
	echo "› ${upgrader}..."
	sh -c "${upgrader}"
done
