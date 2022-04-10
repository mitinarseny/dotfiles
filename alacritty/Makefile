include ../inc.mk

.PHONY: all
all: install dotfiles

CONFIG_DIR = $(XDG_CONFIG_HOME)/alacritty

.PHONY: dotfiles
dotfiles: $(CONFIG_DIR)/alacritty.yml

$(CONFIG_DIR)/alacritty.yml: alacritty.yml | make_tmux
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

.PHONY: install
ifneq (,$(filter void arch,$(DISTRO_ID)))
install: | install_pkgs
install_pkgs: PKGS += alacritty
else
install: | make_rust
	cargo install alacritty
endif
