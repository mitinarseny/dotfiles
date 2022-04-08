include ../inc.mk

CONFIG_DIR := $(XDG_CONFIG_HOME)/mako

.PHONY: all
all: install dotfiles services

.PHONY: dotfiles
dotfiles: $(CONFIG_DIR)/config

$(CONFIG_DIR)/config: config
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PHONY: install
ifneq (,$(filter void arch,$(DISTRO_ID)))
install: | install_pkgs
install_pkgs: PKGS += mako
else ifneq (,$(filter ubuntu,$(DISTRO_ID)))
install: | install_pkgs
install_pkgs: PKGS += mako-notifier
else
install: ; $(ERR_OS)
endif
