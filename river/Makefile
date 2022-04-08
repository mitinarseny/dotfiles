include ../inc.mk

CONFIG_DIR := $(XDG_CONFIG_HOME)/river

.PHONY: all
all: install dotfiles profiles services

.PHONY: dotfiles
dotfiles: $(CONFIG_DIR)/init

$(CONFIG_DIR)/init: init | $(addprefix make_,\
	alacritty \
	foot \
	mako \
	nord \
	pipewire \
	sv \
	wob \
	yambar \
)
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PHONY: install
ifneq (,$(filter void,$(DISTRO_ID)))
install: | install_pkgs
install_pkgs: PKGS += river
else
install: ; $(ERR_OS)
endif
