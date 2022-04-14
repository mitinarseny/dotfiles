include ../inc.mk

.PHONY: all
all: install dotfiles

.PHONY: dotfiles
dotfiles: $(HOME)/.tmux.conf

$(HOME)/.tmux.conf: tmux.conf
	@$(LNS) $(realpath $<) $@

.PHONY: install
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
install: | install_pkgs
install_pkgs: PKGS += 'tmux>=3.2'
ifeq (void,$(DISTRO_ID))
install_pkgs: PKGS += 'ncurses-term>=6.3'
endif
else
install: ; $(ERR_OS)
endif
