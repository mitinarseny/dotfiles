CONFIG_DIR := ~/.config/alacritty

$(CONFIG_DIR)/alacritty.yml: alacritty.yml | $(CONFIG_DIR)
	@ln -svf $(realpath $<) $@

$(CONFIG_DIR):
	@mkdir -p $@
