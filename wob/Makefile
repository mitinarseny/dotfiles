include ../inc.mk

CONFIG_DIR := $(XDG_CONFIG_HOME)/wob

.PHONY: all
all: install dotfiles services

.PHONY: dotfiles
dotfiles: $(CONFIG_DIR)/conf.sh

$(CONFIG_DIR)/conf.sh: conf.sh
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PHONY: install
ifneq (,$(filter void ubuntu debian,$(DISTRO_ID)))
install: | install_pkgs
install_pkgs: PKGS += wob
else
install: ; $(ERR_OS)
endif
