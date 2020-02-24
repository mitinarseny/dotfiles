CONFIG_DIR := $(shell bat --config-dir)

.PHONY: dotfiles
dotfiles: $(CONFIG_DIR)/config

$(CONFIG_DIR):
	@mkdir -p $@

$(CONFIG_DIR)/%: % | $(CONFIG_DIR)
	@ln -svf $(realpath $<) $@

.PHONY: all
all: dotfiles cache

.PHONY: cache
cache: $(CURDIR)
	bat cache --build --source $(CURDIR)
	
