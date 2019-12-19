#!/bin/sh

success() {
	# shellcheck disable=SC2059
	printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

link_file() {
  # TODO: use ln --backup
	if [ -e "$2" ]; then
		if [ "$(readlink "$2")" = "$1" ]; then
			success "skipped $1"
			return 0
		else
			mv "$2" "$2.backup"=
			success "moved $2 to $2.backup"
		fi
	fi
	ln -sf "$1" "$2"
	success "linked $1 to $2"
}

if command -v nvim @>/dev/null; then
  mkdir -p ~/.config/nvim
  link_file "${HOME}/.dotfiles/nvim/init.vim" "${HOME}/.config/nvim/init.vim"
  link_file "${HOME}/.dotfiles/nvim/plugins.vim" "${HOME}/.config/nvim/plugins.vim"
  link_file "${HOME}/.dotfiles/nvim/coc-settings.json" "${HOME}/.config/nvim/coc-settings.json"
fi

