include ../inc.mk

CONFIG_DIR := $(XDG_CONFIG_HOME)/fontconfig

.PHONY: all
all: install dotfiles cache

.PHONY: dotfiles
dotfiles: $(CONFIG_DIR)/fonts.conf

$(CONFIG_DIR)/fonts.conf: fonts.conf
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PHONY: install
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
install: | install_pkgs
install_pkgs: PKGS += fontconfig
else
install: ; $(ERR_OS)
endif

.PHONY: cache
cache:
	fc-cache --force --verbose
