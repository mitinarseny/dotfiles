include ../inc.mk

.PHONY: install
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
install: | install_pkgs
install_pkgs: PKGS += python3
else
install: ; $(ERR_OS)
endif
