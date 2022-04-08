include ../inc.mk

CONFIG_DIR := $(XDG_CONFIG_HOME)/nord

.PHONY: dotfiles
dotfiles: $(CONFIG_DIR)/colors.sh

$(CONFIG_DIR)/colors.sh: colors.sh
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@
