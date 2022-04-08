include ../inc.mk

CONFIG_DIR := $(XDG_CONFIG_HOME)/foot

.PHONY: all
all: install dotfiles services

.PHONY: dotfiles
dotfiles: $(CONFIG_DIR)/foot.ini

$(CONFIG_DIR)/%.ini: %.ini
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PHONY: install
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
install: | install_pkgs
install_pkgs: PKGS += foot
else
install: ; $(ERR_OS)
endif
