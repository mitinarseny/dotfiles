include ../inc.mk

.PHONY: install
ifneq (,$(filter void arch ubuntu debian,$(DISTRO_ID)))
install: | install_pkgs
ifneq (debian,$(DISTRO_ID))
install_pkgs: PKGS += firefox
else
install_pkgs: PKGS += firefox-esr
endif
else
install: ; $(ERR_OS)
endif
