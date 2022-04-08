include ../inc.mk

CONFIG_DIR := $(XDG_CONFIG_HOME)/waylock

.PHONY: all
all: install dotfiles

.PHONY: dotfiles
dotfiles: $(CONFIG_DIR)/waylock.toml $(HOME)/.onsuspend

$(CONFIG_DIR)/waylock.toml: waylock.toml
	@mkdir -p $(dir $@)
	@$(LNS) $(realpath $<) $@

$(HOME)/.onsuspend: onsuspend | install_zzz_user_hooks

.PHONY: install
ifneq (,$(filter void,$(DISTRO_ID)))
install: | install_pkgs
install_pkgs: PKGS += waylock
else
install: ; $(ERR_OS)
endif

.PHONY: install_zzz_user_hooks
ifneq (,$(filter void,$(DISTRO_ID)))
install_zzz_user_hooks: | install_pkgs
install_pkgs: PKGS += zzz-user-hooks
else
install_zzz_user_hooks: ; $(ERR_OS)
endif
