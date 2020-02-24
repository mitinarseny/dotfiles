CONFIG_DIR := ~/.config/nvim

.PHONY: dotfiles
dotfiles: $(addprefix $(CONFIG_DIR)/,\
		init.vim \
		plugins.vim \
		coc-settings.json \
	)

$(CONFIG_DIR):
	@mkdir -p $@

$(CONFIG_DIR)/%: % | $(CONFIG_DIR)
	@ln -svf $(realpath $<) $@

