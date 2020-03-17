ifneq (,$(shell command -v bat))
CONFIG_DIR := $(shell bat --config-dir)
else
CONFIG_DIR := ~/.config/bat
$(warning bat was not found in PATH, assuming config dir is $(CONFIG_DIR))
endif

$(CONFIG_DIR)/config: config | $(CONFIG_DIR)
	@ln -svf $(realpath $<) $@

$(CONFIG_DIR):
	@mkdir -p $@

.PHONY: cache
cache: $(CURDIR)
	bat cache --build --source $(CURDIR)

