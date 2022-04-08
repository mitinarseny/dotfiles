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
install_pkgs: PKGS += tmux
else
install: ; $(ERR_OS)
endif
