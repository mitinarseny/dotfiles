#!/bin/sh

install() {
  for type in Bold Light Medium Regular Retina; do
    file_path="$1/FiraCode-${type}.ttf"
    file_url="https://github.com/tonsky/FiraCode/blob/master/distr/ttf/FiraCode-${type}.ttf?raw=true"
    if [ ! -e "${file_path}" ]; then
        echo "wget -O ${file_path} ${file_url}"
        wget -O "${file_path}" "${file_url}"
    fi;
  done
}

if [ "$(uname -s)" = "Darwin" ]; then
	if command -v brew >/dev/null 2>&1; then
		brew tap homebrew/cask-fonts
		brew cask install font-fira-code
	else
		install ~/Library/Fonts
	fi
else
	mkdir -p ~/.fonts
	install ~/.fonts
  fc-cache --force --verbose ~/.fonts
fi
