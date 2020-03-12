CONFIG_DIR := ~/.config/nvim

.PHONY: dotfiles
dotfiles: $(addprefix $(CONFIG_DIR)/,\
		init.vim \
		plugins.vim \
		coc-settings.json \
		$(wildcard ftplugin/*) \
	)

$(CONFIG_DIR)/%: %
	@mkdir -p $(@D)
	@ln -svf $(realpath $<) $@

