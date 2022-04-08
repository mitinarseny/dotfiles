include ../inc.mk

CONFIG_DIR := $(XDG_CONFIG_HOME)/yambar

.PHONY: all
all: install dotfiles services

.PHONY: dotfiles
dotfiles: $(CONFIG_DIR)/config.yml

$(CONFIG_DIR)/config.yml: config.yml
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PHONY: install
ifneq (,$(filter void,$(DISTRO_ID)))
install: | install_pkgs
install_pkgs: PKGS += yambar
else
install: ; $(ERR_OS)
endif
