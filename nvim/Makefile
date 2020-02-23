CONFIG_DIR := ~/.config/nvim

.PHONY: dotfiles
dotfiles: $(CONFIG_DIR) \
	$(addprefix $(CONFIG_DIR)/,\
		init.vim \
		plugins.vim \
		coc-settings.json \
	)

$(CONFIG_DIR):
	mkdir -p $@

$(CONFIG_DIR)/%: %
	ln -si $(realpath $<) $@

