#!/bin/sh
#
# Run all dotfiles installers.
set -e

cd "$(dirname "$0")"

# find the installers and run them iteratively
git ls-files '*/install.sh' | while read -r installer; do
	echo "› ${installer}..."
	sh -c "${installer}"
done
