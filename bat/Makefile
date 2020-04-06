ifneq (,$(shell command -v bat))
CONFIG_DIR := $(shell bat --config-dir)
CACHE_DIR := $(shell bat --cache-dir)
else
CONFIG_DIR := ~/.config/bat
$(warning bat was not found in PATH, assuming config dir is $(CONFIG_DIR))
endif

$(CONFIG_DIR)/config: config | $(CONFIG_DIR)
	@ln -svf $(realpath $<) $@

$(CONFIG_DIR):
	@mkdir -p $@

ifneq (,$(CURDIR))
.PHONY: cache
cache: $(CACHE_DIR)/themes.bin

$(CACHE_DIR)/themes.bin: $(CURDIR)
	bat cache --build --source $(CURDIR)
endif
