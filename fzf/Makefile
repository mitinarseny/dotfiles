include ../inc.mk

.PHONY: install
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
install: | install_pkgs
install_pkgs: PKGS += fzf
else
install: ; $(ERR_OS)
endif
