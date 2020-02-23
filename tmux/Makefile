.PHONY: dotfiles
dotfiles: ~/.tmux.conf

~/.tmux.conf: tmux.conf
	ln -si $(realpath $<) $@

