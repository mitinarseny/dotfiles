ifneq (,$(shell command -v bat))
CONFIG_DIR := $(shell bat --config-dir)
else
CONFIG_DIR := ~/.config/bat
$(warning bat was not found in PATH, assuming config dir is $(CONFIG_DIR))
endif

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
	
